//
//  MainTabBar.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class MainTabBar: UITabBar {
    
    
    /** 发布按钮 */
    lazy var publishBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "btn_home_add"), for: .normal)
        btn.addTarget(self, action: #selector(didClickedCenterButton), for: .touchUpInside)
        btn.backgroundColor = .clear
        return btn
    }()
    
    
    lazy var bgImgV: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = UIColor.black
        return imgV;
    }()
    
    typealias PublishBtnClickBlock = () -> ()
    var publishBtnClicked: PublishBtnClickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        isTranslucent = true
        shadowImage = UIImage()
        barTintColor = .clear
        unselectedItemTintColor = .lightGray
    
        
        addSubview(bgImgV)
        addSubview(publishBtn)
        sendSubviewToBack(bgImgV)
        

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bringSubviewToFront(publishBtn)
        publishBtn.frame = CGRect.init(x: 0, y: 0, width: bounds.size.width * 0.2, height: 49)
        publishBtn.center.x = center.x
        
        
        bgImgV.frame = bounds
    }
    
    
    @objc private func didClickedCenterButton () {
        publishBtnClicked?()
    }
    
}
