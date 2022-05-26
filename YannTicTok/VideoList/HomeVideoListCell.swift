//
//  HomeVideoListCell.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class HomeVideoListCell: UITableViewCell {
    
    public var videoVC: VideoViewController! {
        didSet {
            contentView.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            contentView.addSubview(videoVC.view)
            videoVC.view.frame = contentView.bounds
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
