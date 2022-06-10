//
//  VideoRightContainerView.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/10.
//

import UIKit

class VideoRightContainerView: UIView {
    var postModel: PostInfo? {
        didSet {
            avatarView.contentModel = postModel?.content
        }
        
    }
    
   private lazy var avatarView:HomeUserAvatarView = {
        let avatar = HomeUserAvatarView.init(frame: CGRect.init(x: 0, y: 0, width: 52, height: 0))
        avatar.qy_height = avatar.viewTotalHeight()
        
        return avatar;
    }()
    
//    lazy var buttonsView:UIButton = {
//
//    }()
    
    

//    func viewHeight() -> CGFloat {
//        let btnsTopToAvatar:CGFloat = 20
//
//        return self.avtarView.viewTotalHeight + self.btnsView.viewTotalHeight + btnsTopToAvatar
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(avatarView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
