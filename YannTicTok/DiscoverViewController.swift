//
//  DiscoverViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit
import SwiftUI

class DiscoverViewController: UIViewController {

    let swiftUIVC = UIHostingController(rootView: DiscoverView())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(swiftUIVC)
        view.backgroundColor = .yellow
        view.addSubview(swiftUIVC.view)
    }
    
    override func viewDidLayoutSubviews() {
        swiftUIVC.view.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true;
    }

}
