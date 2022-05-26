//
//  FPVideoPlayer.h
//  Funnyplanet
//
//  Created by Yann2021QMKLPro on 2021/9/24.
//

#import "FPAVPlayer.h"
NS_ASSUME_NONNULL_BEGIN

@interface FPVideoPlayer :  FPAVPlayer

@property(nonatomic, strong) void (^singleTappedPlayer)(void); /**< 单击播放器 */
@property(nonatomic, strong) void (^doubleTappedPlayer)(void); /**< 双击播放器 */


@property(nonatomic, assign,readonly) BOOL isPaused;
@property(nonatomic, assign,readonly) BOOL isStopped;

@property(nonatomic, assign,readonly) NSTimeInterval durationWatched; /**< 已观看的时长 单位毫秒 */


/** 重置视频观看时长,埋点用 */
- (void)resetWathchDuration;

// 埋点用参数:
@property(nonatomic, assign) int64_t beginEnterPostTime;

@end

NS_ASSUME_NONNULL_END
