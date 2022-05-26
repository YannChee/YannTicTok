//
//  FPPlayer.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FPPlayerMediaPlayback.h"


NS_ASSUME_NONNULL_BEGIN

@interface FPPlayer : NSObject

/** 使用自定义播放器manager 播放 */
- (instancetype)initWithPlayerManager:(id<FPPlayerMediaPlayback>)playerManager;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


#pragma mark - FPPlayerMediaPlayback 协议属性
#pragma mark 只读属性
@property(nonatomic, strong,readonly) UIView *playerView; /**< 承载播放器的容器view */
@property (nonatomic, strong,readonly) id<FPPlayerMediaPlayback> currentPlayerManager; /**< 播放manegr */
@property (nonatomic,assign,readonly) NSTimeInterval currentTime; /**< 播放器当前时间 */
@property (nonatomic,assign,readonly) NSTimeInterval totalTime; /**< 播放器总时间 */
@property (nonatomic,assign, readonly) NSTimeInterval bufferTime; /**< 缓冲区时间 */
@property (nonatomic,assign,readonly) BOOL isPlaying;
/**
 @abstract Check whether video preparation is complete.
 @discussion isPreparedToPlay processing logic
 
 * If isPreparedToPlay is true, you can call [ZFPlayerMediaPlayback play] API start playing;
 * If isPreparedToPlay to false, direct call [ZFPlayerMediaPlayback play], in the play the internal automatic call [ZFPlayerMediaPlayback prepareToPlay] API.
 * Returns true if prepared for playback.
 */
@property (nonatomic,assign,readonly) BOOL isPreparedToPlay;
@property (nonatomic,assign,readonly) FPPlayerPlaybackState playState; /**< 播放状态 */
@property (nonatomic,assign,readonly) FPPlayerLoadState loadState; /**< 视频载入状态 */

#pragma mark readwrite 属性
@property (nonatomic,strong) NSURL * _Nonnull assetURL; /**< 视频资源url */
@property(nonatomic, assign) CGRect frame; /**< 播放器view的frame */
@property (nonatomic,assign) float volume; /**< 播放器音量, 不会影响系统音量*/
@property (nonatomic,getter=isMuted) BOOL muted; /**< 播放器静音,不会影响系统音量 */
@property (nonatomic,assign) float rate; /**< 播放器速率,不能为0 */
@property (nonatomic,assign) NSTimeInterval seekTime; /**< 跳播时间 */
@property (nonatomic,assign) FPPlayerScalingMode scalingMode; /**< 视频填充样式 */
@property (nonatomic,assign) BOOL shouldAutoPlay; /**< 是否自动播放,默认是YES */
@property (nonatomic,assign) CGSize presentationSize; /**< 视频size */

#pragma mark - 播放器回调

/** 播放器 进入准备阶段调用 */
@property (nonatomic, copy, nullable) void(^playerPrepareToPlay)(id<FPPlayerMediaPlayback> _Nonnull asset, NSURL * _Nonnull assetURL);

/** 播放器 进入随时可播放阶段调用 */
@property (nonatomic, copy, nullable) void(^playerReadyToPlay)(id<FPPlayerMediaPlayback> _Nonnull asset, NSURL  * _Nonnull assetURL);

/** 播放器 播放进度改变时候调用 */
@property (nonatomic, copy, nullable) void(^playerPlayTimeChanged)(id<FPPlayerMediaPlayback> _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration);

/** 播放器 缓冲进度改变时候调用 */
@property (nonatomic, copy, nullable) void(^playerBufferTimeChanged)(id<FPPlayerMediaPlayback> _Nonnull asset, NSTimeInterval bufferTime);

/** 播放器 播放状态改变时候调用 */
@property (nonatomic, copy, nullable) void(^playerPlayStateChanged)(id<FPPlayerMediaPlayback> _Nonnull asset, FPPlayerPlaybackState playState);
/** 播放器 载入状态改变时候调用 */
@property (nonatomic, copy, nullable) void(^playerLoadStateChanged)(id<FPPlayerMediaPlayback> _Nonnull asset, FPPlayerLoadState loadState);
/** 播放器  播放失败时候调用 */
@property (nonatomic, copy, nullable) void(^playerPlayFailed)(id<FPPlayerMediaPlayback> _Nonnull asset, id _Nonnull error);
/** 播放器  播放结束时候调用 */
@property (nonatomic, copy, nullable) void(^playerDidToEnd)(id<FPPlayerMediaPlayback> _Nonnull asset);
/** 播放器  视频size改变 时候调用 */
@property (nonatomic, copy, nullable) void(^presentationSizeChanged)(id<FPPlayerMediaPlayback> _Nonnull asset, CGSize size);


#pragma mark - FPPlayerMediaPlayback 协议方法
- (void)prepareToPlay;

- (void)reloadPlayer;

- (void)play;

- (void)pause;

- (void)replay;

- (void)stop;

/** 跳播 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

///** 当前时间 视频图片 */
//- (UIImage *_Nonnull)thumbnailImageAtCurrentTime;
///** 当前时间 视频图片 */
//- (void)thumbnailImageAtCurrentTime:(void(^_Nullable)(UIImage *_Nonnull videoImage))handler;

#pragma mark -  播放协议外的扩充属性
@property (nonatomic, strong, readonly) UIImageView *placeholderImageView; /**< 视频封面图 */

/**< 根据播放器frame 和视频size 动态计算播放器view的最佳frame */
- (CGRect)calculatePlayerViewFrameWithPlayerFrame:(CGRect)playerFrame videoSize:(CGSize)videoSize;

@end

NS_ASSUME_NONNULL_END
