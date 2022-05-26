//
//  HomeVideoListController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit
import MJRefresh

// MARK: - 生命周期方法
extension HomeVideoListController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(tableView)
        
        weak var weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            weakSelf!.loadNewData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            //
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    
    func loadNewData() {
//        request(API.imgrank, parameters: ["page": 1]).responseJSON {
//            [weak self] response in
//            guard let dict = response.result.value else { return }
//            let jsons = JSON(dict)["items"].arrayObject
//            guard let models = modelArray(from: jsons, Item.self) else { return }
//
//            self?.items.removeAll()
//            self?.items.append(contentsOf: models)
//
//            self?.tableView.reloadData()
//            self?.tableView.mj_header.endRefreshing()
//
//            self?.page = 1
//        }
        
        
        QYHttpTool.GET(url:"http://m2.qiushibaike.com/article/list/imgrank", parameters: ["page": 1]).success { JSON in
            print(JSON)
            
            self.tableView.mj_header?.endRefreshing()
        }.failure { error in
            print(error)
        }
//        task.handleResponse(response: AFDataResponse<Any>)
    }
}



class HomeVideoListController: UIViewController {

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
//    lazy var items = [Item]()
   
    var page = 0
    
    

    


}


extension HomeVideoListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        tableView.mj_footer.isHidden = items.count == 0
//        return items.count
        return 10
    }
    
    static let ItemCellId = "item"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var tmpCell = tableView.dequeueReusableCell(withIdentifier: Self.ItemCellId)
        if tmpCell == nil {
        tmpCell = HomeVideoListCell(style: .subtitle, reuseIdentifier: Self.ItemCellId)
            let videoCell:HomeVideoListCell = tmpCell as! HomeVideoListCell
            videoCell.frame = view.bounds;
            let videoVC: VideoViewController = VideoViewController.init()

            addChild(videoVC)
            videoCell.videoVC = videoVC
 
        }
        
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
