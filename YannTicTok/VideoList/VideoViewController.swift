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
        playOrPauseBtn.bottom = view.height - 100
        progressLabelView.bottom = view.height - 51
        self.sliderView.bottom = view.bottom
        
        view.bringSubviewToFront(sliderView)
        view.bringSubviewToFront(playOrPauseBtn)
    }
    
    
    
    
    
    private func setupUI() {
        view.backgroundColor = .black
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


//- (void)setupBlocks {
//    @weakify(self);
//    [self.playOrPauseBtn setBlockForControlEvents:UIControlEventTouchUpInside block:^(UIButton  *sender) {
//        @strongify(self);
//
//        if (self.player.isPlaying) {
//            [self pauseVideoPlay];
//            [self.playOrPauseBtn setImage:[UIImage imageNamed:@"Post_Play"] forState:UIControlStateNormal];
//        } else {
//            // 由于self.player.isPlaying / isPaused有可能返回nil
//            if (self.player.isPaused) {
//                [self playVideo];
//                [self.playOrPauseBtn setImage:[UIImage imageNamed:@"Post_Pause"] forState:UIControlStateNormal];
//            }
//        }
//
//    }];
//
//    #pragma mark 点击手势
//    self.player. = ^{
//        @strongify(self);
//
//        self.isHideRightAndBottomView = !self.isHideRightAndBottomView;
//        self.playOrPauseBtn.hidden = !self.isHideRightAndBottomView;
//
////        if (self.isHideRightAndBottomView) {
////            [self changeSliderToBold];
////        } else {
////            [self changeSliderToOrigin];
////        }
//    };
//
//    self.player.playerDidToEnd = ^(id<FPPlayerMediaPlayback>  _Nonnull asset) {
//        @strongify(self);
//        if (self.player.totalTime < 20 && !self.isChangedShareBtnToWeChat) {
//            self.isChangedShareBtnToWeChat = YES;
//            [self.rightFunctionsView changeShareBtnToWeChatAndPlayAnimationWithCompletion:^(FPPostModel *postModel) {
//                postModel.content.isChangeShareBtnToWeChat = YES;
//            }];
//        }
//        [self.player replay];
//    };
//
//    self.player.playerPlayFailed = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
//        @strongify(self);
//        if (!self.isRetriedWhenFail) {
//            !self.playerAssetStatusFailed ?: self.playerAssetStatusFailed(error);
//            self.isRetriedWhenFail = YES;
//        }
//    };
//
//    // 播放状态随时可播放
//    self.player.playerReadyToPlay = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        @strongify(self);
//        self.loadingView.hidden = YES;
//        self.player.placeholderImageView.hidden = YES;
//        [self.player rotatePlayerViewIfNeed];
//        //
//        self.player.beginEnterPostTime = [[NSDate date] timeIntervalSince1970] * 1000;
//    };
//
//    // 视频尺寸变换
//    self.player.presentationSizeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
//        @strongify(self);
//        [self.player rotatePlayerViewIfNeed];
//    };
//
//    self.player.playerPrepareToPlay = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        @strongify(self);
//
////                if (currentTime > 0) {
////
////                }
//        self.loadingView.hidden =  self.videoPlaceholderImage ? YES : NO;
//        self.isChangedShareBtnToWeChat = NO;
//        // 更新第一次开始播放时间
//        self.videoBeginPlayTime = [DigitalTimeStampService gs_getCurrentTimeToMilliSecond];
//
//        !self.playerBecomePrepareToPlayBlock ?: self.playerBecomePrepareToPlayBlock();
//    };
//
////
////    self.player.playerBufferTimeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
////        @strongify(self);
////        // FIXME: xxxx
////        self.sliderView.hidden = NO;
////        if (bufferTime > 0 &&
////            !self.sliderView.hidden &&
////            self.player.totalTime > 0) {
////            self.sliderView.bufferValue = bufferTime / self.player.totalTime;
////        }
////    };
//
//    self.player.playerLoadStateChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, FPPlayerLoadState loadState) {
//        @strongify(self);
////        if (loadState == FPPlayerLoadStateUnknown || loadState == FPPlayerLoadStatePrepare) {
////            [self showSliderLoadingIfNeed];
////        }
//
//        if (loadState == FPPlayerLoadStatePrepare) {
//            self.player.placeholderImageView.hidden = NO;
//        } else if (loadState == FPPlayerLoadStatePlaythroughOK || loadState == FPPlayerLoadStatePlayable) {
//            self.player.placeholderImageView.hidden = YES;
//        }
//
//        if (loadState == FPPlayerLoadStateStalled && self.player.currentPlayerManager.isPlaying ) {
//            [self.sliderView startAnimating];
//        } else if ((loadState == FPPlayerLoadStateStalled || loadState == FPPlayerLoadStatePrepare) && self.player.currentPlayerManager.isPlaying) {
//            [self.sliderView startAnimating];
//        } else {
//            [self.sliderView stopAnimating];
//        }
//
//    };
//
//    self.player.playerPlayStateChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, FPPlayerPlaybackState playState) {
//        @strongify(self);
//        if (playState == FPPlayerPlayStatePlaying) {
//            /// 开始播放时候判断是否显示loading
//            if (self.player.currentPlayerManager.loadState == FPPlayerLoadStateStalled ) {
//                [self.sliderView startAnimating];
//            } else if ((self.player.currentPlayerManager.loadState == FPPlayerLoadStateStalled || self.player.currentPlayerManager.loadState == FPPlayerLoadStatePrepare)) {
//                [self.sliderView startAnimating];
//            }
//        } else if (playState == FPPlayerPlayStatePaused) {
//            /// 暂停的时候隐藏loading
//            [self.sliderView stopAnimating];
//        } else if (playState == FPPlayerPlayStatePlayFailed) {
//            [self.sliderView stopAnimating];
//        }
//    };
//
//    self.player.playerPlayTimeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
//        @strongify(self);
//        self.loadingView.hidden = YES;
//        self.videoDurattion = duration;
//
//        self.sliderView.hidden =  self.player.totalTime < 30 ? YES : NO;
//
//        if (!self.sliderView.isdragging && !self.sliderView.hidden) {
//            if (duration <= 0) {
//                self.sliderView.value = 0;
//            } else {
//                self.sliderView.value = currentTime / duration;
//            }
//        }
//
//        if (currentTime > 0 &&  self.isVCInAccurateIndexPath) {
//            // 埋点视频播放时间
//            self.videoBeginPlayTime = [DigitalTimeStampService gs_getCurrentTimeToMilliSecond];
//        }
//
//        if (!self.isChangedShareBtnToWeChat && self.player.totalTime >= 20 && currentTime >= 20 ) {
//            self.isChangedShareBtnToWeChat = YES;
//            [self.rightFunctionsView changeShareBtnToWeChatAndPlayAnimationWithCompletion:^(FPPostModel *postModel) {
//                postModel.content.isChangeShareBtnToWeChat = YES;
//            }];
//
//        }
//
//    };
//}


// MARK: - 播放器 block
extension VideoViewController {
    private func setupBlocks() {
        // 播放状态随时可播放
        player.playerReadyToPlay = {[weak self]  (_ , _) -> Void in
            self?.player.placeholderImageView.isHidden = true
        }
        
        
        player.singleTappedPlayer = { [weak self] () -> Void in
            
            guard self?.player.isPlaying == true else {
                // 非正在播放
                if (self?.player.isPaused == true) {
                    self?.playVideo()
                    self?.playOrPauseBtn.setImage(UIImage(named: "Post_Pause"), for: .normal)
                }
                return
            }
            self?.pauseVideo()
            self?.playOrPauseBtn.setImage(UIImage(named: "Post_Play"), for: .normal)
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
    
    
    private lazy var player: FPVideoPlayer = {
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


// MARK: - 进度条滑块
extension VideoViewController: FPVideoPlayerSliderViewDelegate {
    
}
