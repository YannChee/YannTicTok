//
//  FPPlayer.m
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//


#import "FPPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FPPlayerViewDefinitions.h"


static NSMutableDictionary <NSString* ,NSNumber *> *_zfPlayRecords;

@interface FPPlayer ()

@property (nonatomic, strong) UISlider *volumeViewSlider;

@property(nonatomic, assign) float lastVolumeValue; /**< 上一次音量 */

@end


@implementation FPPlayer {
     UIView * _playerView; /**< 承载播放器的容器view */
    id<FPPlayerMediaPlayback> _currentPlayerManager;
    CGFloat _volume; /**< 播放器音量, 不会影响系统音量*/
    UIImageView *_placeholderImageView; /**< 视频封面图 */
}


- (instancetype)init {
    if ( self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _zfPlayRecords = @{}.mutableCopy;
        });
        
        [self configureVolume];
    }
    return self;
}

/// Get system volume
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

- (void)dealloc {
    NSLog(@"Yann************ FPPlayer 播放器释放");
    [self distroy];
}

- (instancetype)initWithPlayerManager:(id<FPPlayerMediaPlayback>)playerManager {
    
    if (!playerManager) {
        return nil;
    };
    FPPlayer *player = [self init];
    _currentPlayerManager = playerManager;
    
    [self setupFPPlayerBlocks];
    return player; // playerManager.vew 不一定有值,所以此时创建的播放器view 有可能只是个空壳子,
}


#pragma mark - 播放器maneger blocks
#pragma mark - xxxxxx

- (void)setupFPPlayerBlocks {
    @fp_weakify(self);
    /** 播放器 进入准备阶段调用 ,这个时候manager 的播放器才会真正创建 */
    self.currentPlayerManager.playerPrepareToPlay = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @fp_strongify(self);
        
        
        //        if (self.resumePlayRecord && [_zfPlayRecords valueForKey:assetURL.absoluteString]) {
        //            NSTimeInterval seekTime = [_zfPlayRecords valueForKey:assetURL.absoluteString].doubleValue;
        //            self.currentPlayerManager.seekTime = seekTime;
        //        }
        
        // 布局播放器UI
        [self addPlayerSubViews];
        [self layoutPlayerSubViews];
        
        !self.playerPrepareToPlay ?: self.playerPrepareToPlay(asset,assetURL);
    };
    
    /** 播放器 进入随时可播放阶段调用 */
    self.currentPlayerManager.playerReadyToPlay = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @fp_strongify(self);
        !self.playerReadyToPlay ?: self.playerReadyToPlay(asset,assetURL);
        //        if (!self.customAudioSession) {
        //            // Apps using this category don't mute when the phone's mute button is turned on, but play sound when the phone is silent
        //            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        //            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        //        }
    };
    /** 播放器 播放进度改变时候调用 */
    self.currentPlayerManager.playerPlayTimeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @fp_strongify(self);
        !self.playerPlayTimeChanged ?: self.playerPlayTimeChanged(asset,currentTime,duration);
    };
    /** 播放器 缓冲进度改变时候调用 */
    self.currentPlayerManager.playerBufferTimeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval bufferTime) {
        @fp_strongify(self);
        !self.playerBufferTimeChanged ?: self.playerBufferTimeChanged(asset,bufferTime);
    };
    /** 播放器 播放状态改变时候调用 */
    self.currentPlayerManager.playerPlayStateChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, FPPlayerPlaybackState playState) {
        @fp_strongify(self);
        !self.playerPlayStateChanged ?: self.playerPlayStateChanged(asset,playState);
    };
    /** 播放器 载入状态改变时候调用 */
    self.currentPlayerManager.playerLoadStateChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, FPPlayerLoadState loadState) {
        @fp_strongify(self);
        !self.playerLoadStateChanged ?: self.playerLoadStateChanged(asset,loadState);
    };
    /** 播放器  播放失败时候调用 */
    self.currentPlayerManager.playerPlayFailed = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @fp_strongify(self);
        !self.playerPlayFailed ?: self.playerPlayFailed(asset,error);
    };
    /** 播放器  播放结束时候调用 */
    self.currentPlayerManager.playerDidToEnd = ^(id<FPPlayerMediaPlayback>  _Nonnull asset) {
        @fp_strongify(self);
        !self.playerDidToEnd ?: self.playerDidToEnd(asset);
    };
    /** 播放器  视频size改变 时候调用 */
    self.currentPlayerManager.presentationSizeChanged = ^(id<FPPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @fp_strongify(self);
        self.presentationSize = size;
        self.currentPlayerManager.presentationSize = size;
        
        !self.presentationSizeChanged ?: self.presentationSizeChanged(asset,size);
    };
    
}

