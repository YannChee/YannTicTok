//
//  FPAVPlayerManager.m
//  YannIjkPlayer
//
//  Created by YannChee on 2021/12/5.
//

#import "FPAVPlayerManager.h"
#import "ZFKVOController.h"
#import "ZFReachabilityManager.h"

static NSString *const kStatus                   = @"status";
static NSString *const kLoadedTimeRanges         = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty      = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp   = @"playbackLikelyToKeepUp";
static NSString *const kPresentationSize         = @"presentationSize";


@interface FPAVPlayerPresentView  : UIView

@property (nonatomic, weak,readonly) AVPlayer *player;
@property(nonatomic, weak, readonly) AVPlayerLayer *playerLayer;

- (instancetype)initWithPlayer:(AVPlayer *)player;
@end

@implementation FPAVPlayerPresentView

- (instancetype)initWithPlayer:(AVPlayer *)player {
    if (self = [super init]) {
        _player = player;
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        self.playerLayer.videoGravity  = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:self.playerLayer];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

- (void)dealloc {
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
}

@end


@interface FPAVPlayerManager () {
    id _timeObserver;
    id _itemEndObserver;
    ZFKVOController *_playerItemKVO;
}
//@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isReadyToPlay;
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@property(nonatomic, strong) FPAVPlayerPresentView *playerPresentView;

@property(nonatomic, assign) BOOL isAutoPauseWhenStalled; /**< 由于stalled 自动暂停视频 */

@end


@implementation FPAVPlayerManager {
    AVURLAsset * _asset;
    AVPlayerItem *_playerItem;
    AVPlayer * _player;
//    AVPlayerLayer *_avPlayerLayer;
}


// FIXME: xxxx
//@synthesize brightness;

@synthesize view                           = _view;
@synthesize currentTime                    = _currentTime;
@synthesize totalTime                      = _totalTime;
@synthesize playerPlayTimeChanged          = _playerPlayTimeChanged;
@synthesize playerBufferTimeChanged        = _playerBufferTimeChanged;
@synthesize playerDidToEnd                 = _playerDidToEnd;
@synthesize bufferTime                     = _bufferTime;
@synthesize playState                      = _playState;
@synthesize loadState                      = _loadState;
@synthesize assetURL                       = _assetURL;
@synthesize playerPrepareToPlay            = _playerPrepareToPlay;
@synthesize playerReadyToPlay              = _playerReadyToPlay;
@synthesize playerPlayStateChanged         = _playerPlayStateChanged;
@synthesize playerLoadStateChanged         = _playerLoadStateChanged;
@synthesize seekTime                       = _seekTime;
@synthesize muted                          = _muted;
@synthesize volume                         = _volume;
@synthesize presentationSize               = _presentationSize;
@synthesize isPlaying                      = _isPlaying;
@synthesize rate                           = _rate;
@synthesize isPreparedToPlay               = _isPreparedToPlay;
@synthesize shouldAutoPlay                 = _shouldAutoPlay;
@synthesize scalingMode                    = _scalingMode;
@synthesize playerPlayFailed               = _playerPlayFailed;
@synthesize presentationSizeChanged        = _presentationSizeChanged;

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _scalingMode = FPPlayerScalingModeAspectFit;
        _shouldAutoPlay = YES;
    }
    return self;
}

/** 准备播放 */
- (void)prepareToPlay {
    if (!_assetURL) {
        return;
    }
    _isPreparedToPlay = YES;
    [self initializePlayer];
    if (self.shouldAutoPlay) {
        [self play];
    }
    self.loadState = FPPlayerLoadStatePrepare;
    if (self.playerPrepareToPlay) self.playerPrepareToPlay(self, self.assetURL);
}

- (void)reloadPlayer {
    self.seekTime = self.currentTime;
    [self prepareToPlay];
}

- (void)play {
    if (!_isPreparedToPlay) {
        [self prepareToPlay];
    } else {
        [self.player play];
        self.player.rate = self.rate;
        self->_isPlaying = YES;
        self.playState = FPPlayerPlayStatePlaying;
    }
}

- (void)pause {
    self.isAutoPauseWhenStalled = NO;
    [self.player pause];
    self->_isPlaying = NO;
    self.playState = FPPlayerPlayStatePaused;
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
}

