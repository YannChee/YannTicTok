//
//  MainNavigationControllerController.swift
//  YannTicTok
//
//  Created by YannCheeMac2015 on 2022/5/26.
//

import UIKit

class MainNavigationControllerController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationBar.scrollEdgeAppearance = appearance

    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            // if是为了解决push回来时，没有底部导航的问题
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
}
