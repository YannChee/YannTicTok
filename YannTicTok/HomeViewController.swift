//
//  HomeViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    var videoListVC: HomeVideoListController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.blue
        
        videoListVC = HomeVideoListController.init()
        addChild(videoListVC)
        view.addSubview(videoListVC.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoListVC.view.frame = view.bounds
    }
    
}
