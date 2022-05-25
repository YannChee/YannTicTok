//
//  HomeVideoListController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class HomeVideoListController: UIViewController {

    lazy var tableView: UITableView = {
        let listView = UITableView.init(frame: view.bounds, style: .grouped)
        listView.delegate = self;
        listView.dataSource = self;
        listView.showsVerticalScrollIndicator = true
        listView.backgroundColor = .black
        listView.separatorStyle = .none
        listView.isPagingEnabled = true
        listView.estimatedRowHeight = 0
        listView.estimatedSectionHeaderHeight = 0
        listView.estimatedSectionFooterHeight = 0
        listView.contentInsetAdjustmentBehavior = .never
        
        return listView
    } ()
//    lazy var items = [Item]()
   
    var page = 0
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

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
            let videoVC: UIViewController = UIViewController.init()

            addChild(videoVC)
            videoCell.viewController = videoVC
 
            
        }
        
        tmpCell!.backgroundColor = (indexPath.row % 2 == 0) ? .orange : .yellow
        return tmpCell!
    }
}

//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as? CustomTableViewCell
//    else {
//        fatalError("Unable to deque cell")
//        
//    }
//    cell.lbl.text = "test"
//    cell.settingImage.image = UIImage(named: "imgName")
//    return cell
//}
extension HomeVideoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height;
    }
}
