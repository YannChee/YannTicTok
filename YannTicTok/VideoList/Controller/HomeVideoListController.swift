//
//  HomeVideoListController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SwiftUI

// MARK: - 生命周期方法
extension HomeVideoListController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(tableView)
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf?.tableView.mj_footer?.isHidden = true
            weakSelf?.pageNum = 1
            weakSelf!.requestForDataList()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            weakSelf!.requestForDataList(pageNum: weakSelf?.pageNum ?? 1)
        })
        
        
        tableView.mj_header?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

}

// MARK: - networking
extension HomeVideoListController {
    
    func requestForDataList(pageNum:Int32 = 1) {
        let param = [
            "pageRequest":  [
                "pageNum" : pageNum,
                "pageSize" : 12
            ],
            "topicName": "美女",
            "tab": 0,
            "topicId": 10119, //10548, // 10119
            "deviceId": "BCE94472-E9A9-48D4-A38D-C987EBC30339",
            "userId": 1630431855104
        ] as [String : Any]
        
        let tempHeader = [
            "authToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuaWNrTmFtZSI6IueskeWHuuiCvuiZmueahOWcsOaWuSIsImZhaWx1cmVUaW1lIjoiMTY1NDk1NzM3MTIwNyIsInR5cGUiOiIyIiwidXNlcklkIjoiMTYzMDQzMTg1NTEwNCJ9.KUjJ-NZeNKMRFtdJcqK0tbs8mwbNVE_oslDrnTvh4lY",
            "User-Agent" : "Funnyplanet/1.4.7 (iPhone; iOS 15.4.1; Scale/3.00)",
            "userId" : "1630431855104",
            "deviceType" : "iOS",
            "channel"    : "appStore",
            "os" : "apple",
            "Content-Type" : "application/json",
            "appver" :    "1.4.7"]
        let urlStr = "https://server.sortinghat.cn/api/topic/topicRecommendPostList";
        QYHttpTool.POST(url:urlStr ,
                        parameters: param,
                        headers:tempHeader).success {[weak self] responseObj in
            
            self!.tableView.mj_header?.endRefreshing()
            self!.tableView.mj_footer?.endRefreshing()
            self!.tableView.mj_footer?.isHidden = false;
            
            if pageNum == 1 {
                self?.modelList.removeAll()
                self?.pageNum = 1;
            }
            
            
            let dictArr =  JSON(responseObj)["data"]["list"].arrayObject
            
            guard let modelArr:Array = [PostInfo].deserialize(from: dictArr) else {
                return
            }
            
            modelArr.forEach { postModel in
                self!.modelList.append(postModel!)
            }
            self?.tableView.reloadData()
            self?.pageNum += 1
            
            
            DispatchQueue.main.async {
                self?.playVideoForFittestVC()
            }
        }.failure { error in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_footer?.isHidden = true;
        }
        
        }
}

// MARK: - 属性
class HomeVideoListController: UIViewController {
    // 接口参数页码
    var pageNum:Int32 = 1
    
    /// 当前cell 所在的index
    var currentIndex:Int32 = 0
    
    lazy var modelList:Array = [PostInfo]()
    
    /// 正在暂停的vc
    private var pausingVideoVC: VideoMediaController? = nil
    /// 正在播放的vc
    private var playingVideoVC: VideoMediaController? = nil
    
    
    /// 手指拖拽起点index ,默认-1
    private var dragStartIndex: Int32 = -1
    
  
    lazy var tableView: UITableView = {
        let listView = UITableView.init(frame: view.bounds, style: .grouped)
        listView.delegate = self;
        listView.dataSource = self;
        listView.showsVerticalScrollIndicator = true
        listView.backgroundColor = .black
        listView.separatorStyle = .none
        listView.isPagingEnabled = false
        listView.estimatedRowHeight = 0
        listView.estimatedSectionHeaderHeight = 0
        listView.estimatedSectionFooterHeight = 0
        listView.contentInsetAdjustmentBehavior = .never
        listView.showsVerticalScrollIndicator = false
        listView.scrollsToTop = false
//        if #available(iOS 15.0, *) {
//            listView.sectionHeaderTopPadding = 0
//        }
        
        return listView
    } ()

    

}



// MARK: - 播放相关
extension HomeVideoListController {
    
    /** 除了targetVC 播放外,其它播放器都停止播放, 如果targetVC 为空,则stop所有VC播放  ,从头开始放*/
    func onlyPlayVideoForVC(targetVC: VideoMediaController?) {
        var isCanPlay = false
        for childVC in self.children {
            guard let videoContainerVC:VideoContainerController = childVC as? VideoContainerController else {
                continue
            }
            
            guard videoContainerVC.videoPlayerVC.isMember(of: VideoMediaController.self) else {
                continue
            }
            
            let videoVC: VideoMediaController = videoContainerVC.videoPlayerVC
            if (targetVC != nil && targetVC == videoVC) {
                isCanPlay = true
            } else {
                videoVC.stopVideo()
            }
            
        }
        
        guard isCanPlay else { return }
        
        targetVC?.initUrlPlayerAndNotAutoPlay()
        targetVC?.playVideo()
    }
    
