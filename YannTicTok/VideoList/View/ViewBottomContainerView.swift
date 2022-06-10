//
//  ViewBottomContainerView.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/10.
//

import UIKit

private let kMarginToTop: CGFloat = 32

class ViewBottomContainerView: UIView {
    
    func calculateViewHeightAndUpdateUI(_ newModel: PostInfo?) -> CGFloat {
        postModel = newModel
        
        authorLabel.text = String.init(format: "@%@", postModel?.content?.nickname ?? "")
        
        let titleHeight = calculateHeightAndUpdateTitleLabelUI(postModel?.content?.title ?? "", postModel?.content?.topics ?? "")
        
        let authorHeight: CGFloat = 22
        let marginToBottom: CGFloat = 16
        
        guard titleHeight > 0 else {
            return authorHeight
        }
        return  kMarginToTop + authorHeight + titleHeight + marginToBottom;
    }
    
    
    private var postModel: PostInfo?
    
    private func calculateHeightAndUpdateTitleLabelUI(_ titleStr: String,_ tagsStr: String) -> CGFloat {
        guard titleStr.isEmpty == false else {
            titleLabel.text = ""
            return 0
        }
        
        //        if titleStr.contains("#") && tagsStr.isEmpty == false {
        //            // 根据正则表达式生成富文本
        //            // TODO: 根据正则表达式生成富文本???
        //        } else {
        //            titleLabel.text = titleStr
        //        }
        //
        titleLabel.text = titleStr
        
        titleLabel.preferredMaxLayoutWidth = width
        let titleHeight = (titleStr as NSString).boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)),
                                                              options: .usesLineFragmentOrigin.union(.usesFontLeading),
                                                              attributes: [NSAttributedString.Key.font : titleLabel.font!],
                                                              context: nil).size.height
        
        return titleHeight
    }
    
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
  
        addSubview(authorLabel)
        addSubview(titleLabel)
        setupLayout()
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

// MARK: - private methods
extension ViewBottomContainerView {
    private func setupLayout() {
        authorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
            make.bottom.equalTo(titleLabel.snp.top).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().offset(0)
        }
    }
}

