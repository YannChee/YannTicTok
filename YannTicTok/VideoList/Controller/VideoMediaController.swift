//
//  VideoMediaController.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/8.
//

import UIKit
import Kingfisher



// MARK: - properties
class VideoMediaController: UIViewController {
    typealias playerPlayTimeChangedBlock = (_ currentTime:TimeInterval,_ duration:TimeInterval) -> Void
    var playerPlayTimeChanged: playerPlayTimeChangedBlock?
    
    
    var postModel: PostInfo? {
        
        didSet {
            
            guard let urlStr =  postModel?.content?.thumb else {
                return
            }
            guard let videoUrlCover: URL = URL.init(string: urlStr) as URL? else {
                return
            }
            player.placeholderImageView.kf.setImage(with: videoUrlCover ,placeholder: UIImage.init(named: "img_video_loading"))
        }
    
    }
    
    private lazy var player: FPVideoPlayer = {
        let videoPlayer = FPVideoPlayer()
        return videoPlayer
    }()
    
    
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

// MARK: - life cycle
extension VideoMediaController {
    
    func isPlayerPlaying() -> Bool {
        return player.isPlaying
    }
    
    func isPlayerPaused() -> Bool {
        return player.isPaused
    }
    
    func videoTotalTime() -> TimeInterval {
        return player.totalTime
    }
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        view.addSubview(player.playerView)
        
        setupBlocks()
        

////
////        player.seek(toTime:time player.totalTime)) {[weak self] isFinished in
//////            if isFinished {
//////                self?.sliderView.isdragging = false
//////            }
//////
////            guard let playerSeekToTime = playerSeekToTime else { return }
////            playerSeekToTime()
////        }
    }
    
    func playerSeek(toTime:TimeInterval,completionHandler:((Bool) -> Void)?) -> Void {
        return  player.seek(toTime:toTime , completionHandler: completionHandler)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        player.frame = view.bounds
    }
    

    //        player.frame = CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 0.001)
//        playOrPauseBtn.center = CGPoint.init(x: view.qy_width * 0.5, y: view.qy_height * 0.5)
//        progressLabelView.bottom = view.height - 51
//        self.sliderView.bottom = view.bottom
//
//        view.bringSubviewToFront(sliderView)
//        view.bringSubviewToFront(playOrPauseBtn)
    
//    private func setupUI() {
      
     
        
//        view.addSubview(progressLabelView)
       
//
//
//        view.addSubview(playOrPauseBtn)
//        view.addSubview(sliderView)
//    }
    
 
    
    
    /// 下载视频封面图
    func downloadVideoCoverImgThenShow () {
        player.placeholderImageView.isHidden = false
        let imgUrl:URL? = URL.init(string: postModel?.content?.thumb ?? "")
        
        player.placeholderImageView.kf.setImage(
            with: imgUrl,
            placeholder: nil,
            options: [.downloader(ImageDownloader.default),.downloadPriority(1)],
            completionHandler: {[weak self] result in
//                self?.videoCoverImg = self?.player.placeholderImageView.image;
            })

    }
    
}


// MARK: - 播放器控制
extension VideoMediaController {
    
    public func playVideo() {
        if (player.isMuted) {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [AVAudioSession.CategoryOptions.defaultToSpeaker,AVAudioSession.CategoryOptions.allowBluetooth])
        }
        player.play()
    }
    
    
    public func pauseVideo() {
        player.pause()
    }
    
    public func stopVideo() {
        player.stop()
        player.placeholderImageView.isHidden = false;
    }
    
    
 
}


// MARK: - 播放器 block
extension VideoMediaController {
    private func setupBlocks() {
        // 播放状态随时可播放
        player.playerReadyToPlay = {[weak self]  (_ , _) -> Void in
            self?.player.placeholderImageView.isHidden = true
        }
        
        player.playerDidToEnd = {[weak self]  (_) -> Void in
            self?.player.replay()
        }
        
        
        
        player.playerLoadStateChanged = {[weak self]  (_ , loadState) -> Void in
            // FIXME: xxxxx
//            if loadState == .stalled &&  self?.player.currentPlayerManager.isPlaying == true {
//                self?.sliderView.startAnimating()
//            } else if loadState == .stalled || loadState == .prepare && self?.player.currentPlayerManager.isPlaying == true {
//                self?.sliderView.startAnimating()
//            } else {
//                self?.sliderView.stopAnimating()
//            }
        }
        
        player.playerPrepareToPlay = {[weak self] (_,_) -> Void in
            
        }
        
        player.playerPlayStateChanged = {[weak self] (_,playState) -> Void in
            if playState == .playStatePlaying {
                guard self?.player.currentPlayerManager.loadState == .stalled else {
                    if self?.player.currentPlayerManager.loadState == .stalled || self?.player.currentPlayerManager.loadState == .prepare {
//                        self?.sliderView.startAnimating()
                    }
                    return
                }
//                self?.sliderView.startAnimating()
                
                return
            }
            
            if playState == .playStatePaused || playState == .playStatePlayFailed {
//                self?.sliderView.stopAnimating()
            }
            
        }
        
        player.playerPlayTimeChanged = {[weak self] (_,currentTime,duration) -> Void in
            
            guard  self?.playerPlayTimeChanged != nil else { return  }
            self?.playerPlayTimeChanged!(currentTime,duration)
        }
        
        
                
    }
}

