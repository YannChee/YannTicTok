//
//  HomeVideoListCell.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

class HomeVideoListCell: UITableViewCell {
    
    public var containerVC: VideoContainerController! {
        didSet {
            contentView.subviews.forEach {
                $0.removeFromSuperview()
            }
            
            contentView.addSubview(containerVC.view)
         
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerVC.view.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}
