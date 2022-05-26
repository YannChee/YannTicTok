//
//  HomeVideoListController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit
import MJRefresh
import SwiftyJSON

// MARK: - 生命周期方法
extension HomeVideoListController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(tableView)
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf!.requestList(isPullingDown: true)
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            //
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    
    
    func requestList(isPullingDown: Bool) {
        let param = [
            "topicName": "美女",
            "tab": 0,
            "topicId": 10548,
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
        
        QYHttpTool.POST(url: "https://server.sortinghat.cn/api/topic/topicRecommendPostList",
                        parameters: param,headers:tempHeader).success {[weak self] responseObj in
            
            self!.tableView.mj_header?.endRefreshing()
            self!.tableView.mj_footer?.endRefreshing()
            self!.tableView.mj_footer?.isHidden = false;
            
            if isPullingDown {
                self!.modelList.removeAll()
            }
         
            let dictArr =  JSON(responseObj)["data"]["list"].arrayObject
        
            guard let modelArr:Array = [PostInfo].deserialize(from: dictArr) else {
                return
            }
            
            modelArr.forEach { postModel in
                self!.modelList.append(postModel!)
            }
            self?.tableView.reloadData()
            
        }.failure { error in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_footer?.isHidden = false;
        }
    }
}



class HomeVideoListController: UIViewController {

    lazy var modelList:Array = [PostInfo]()
    
    
    lazy var tableView: UITableView = {
        let listView = UITableView.init(frame: view.bounds, style: .grouped)
        listView.delegate = self;
        listView.dataSource = self;
        listView.showsVerticalScrollIndicator = true
        listView.backgroundColor = .black
        listView.separatorStyle = .none
        listView.isPagingEnabled = true
        listView.estimatedRowHeight = 0.0
        listView.estimatedSectionHeaderHeight = 0.0
        listView.estimatedSectionFooterHeight = 0.0
        listView.contentInsetAdjustmentBehavior = .never
        listView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            listView.sectionHeaderTopPadding = 0.0
        }
        
        return listView
    } ()

   
    var page = 0
    
    

    


}


extension HomeVideoListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.modelList.count
    }
    
    static let ItemCellId = "item"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var model = modelList[indexPath.row]
        
        var tmpCell = tableView.dequeueReusableCell(withIdentifier: Self.ItemCellId)
        if tmpCell == nil {
        tmpCell = HomeVideoListCell(style: .subtitle, reuseIdentifier: Self.ItemCellId)
            let videoCell:HomeVideoListCell = tmpCell as! HomeVideoListCell
            videoCell.frame = view.bounds;
            let videoVC: VideoViewController = VideoViewController.init()

            addChild(videoVC)
            videoCell.videoVC = videoVC
 
        }
        let videoCell:HomeVideoListCell = tmpCell as! HomeVideoListCell
        videoCell.videoVC.postModel = model;
        tmpCell!.backgroundColor = (indexPath.row % 2 == 0) ? .orange : .yellow
        return tmpCell!
    }
}


extension HomeVideoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
