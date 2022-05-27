//
//  HomeViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit



class HomeViewController: UIViewController {
    
    var videoListVC: HomeVideoListController!
    
    override func loadView() {
        super.loadView()
        
        HomeViewController.configVideoProxy()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        view.backgroundColor = UIColor.blue
        
        videoListVC = HomeVideoListController.init()
        addChild(videoListVC)
        view.addSubview(videoListVC.view)
    }
    
    private class func configVideoProxy() {
        #if MyDebug
            KTVHTTPCache.logSetRecordLogEnable(true)
        #else
            KTVHTTPCache.logSetRecordLogEnable(false)
        #endif
        
        KTVHTTPCache.cacheSetMaxCacheLength(900 * 1024 * 1024) // 设置缓存最大容量: 视频最大900M
        KTVHTTPCache.encodeSetURLConverter { URL in
           return URL
        }
        KTVHTTPCache.downloadSetUnacceptableContentTypeDisposer { _, _ in
            return false
        }
        
        do {
            try  KTVHTTPCache.proxyStart()
        } catch {
            fatalError("KTVHTTPCache proxy error")
        }
        
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
