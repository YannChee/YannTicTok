//
//  FPPlayerMediaPlayback.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//

// 播放协议

#ifndef FPPlayerMediaPlayback_h
#define FPPlayerMediaPlayback_h

#import "FPPlayerViewDefinitions.h"
#import <UIKit/UIKit.h>


@protocol FPPlayerMediaPlayback <NSObject>

@required

@property(nonatomic,readonly) UIView * _Nonnull view; /**< 播放器的view */


@property (nonatomic) float volume; /**< 播放器音量, 不会影响系统音量*/
@property (nonatomic, getter=isMuted) BOOL muted; /**< 播放器静音,不会影响系统音量 */
@property (nonatomic) float rate; /**< 播放器速率,不能为0 */
@property (nonatomic, readonly) NSTimeInterval currentTime; /**< 播放器当前时间 */
@property (nonatomic, readonly) NSTimeInterval totalTime; /**< 播放器总时间 */
@property (nonatomic, readonly) NSTimeInterval bufferTime; /**< 缓冲区时间 */

@property (nonatomic) NSTimeInterval seekTime; /**< 跳播时间 */
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic) FPPlayerScalingMode scalingMode;

/**
 @abstract Check whether video preparation is complete.
 @discussion isPreparedToPlay processing logic
 
 * If isPreparedToPlay is true, you can call [ZFPlayerMediaPlayback play] API start playing;
 * If isPreparedToPlay to false, direct call [ZFPlayerMediaPlayback play], in the play the internal automatic call [ZFPlayerMediaPlayback prepareToPlay] API.
 * Returns true if prepared for playback.
 */
@property (nonatomic, readonly) BOOL isPreparedToPlay;
@property (nonatomic) BOOL shouldAutoPlay; /**< 是否自动播放,默认是YES */
@property (nonatomic) NSURL * _Nonnull assetURL; /**< 视频资源url */
@property (nonatomic) CGSize presentationSize; /**< 视频size */

@property (nonatomic, readonly) FPPlayerPlaybackState playState; /**< 播放状态 */
@property (nonatomic, readonly) FPPlayerLoadState loadState; /**< 视频载入状态 */

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


/// Prepares the current queue for playback, interrupting any active (non-mixible) audio sessions.
- (void)prepareToPlay;

- (void)reloadPlayer;

- (void)play;

- (void)pause;

- (void)replay;

- (void)stop;

/** 跳播 */
- (void)seekToTime:(NSTimeInterval)time completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;

@optional

/** 当前时间 视频图片 */
- (UIImage *_Nonnull)thumbnailImageAtCurrentTime;
/** 当前时间 视频图片 */
- (void)thumbnailImageAtCurrentTime:(void(^_Nullable)(UIImage *_Nonnull videoImage))handler;

@end



#endif /* FPPlayerMediaPlayback_h */