    /** 除了targetVC 暂停外,其它播放器都停止播放, 如果targetVC 为空,则停止所有VC播放 ,从头开始放 */
    func onlyPauseVideoForVC(targetVC: VideoMediaController?) {
        var isCanPuase = false
        for childVC in self.children {
            guard childVC.isMember(of: VideoMediaController.self) else {
                continue
            }
            
            let videoVC: VideoMediaController = childVC as! VideoMediaController
            
            if (targetVC != nil && targetVC == childVC) {
                isCanPuase = true
            } else {
                videoVC.stopVideo()
            }
        }
        guard isCanPuase else { return }
        
        targetVC?.pauseVideo()
        pausingVideoVC = targetVC
    }
    
    private func getCenterVideoCell() -> HomeVideoListCell? {
        
        let isVisible = isViewLoaded && (view.window != nil) && !(view.isHidden || tableView.isHidden)
        guard isVisible else {
            return nil
        }
        
        let cell =  tableView.findMinCenterCell()
        
        guard cell is HomeVideoListCell else { return nil }
        return cell as? HomeVideoListCell
    }
    
    
    
    // MARK: 找到最合适的VC来播放视频: 从头播放 或者 按暂停的视频继续播放
    func playVideoForFittestVC() {
        
        // 1.取出屏幕中心cell
        guard let playCell: HomeVideoListCell = getCenterVideoCell()  else {
            return
        }
        
        // 2.播放cell中的视频
        let playVC:VideoMediaController = playCell.containerVC.videoPlayerVC
        
        if (pausingVideoVC != nil && pausingVideoVC == playVC){ // 继续播放
            pausingVideoVC!.playVideo()
        } else { // 从头播放
            onlyPlayVideoForVC(targetVC: playVC)
        }
        
        playingVideoVC = playVC
        pausingVideoVC = nil
        
    }
    
        
}

// MARK: - tableView 代理:
// MARK: 1.tableView dataSouce
extension HomeVideoListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.modelList.count
    }
    
    static let ItemCellId = "item"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tmpCell = tableView.dequeueReusableCell(withIdentifier: Self.ItemCellId)
        
        guard let videoCell:HomeVideoListCell = tmpCell as? HomeVideoListCell else {
          let videoCell:HomeVideoListCell = HomeVideoListCell(style: .subtitle, reuseIdentifier: Self.ItemCellId)
            videoCell.frame = view.bounds;
            let videoContainerVC: VideoContainerController = VideoContainerController.init()
            videoCell.frame = view.bounds;
            
            addChild(videoContainerVC)
            videoCell.containerVC = videoContainerVC
            return videoCell;
        }
        return videoCell
    }
    
  
}


// MARK: 2.tableView delegate
extension HomeVideoListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 0.更新cell model
        let model = modelList[indexPath.row]
        let videoCell:HomeVideoListCell = cell as! HomeVideoListCell;
        videoCell.containerVC.postModel = model;
        
        // 1.是否预请求下一页数据接口
        let isNeedAutoLoadNext = modelList.count >= 2 && indexPath.row == modelList.count - 2 && tableView.mj_footer?.isRefreshing == false
        if (isNeedAutoLoadNext) {
            //                    [self requestForDataListWithPullingDown:NO];
        };
        
        // 2.预加载 视频, 图片
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(kTableViewMinSectionHeaderFooterHeight)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(kTableViewMinSectionHeaderFooterHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

// MARK: - UIScrollViewDelegate
extension HomeVideoListController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dragStartIndex = currentIndex
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.modelList.count > 0 else {
            return
        }
        
        var isHeaderRefreshing = false
        switch self.tableView.mj_header?.state {
        case .pulling, .refreshing ,.willRefresh: do {
            isHeaderRefreshing = true
        }; break
        case .idle,.noMoreData,.none,_:
            isHeaderRefreshing = false
            break
        }
        
        guard isHeaderRefreshing == false else {
            return
        }
        
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            let deltaDistant = self.view.qy_height * 0.1
            
            if translatedPoint.y < -deltaDistant && self.currentIndex < (self.modelList.count - 1) {
                self.currentIndex += 1
            }
            if translatedPoint.y > deltaDistant && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath.init(row: Int(self.currentIndex), section: 0), at: .top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
                if (self.dragStartIndex != self.currentIndex) {
                    self.playVideoForFittestVC()
                }
            })
            
           
        }
        
    }
}