/**< 根据播放器frame 和视频size 动态计算播放器view的最佳frame */
- (CGRect)calculatePlayerViewFrameWithPlayerFrame:(CGRect)playerFrame videoSize:(CGSize)videoSize {
    
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = playerFrame.size.width;
    CGFloat min_view_h = playerFrame.size.height;
    
    CGSize playerViewSize = CGSizeZero;
    CGFloat videoWidth = videoSize.width;
    CGFloat videoHeight = videoSize.height;
    
    if (videoHeight == 0 || min_view_h == 0) {
        return self.frame;
    }
    
    CGFloat screenScale = min_view_w / min_view_h;
    CGFloat videoScale = videoWidth/videoHeight;
    if (screenScale > videoScale) {
        CGFloat height = min_view_h;
        CGFloat width = height * videoScale;
        playerViewSize = CGSizeMake(width, height);
    } else {
        CGFloat width = min_view_w;
        CGFloat height = width / videoScale;
        playerViewSize = CGSizeMake(width, height);
    }
    
    if (self.scalingMode == FPPlayerScalingModeAspectFit || self.scalingMode == FPPlayerScalingModeAspectFit) {
        min_w = playerViewSize.width;
        min_h = playerViewSize.height;
        min_x = (min_view_w - min_w) * 0.5;
        min_y = (min_view_h - min_h) * 0.5;
        return CGRectMake(min_x, min_y, min_w, min_h);;
    } else if (self.scalingMode == FPPlayerScalingModeAspectFill || self.scalingMode == FPPlayerScalingModeFill) {
        return self.frame;
    }
    return self.frame;
}


#pragma mark - 视图相关逻辑

- (void)addPlayerSubViews {
    BOOL isCanLayout =  self.currentPlayerManager.view && self.currentPlayerManager.isPreparedToPlay;
    if (!isCanLayout) {
        return;
    }
    
    [self.playerView addSubview:self.currentPlayerManager.view];
    self.currentPlayerManager.view.userInteractionEnabled = NO;
    self.currentPlayerManager.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)layoutPlayerSubViews {
    
    self.playerView.frame = self.frame;
    self.currentPlayerManager.view.frame = self.playerView.bounds;
    self.placeholderImageView.frame = self.playerView.bounds;
    [self.playerView bringSubviewToFront:self.placeholderImageView];
}


#pragma mark - 方法
- (void)prepareToPlay {
    [self.currentPlayerManager prepareToPlay];
}

- (void)reloadPlayer {
    [self.currentPlayerManager reloadPlayer];
}

- (void)play {
    [self.currentPlayerManager play];
}

- (void)pause {
    [self.currentPlayerManager pause];
}

- (void)replay {
    [self.currentPlayerManager replay];
}

- (void)stop {
    [self.currentPlayerManager stop];
}

- (void)distroy {
    [self stop];
}

- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^)(BOOL))completionHandler {
    [self.currentPlayerManager seekToTime:time completionHandler:completionHandler];
}

#pragma mark - readwrite 属性

- (void)setAssetURL:(NSURL *)assetURL {
    _assetURL = assetURL;
    self.currentPlayerManager.assetURL = assetURL;
}

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    
    [self layoutPlayerSubViews];
}


- (void)setVolume:(float)volume {
    _volume = volume;
    self.volumeViewSlider.value = volume;
}

- (float)volume {
    CGFloat volume = self.volumeViewSlider.value;
    if (volume == 0) {
        volume = [[AVAudioSession sharedInstance] outputVolume];
    }
    return volume;
}


- (void)setMuted:(BOOL)muted {
    if (muted) {
        if (self.volumeViewSlider.value > 0) {
            self.lastVolumeValue = self.volumeViewSlider.value;
        }
        self.volumeViewSlider.value = 0;
        return;
    }
    self.volumeViewSlider.value = self.lastVolumeValue;
}

- (BOOL)isMuted {
    return self.volume == 0;
}

- (void)setScalingMode:(FPPlayerScalingMode)scalingMode {
    _scalingMode = scalingMode;
    self.currentPlayerManager.scalingMode = scalingMode;
    
    if (scalingMode == FPPlayerScalingModeNone || scalingMode == FPPlayerScalingModeAspectFit) {
        self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    } else if (scalingMode == FPPlayerScalingModeAspectFill) {
        self.placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
    } else if (scalingMode == FPPlayerScalingModeFill) {
        self.placeholderImageView.contentMode = UIViewContentModeScaleToFill;
    }
}



#pragma mark - 只读属性getter
- (UIView *)view {
    return self.currentPlayerManager.view;
}

- (NSTimeInterval)currentTime {
    return self.currentPlayerManager.currentTime;
}

- (NSTimeInterval)totalTime {
    return self.currentPlayerManager.totalTime;
}

- (NSTimeInterval)bufferTime {
    return self.currentPlayerManager.bufferTime;
}

- (BOOL)isPlaying {
    return self.currentPlayerManager.isPlaying;
}

- (BOOL)isPreparedToPlay {
    return self.currentPlayerManager.isPreparedToPlay;
}

- (FPPlayerPlaybackState)playState {
    return self.currentPlayerManager.playState;
}

- (FPPlayerLoadState)loadState {
    return self.currentPlayerManager.loadState;
}


- (UIView *)playerView {
    if (!_playerView) {
        UIView *view = [[UIView alloc] initWithFrame:self.frame];
        [view addSubview:self.placeholderImageView];
        _playerView = view;
    }
    return _playerView;
}

#pragma mark - 懒加载
- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        UIImageView *coverImageView = [[UIImageView alloc] init];
        coverImageView.userInteractionEnabled = YES;
        coverImageView.clipsToBounds = YES;
        coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        coverImageView.backgroundColor = UIColor.clearColor;
        _placeholderImageView = coverImageView;
    }
    return _placeholderImageView;
}
@end
