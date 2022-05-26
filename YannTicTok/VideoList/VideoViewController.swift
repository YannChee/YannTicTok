//
//  VideoViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import UIKit
import Kingfisher


// MARK: - 生命周期
extension VideoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        
        
        
        
        
        
        
        
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.player.isPaused
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        player.frame = view.bounds;
        playOrPauseBtn.bottom = view.height - 100
        progressLabelView.bottom = view.height - 51;
        self.sliderView.bottom = view.bottom;
        
        view.bringSubviewToFront(sliderView)
        view.bringSubviewToFront(playOrPauseBtn)
    }
    
    
    
    
    
    private func setupUI() {
       view.backgroundColor = UIColor.black
       view.addSubview(player.playerView)
       view.addSubview(playOrPauseBtn)
       view.addSubview(progressLabelView)
       view.addSubview(sliderView)
       view.bringSubviewToFront(backgroundImgV)
//       view.bringSubviewToFront(bottomContentView)
//       view.bringSubviewToFront(rightFunctionsView)
//       view.bringSubviewToFront(rejectReasonView)
    }

    
    func initUrlPlayerAndNotAutoPlay () {
        guard let urlStr =  postModel?.content?.url else {
            return
        }
        guard let videoUrl = NSURL.init(string: urlStr) else {
            return
        }
        
        if let localFileUrl = KTVHTTPCache.cacheCompleteFileURL(with: videoUrl as URL) {
            player.assetURL = localFileUrl
        } else {  // 设置代理 url
            let proxyUrl = KTVHTTPCache.proxyURL(withOriginalURL: videoUrl as URL)
            player.assetURL = proxyUrl!
        }
        
        player.placeholderImageView.isHidden = false
    }

}


class VideoViewController: UIViewController {

    var postModel: PostInfo? {
        
        didSet {
            // FIXME: xxxx
            guard let urlStr =  postModel?.content?.thumb else {
                return
            }
            guard let videoUrlCover = NSURL.init(string: urlStr) else {
                return
            }
            player.placeholderImageView.kf.setImage(with: videoUrlCover as URL)
        }
    }
    
    var videoCoverImg: UIImage?
    

    lazy var player: FPVideoPlayer = {
        let videoPlayer = FPVideoPlayer()
        return videoPlayer
    }()
    
    lazy var playOrPauseBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 56, height: 56))
        btn.setImage(UIImage(named: "Post_Pause"), for: .normal)
        btn.isHidden = true
        btn.center.x = kScreenWidth * 0.5
        playOrPauseBtn = btn
        return btn
    }()
    
    lazy var progressLabelView:FPPlayerProgressLabelView = {
        let view = FPPlayerProgressLabelView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 33))
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()

    lazy var sliderView:FPVideoPlayerSliderView = {
        sliderView = FPVideoPlayerSliderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        sliderView.contentMode = .bottom
        sliderView.allowTapped = false
        sliderView.maximumTrackTintColor = UIColor.clear
        sliderView.delegate = self
        sliderView.minimumTrackTintColor = UIColor.init(white: 1, alpha: 0.2)

        sliderView.backgroundColor = UIColor.clear
        sliderView.sliderRadius = 2
        sliderView.sliderHeight = 2
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_normal") ?? UIImage(),for: .normal)
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_selected") ?? UIImage(), for: .selected)
//        sliderView.expandResponseAreaBounds(UIEdgeInsets(top: 12, left: 0, bottom: 5, right: 0))
        return sliderView
    }()
    
    lazy var backgroundImgV:UIImageView = {
        let imgV = UIImageView()

        // 根据宽高比生成新的图片
        let originImage = UIImage(named: "Post_PostInfoBG")!
        let targetWidth = kScreenWidth
        let targetHeight = targetWidth * (originImage.size.height) / (originImage.size.width)
        let newImage = originImage.byResize(to: CGSize(width: targetWidth, height: targetHeight))
        imgV.image = newImage
        return imgV
    }()

}

// MARK: -
extension VideoViewController {

    /// 下载视频封面图
    func downloadVideoCoverImgThenShow () {
        player.placeholderImageView.isHidden = false
        let imgUrl:URL? = URL.init(string: postModel?.content?.thumb ?? "")
        
        player.placeholderImageView.kf.setImage(
            with: imgUrl,
            placeholder: nil,
            options: [.downloader(ImageDownloader.default),.downloadPriority(1)],
            completionHandler: {[weak self] result in
                self?.videoCoverImg = self?.player.placeholderImageView.image;
            })
        
    }
}



extension VideoViewController: FPVideoPlayerSliderViewDelegate {
    
}