- (void)stop {
    [_playerItemKVO safelyRemoveAllObservers];
    
    self.loadState = FPPlayerLoadStateUnknown;
    self.playState = FPPlayerPlayStatePlayStopped;
    if (self.player.rate != 0) {
        [self.player pause];
    }
    [_playerItem cancelPendingSeeks];
    [_asset cancelLoading];
    
    [self.playerPresentView removeFromSuperview];
    _playerPresentView.backgroundColor = UIColor.orangeColor;
    _playerPresentView = nil;
    _view = nil;
    [self.player removeTimeObserver:_timeObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.presentationSize = CGSizeZero;
    _timeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:_itemEndObserver name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    _itemEndObserver = nil;
    _isPlaying = NO;
    _player = nil;
    _assetURL = nil;
    _playerItem = nil;
    _isPreparedToPlay = NO;
    self->_currentTime = 0;
    self->_totalTime = 0;
    self->_bufferTime = 0;
    self.isReadyToPlay = NO;
}

- (void)replay {
    @fp_weakify(self)
    [self seekToTime:0 completionHandler:^(BOOL finished) {
        @fp_strongify(self)
        if (finished) {
            [self play];
        }
    }];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if (self.totalTime > 0) {
        [_player.currentItem cancelPendingSeeks];
        int32_t timeScale = _player.currentItem.asset.duration.timescale;
        CMTime seekTime = CMTimeMakeWithSeconds(time, timeScale);
        [_player seekToTime:seekTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
    } else {
        self.seekTime = time;
    }
}

- (UIImage *)thumbnailImageAtCurrentTime {
    CMTime expectedTime = self.playerItem.currentTime;
    CGImageRef cgImage = NULL;
    
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    cgImage = [self.imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];

    if (!cgImage) {
        self.imageGenerator.requestedTimeToleranceBefore = kCMTimePositiveInfinity;
        self.imageGenerator.requestedTimeToleranceAfter = kCMTimePositiveInfinity;
        cgImage = [self.imageGenerator copyCGImageAtTime:expectedTime actualTime:NULL error:NULL];
    }
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

- (void)thumbnailImageAtCurrentTime:(void(^)(UIImage *))handler {
    CMTime expectedTime = self.playerItem.currentTime;
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:expectedTime]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (handler) {
            UIImage *finalImage = [UIImage imageWithCGImage:image];
            handler(finalImage);
        }
    }];
}

#pragma mark - private method

/// Calculate buffer progress
- (NSTimeInterval)availableDuration {
    NSArray *timeRangeArray = _playerItem.loadedTimeRanges;
    CMTime currentTime = [_player currentTime];
    BOOL foundRange = NO;
    CMTimeRange aTimeRange = {0};
    if (timeRangeArray.count) {
        aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        if (CMTimeRangeContainsTime(aTimeRange, currentTime)) {
            foundRange = YES;
        }
    }
    
    if (foundRange) {
        CMTime maxTime = CMTimeRangeGetEnd(aTimeRange);
        NSTimeInterval playableDuration = CMTimeGetSeconds(maxTime);
        if (playableDuration > 0) {
            return playableDuration;
        }
    }
    return 0;
}

#pragma mark 实例化播放器
- (void)initializePlayer {
    _asset = [AVURLAsset URLAssetWithURL:self.assetURL options:self.requestHeader];
    _playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    self.playerItem.preferredForwardBufferDuration = 5;
    [self enableAudioTracks:YES inPlayerItem:self.playerItem];
    
    _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    _imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.asset];
    self.scalingMode = self->_scalingMode;
    
    self.playerPresentView = [[FPAVPlayerPresentView alloc] initWithPlayer:self.player];
    _view =  self.playerPresentView;
    /// 关闭AVPlayer默认的缓冲延迟播放策略，提高首屏播放速度
    dispatch_async(dispatch_get_main_queue(), ^{
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    });
    
    [self itemObserving];
}

/// Playback speed switching method
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem {
    for (AVPlayerItemTrack *track in playerItem.tracks){
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeVideo]) {
            track.enabled = enable;
        }
    }
}

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond {
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    if (self.isBuffering || self.playState == FPPlayerPlayStatePlayStopped) {
        return;
    }
    // 没有网络
    if ([ZFReachabilityManager sharedManager].networkReachabilityStatus == ZFReachabilityStatusNotReachable) return;
    self.isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self pause];
    self.isAutoPauseWhenStalled = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (!self.isPlaying && self.loadState == FPPlayerLoadStateStalled) {
            self.isBuffering = NO;
            NSLog(@"Yann======FPPlayerLoadStateStalled");
            if (!self.isAutoPauseWhenStalled) { // 如果不是播放器自动暂停,说明是用户手动暂停,则return
                return;
            }
        }
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        self.isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond];
        }
    });
}

