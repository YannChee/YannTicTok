//
//  MineViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        KTVHTTPCache.cacheDeleteAllCaches()
        
    }

}
