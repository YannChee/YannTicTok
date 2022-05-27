//
//  MainTabBarController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    var customTabBar: MainTabBar!
    var tabarItemArr = [UITabBarItem]()
    
    let select0IndxStatusImageArr:Array = ["ic_tab_home","ic_tab_discover_white","ic_tab_notifications_white","ic_tab_me_white"]
    let selectOtherIndxStatusImageArr:Array = ["ic_tab_home","ic_tab_discover","ic_tab_notifications","ic_tab_me"]
    
    var bgImgV:UIImageView? /**< tabbar 背景 */

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        setValue(MainTabBar(), forKeyPath: "tabBar")
        customTabBar = tabBar as? MainTabBar;

        addChildVC("Home", select0IndxStatusImageArr[0],"ic_tab_home_active_dark", HomeViewController.self)
        addChildVC("Discover", select0IndxStatusImageArr[1], "ic_tab_discover_active", DiscoverViewController.self)
        addChild(UIViewController.init())
        addChildVC("Inbox", select0IndxStatusImageArr[2], "ic_tab_notifications_active", InboxViewController.self)
        addChildVC("Me", select0IndxStatusImageArr[3],"ic_tab_me_active", MineViewController.self)
        
    }
    
    func addChildVC(_ title: String,
                  _ image: String,
                  _ selectedImage: String,
                  _ type: UIViewController.Type) {
        let child = MainNavigationControllerController(rootViewController: type.init())
        child.title = title
        child.tabBarItem.image = UIImage(named: image)
        child.tabBarItem.selectedImage = UIImage(named: selectedImage)
    
        child.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
        
        addChild(child)
        tabarItemArr.append( child.tabBarItem)
    }



    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //
    }
}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex

        if tabBarIndex == 2 {
            return
        }

        if tabBarIndex != 0 {
            customTabBar.bgImgV.backgroundColor = .white
            customTabBar.publishBtn.setImage(UIImage.init(named: "btn_home_add"), for: .normal)

            for(index,tabBarItem) in tabarItemArr.enumerated() {
                tabBarItem.setTitleTextAttributes([
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ], for: .selected)

                tabBarItem.image = UIImage(named: selectOtherIndxStatusImageArr[index])
            }


            return
        }

        customTabBar.bgImgV.backgroundColor = UIColor.black
        customTabBar.publishBtn.setImage(UIImage.init(named: "btn_home_add_white"), for: .normal)


        for(index,tabBarItem) in tabarItemArr.enumerated() {
            tabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)

            tabBarItem.image = UIImage(named: select0IndxStatusImageArr[index])
        }

        viewController.tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)
    }
}