- (void)itemObserving {
    [_playerItemKVO safelyRemoveAllObservers];
    _playerItemKVO = [[ZFKVOController alloc] initWithTarget:_playerItem];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kStatus
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackBufferEmpty
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPlaybackLikelyToKeepUp
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kLoadedTimeRanges
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    [_playerItemKVO safelyAddObserver:self
                           forKeyPath:kPresentationSize
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    
    CMTime interval = CMTimeMakeWithSeconds(self.timeRefreshInterval > 0 ? self.timeRefreshInterval : 0.1, NSEC_PER_SEC);
    @fp_weakify(self)
    _timeObserver = [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @fp_strongify(self)
        if (!self) return;
        NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
        if (self.isPlaying && self.loadState == FPPlayerLoadStateStalled) {
            self.player.rate = self.rate;
        }
        if (loadedRanges.count > 0) {
            if (self.playerPlayTimeChanged) {
                self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
            }
        }
    }];
    
    _itemEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @fp_strongify(self)
        if (!self) return;
        self.playState = FPPlayerPlayStatePlayStopped;
        if (self.playerDidToEnd) self.playerDidToEnd(self);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([keyPath isEqualToString:kStatus]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                if (!self.isReadyToPlay) {
                    self.isReadyToPlay = YES;
                    self.loadState = FPPlayerLoadStatePlaythroughOK;
                    if (self.playerReadyToPlay) self.playerReadyToPlay(self, self.assetURL);
                }
                if (self.seekTime) {
                    if (self.shouldAutoPlay) [self pause];
                    @fp_weakify(self)
                    [self seekToTime:self.seekTime completionHandler:^(BOOL finished) {
                        @fp_strongify(self)
                        if (finished) {
                            if (self.shouldAutoPlay) [self play];
                        }
                    }];
                    self.seekTime = 0;
                } else {
                    if (self.shouldAutoPlay && self.isPlaying) [self play];
                }
                self.player.muted = self.muted;
                NSArray *loadedRanges = self.playerItem.seekableTimeRanges;
                if (loadedRanges.count > 0) {
                    if (self.playerPlayTimeChanged) self.playerPlayTimeChanged(self, self.currentTime, self.totalTime);
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                self.playState = FPPlayerPlayStatePlayFailed;
                self->_isPlaying = NO;
                NSError *error = self.player.currentItem.error;
                if (self.playerPlayFailed) self.playerPlayFailed(self, error);
            }
        } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) {
            // When the buffer is empty
            if (self.playerItem.playbackBufferEmpty) {
                self.loadState = FPPlayerLoadStateStalled;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) {
            // When the buffer is good
            if (self.playerItem.playbackLikelyToKeepUp) {
                self.loadState = FPPlayerLoadStatePlayable;
                if (self.isPlaying) [self.player play];
            }
        } else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
            NSTimeInterval bufferTime = [self availableDuration];
            self->_bufferTime = bufferTime;
            if (self.playerBufferTimeChanged) self.playerBufferTimeChanged(self, bufferTime);
        } else if ([keyPath isEqualToString:kPresentationSize]) {
            self.presentationSize = self.playerItem.presentationSize;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

#pragma mark - getter

- (float)rate {
    return _rate == 0 ? 1:_rate;
}

- (NSTimeInterval)totalTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.player.currentItem.duration);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    NSTimeInterval sec = CMTimeGetSeconds(self.playerItem.currentTime);
    if (isnan(sec) || sec < 0) {
        return 0;
    }
    return sec;
}

#pragma mark - setter

- (void)setPlayState:(FPPlayerPlaybackState)playState {
    _playState = playState;
    if (self.playerPlayStateChanged) self.playerPlayStateChanged(self, playState);
}

- (void)setLoadState:(FPPlayerLoadState)loadState {
    _loadState = loadState;
    if (self.playerLoadStateChanged) self.playerLoadStateChanged(self, loadState);
}

- (void)setAssetURL:(NSURL *)assetURL {
    if (self.player) {
        [self stop];
    }
    _assetURL = assetURL;
    [self prepareToPlay];
}

- (void)setRate:(float)rate {
    _rate = rate;
    if (self.player && fabsf(_player.rate) > 0.00001f) {
        self.player.rate = rate;
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    self.player.muted = muted;
}

//- (void)setScalingMode:(FPPlayerScalingMode)scalingMode {
//    _scalingMode = scalingMode;
//    FPPlayerPresentView *presentView = (FPPlayerPresentView *)self.view.playerView;
//    self.view.scalingMode = scalingMode;
//    switch (scalingMode) {
//        case FPPlayerScalingModeNone:
//            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
//            break;
//        case FPPlayerScalingModeAspectFit:
//            presentView.videoGravity = AVLayerVideoGravityResizeAspect;
//            break;
//        case FPPlayerScalingModeAspectFill:
//            presentView.videoGravity = AVLayerVideoGravityResizeAspectFill;
//            break;
//        case FPPlayerScalingModeFill:
//            presentView.videoGravity = AVLayerVideoGravityResize;
//            break;
//        default:
//            break;
//    }
//}

- (void)setVolume:(float)volume {
    _volume = MIN(MAX(0, volume), 1);
    self.player.volume = volume;
}

//- (void)setPresentationSize:(CGSize)presentationSize {
//    _presentationSize = presentationSize;
//    self.view.presentationSize = presentationSize;
//    if (self.presentationSizeChanged) {
//        self.presentationSizeChanged(self, self.presentationSize);
//    }
//
//}




@end

