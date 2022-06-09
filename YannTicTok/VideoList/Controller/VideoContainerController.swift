//
//  VideoContainerController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import UIKit


// MARK: 属性
class VideoContainerController: UIViewController {
    
    lazy var videoPlayerVC:VideoMediaController = VideoMediaController()
    
    lazy var interactionVC:VideoInteractionController = VideoInteractionController()
    
    var postModel: PostInfo? {
        
        didSet {
            videoPlayerVC.postModel = postModel
        }
    }
    

        
}

// MARK: - 生命周期
extension VideoContainerController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(videoPlayerVC)
        addChild(interactionVC)
        
        interactionVC.playerVC = videoPlayerVC
        view.addSubview(videoPlayerVC.view)
        view.addSubview(interactionVC.view)
          
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPlayerVC.view.frame = view.bounds
        interactionVC.view.frame = view.bounds

//        progressLabelView.bottom = view.height - 51
//        self.sliderView.bottom = view.bottom
        
    }
    

  
  
    
    
}


//    lazy var backgroundImgV:UIImageView = {
//        let imgV = UIImageView()
//
//        // 根据宽高比生成新的图片
//        let originImage = UIImage(named: "Post_PostInfoBG")!
//        let targetWidth = kScreenWidth
//        let targetHeight = targetWidth * (originImage.size.height) / (originImage.size.width)
//        let newImage = originImage.byResize(to: CGSize(width: targetWidth, height: targetHeight))
//        imgV.image = newImage
//        return imgV
//    }()
