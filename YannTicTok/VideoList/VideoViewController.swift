//
//  VideoViewController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import UIKit
import Kingfisher
import AVFoundation


// MARK: - 生命周期
extension VideoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBlocks()

       
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        player.frame = view.bounds
//        player.frame = CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 0.001)
        playOrPauseBtn.center = CGPoint.init(x: view.qy_width * 0.5, y: view.qy_height * 0.5)
        progressLabelView.bottom = view.height - 51
        self.sliderView.bottom = view.bottom
        
        view.bringSubviewToFront(sliderView)
        view.bringSubviewToFront(playOrPauseBtn)
    }
    
    
    
    
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(player.playerView)
        view.addSubview(progressLabelView)
       
        view.bringSubviewToFront(backgroundImgV)
        //       view.bringSubviewToFront(bottomContentView)
        //       view.bringSubviewToFront(rightFunctionsView)
        //       view.bringSubviewToFront(rejectReasonView)
        
        view.addSubview(playOrPauseBtn)
        view.addSubview(sliderView)
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


// MARK: - 播放器 block
extension VideoViewController {
    private func setupBlocks() {
        // 播放状态随时可播放
        player.playerReadyToPlay = {[weak self]  (_ , _) -> Void in
            self?.player.placeholderImageView.isHidden = true
        }
        
        player.playerDidToEnd = {[weak self]  (_) -> Void in
            self?.player.replay()
        }
        
        // MARK: 播放器点击
        player.singleTappedPlayer = { [weak self] () -> Void in
            guard self?.player.isPlaying == true else {
                // 非正在播放
                if (self?.player.isPaused == true) {
                    self?.playVideo()
                    self?.playOrPauseBtn.setImage(UIImage(named: "Post_Pause"), for: .normal)
                    self?.playOrPauseBtn.isHidden = true
                }
                return
            }
            self?.pauseVideo()
            self?.playOrPauseBtn.isHidden = false
            self?.playOrPauseBtn.setImage(UIImage(named: "Post_Play"), for: .normal)
        }
        
        
        player.playerLoadStateChanged = {[weak self]  (_ , loadState) -> Void in
            if loadState == .stalled &&  self?.player.currentPlayerManager.isPlaying == true {
                self?.sliderView.startAnimating()
            } else if loadState == .stalled || loadState == .prepare && self?.player.currentPlayerManager.isPlaying == true {
                self?.sliderView.startAnimating()
            } else {
                self?.sliderView.stopAnimating()
            }
        }
        
        player.playerPrepareToPlay = {[weak self] (_,_) -> Void in
            
        }
        
        player.playerPlayStateChanged = {[weak self] (_,playState) -> Void in
            if playState == .playStatePlaying {
                guard self?.player.currentPlayerManager.loadState == .stalled else {
                    if self?.player.currentPlayerManager.loadState == .stalled || self?.player.currentPlayerManager.loadState == .prepare {
                        self?.sliderView.startAnimating()
                    }
                    return
                }
                self?.sliderView.startAnimating()
                
                return
            }
            
            if playState == .playStatePaused || playState == .playStatePlayFailed {
                self?.sliderView.stopAnimating()
            }
            
        }
        
        player.playerPlayTimeChanged = {[weak self] (_,currentTime,duration) -> Void in
            self?.sliderView.isHidden = false
            
            if (duration <= 0) {
                self?.sliderView.value = 0;
            } else {
                self?.sliderView.value = Float(currentTime / duration);
            }
            
        }
        
        
                
    }
}

// MARK: - 播放器控制
extension VideoViewController {
    public func playVideo() {
        if (player.isMuted) {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [AVAudioSession.CategoryOptions.defaultToSpeaker,AVAudioSession.CategoryOptions.allowBluetooth])
        }
        player.play()
        
        playOrPauseBtn.isHidden = true
        playOrPauseBtn.setImage(UIImage(named: "Post_Pause"), for: .normal)
    }
    
    
    public func pauseVideo() {
        player.pause()
        
        playOrPauseBtn.setImage(UIImage(named: "Post_Play"), for: .normal)
    }
    
    public func stopVideo() {
        player.stop()
        
        player.placeholderImageView.isHidden = false;
    }
    
    
 
}

// MARK: 属性
class VideoViewController: UIViewController {
    
    var postModel: PostInfo? {
        
        didSet {
            
            guard let urlStr =  postModel?.content?.thumb else {
                return
            }
            guard let videoUrlCover = NSURL.init(string: urlStr) else {
                return
            }
            player.placeholderImageView.kf.setImage(with: videoUrlCover as URL ,placeholder: UIImage.init(named: "img_video_loading"))
        }
    }
    
    var videoCoverImg: UIImage?
    
    
    private lazy var player: FPVideoPlayer = {
        let videoPlayer = FPVideoPlayer()
        return videoPlayer
    }()
    
    
    
    lazy var playOrPauseBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 56, height: 56))
        btn.setImage(UIImage(named: "Post_Pause"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    
    lazy var progressLabelView:FPPlayerProgressLabelView = {
        let view = FPPlayerProgressLabelView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 33))
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    
    lazy var sliderView:FPVideoPlayerSliderView = {
       let sliderView = FPVideoPlayerSliderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
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
//        sliderView.
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


// MARK: - 进度条滑块
extension VideoViewController: FPVideoPlayerSliderViewDelegate {
    
    func changeSliderToBold() {
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_selected")!, for: .normal)
        sliderView.sliderHeight = 4
        sliderView.qy_bottom = view.qy_height
        sliderView.minimumTrackTintColor = .white
    }
    
    func changeSliderToOrigin () {
        sliderView.setThumbImage(UIImage(named: "Post_sliderbtn_normal")!, for: .normal)
        sliderView.sliderHeight = 2
        sliderView.minimumTrackTintColor = UIColor.init(white: 1, alpha: 0.2)
        sliderView.qy_bottom = view.qy_height
    }
    
  // 滑块滑动开始
    func sliderTouchBegan(_ value: Float) {
        sliderView.isdragging = true
        changeSliderToBold()
    }
    
    // 滑块滑动中
    func sliderValueChanged(_ value: Float) {
        guard player.totalTime > 0 else {
            sliderView.value = 0
            return
        }
        
//        bottomContentView.hidden = true
        progressLabelView.isHidden = false
        sliderView.isdragging = true
        
//        progressLabelView.currentTimeStr
    }

    // 滑块滑动结束
    func sliderTouchEnded(_ value: Float) {
        progressLabelView.isHidden = true
//        bottomContentView.hidden = false
        changeSliderToOrigin()
        
        if (player.totalTime > 0) {
            player.seek(toTime: player.totalTime * Double(value)) {[weak self] isFinished in
                if isFinished {
                    self?.sliderView.isdragging = false
                }
            }
        } else {
            sliderView.isdragging = false
        }
    }
}
