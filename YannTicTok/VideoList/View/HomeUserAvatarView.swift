//
//  HomeUserAvatarView.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/9.
//

import UIKit
import SnapKit
import Kingfisher

extension HomeUserAvatarView {
    
    private func setupLayout () {
        avatarBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(0)
            make.top.equalTo(self).offset(0)
            make.size.equalTo(avatarBtn.qy_size)
        }
        
        followBtn.snp.makeConstraints { make in
            make.size.equalTo(followBtn.qy_size)
            make.centerX.equalTo(avatarBtn)
            make.centerY.equalTo(avatarBtn.snp.bottom)
        }
        
        totalHeight = avatarBtn.qy_height + followBtn.qy_height * 0.5;
    }
    
    private func updateUI() {
        avatarBtn.kf.setImage(with: URL.init(string: contentModel?.avatar ?? ""),
                              for: .normal,
                              placeholder: UIImage.init(named: "TikTok_avatar_default"))
        
        let isFollowing = contentModel?.followStatus == .followEachOther || contentModel?.followStatus == .followTargetOnly
        followBtn.isHidden = isFollowing ? true : false
    }
}

class HomeUserAvatarView: UIView {

    var contentModel: PostContentInfo? {
        didSet {
            updateUI()
        }
    }
    
    private var totalHeight: CGFloat = 0

    lazy var avatarBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 54, height: 54))
        btn.imageView?.contentMode = .scaleAspectFill
        btn.layer.cornerRadius = 27
        btn.clipsToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
        return btn
    }()
    
    lazy var followBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 22))
        btn.setImage(UIImage(named: "user_avatar_follow"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarBtn)
        addSubview(followBtn)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func viewTotalHeight() -> CGFloat {
        return totalHeight
    }
    
}
