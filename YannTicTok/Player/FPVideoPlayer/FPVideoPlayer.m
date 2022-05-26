//
//  FPVideoPlayer.m
//  Funnyplanet
//
//  Created by Yann2021QMKLPro on 2021/9/24.
//

#import "FPVideoPlayer.h"
//#import "NSArray+DTBase.h"
#import "YYKit.h"


@interface FPVideoPlayer ()

@property(nonatomic, assign) NSTimeInterval startTimeStamp;


@end

@implementation FPVideoPlayer {
    NSTimeInterval _durationWatched; /**< 已观看的时长 单位秒 */
}

- (void)updateDurationWatched {
    NSTimeInterval endTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.startTimeStamp > 0 && endTimeStamp > 0 && endTimeStamp > self.startTimeStamp) {
        _durationWatched += (endTimeStamp - self.startTimeStamp);
        self.startTimeStamp = 0;
    }
    
}

+ (instancetype)player {
    FPVideoPlayer *player = [super player];
    player.currentPlayerManager.shouldAutoPlay = NO;
    player.gestureManager.disableTypes = (FPPlayerDisableGestureTypesPan | FPPlayerDisableGestureTypesPinch | FPPlayerDisableGestureTypesLongPress);
    [player setupFPVideoPlayerBlocks];
    return player;
}


- (void)setupFPVideoPlayerBlocks {
    @weakify(self);
    self.gestureManager.singleTapped = ^(FPPlayerGestureManager * _Nonnull manager) {
        @strongify(self);
        !self.singleTappedPlayer ?: self.singleTappedPlayer();
    };
    
    self.gestureManager.doubleTapped = ^(FPPlayerGestureManager * _Nonnull manager) {
        @strongify(self);
        !self.doubleTappedPlayer ?: self.doubleTappedPlayer();
    };
}

- (BOOL)isStopped {
    return self.playState == FPPlayerPlayStatePlayStopped;
}

- (BOOL)isPaused {
    return self.playState == FPPlayerPlayStatePaused;
}

- (void)setAssetURL:(NSURL *)assetURL {
    [super setAssetURL:assetURL];
    
    // 重置数据
    _durationWatched = 0;
    self.startTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
}

- (void)play {
    [super play];
    
    self.startTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
}

- (void)replay {
    [super replay];

}

- (void)pause {
    [super pause];
    
    [self updateDurationWatched];
}

- (void)stop {
    [super stop];
    
    [self updateDurationWatched];
}

- (void)setBeginEnterPostTime:(int64_t)beginEnterPostTime {
    _beginEnterPostTime = beginEnterPostTime;
    
    [self resetWathchDuration];
}

- (NSTimeInterval)durationWatched {
    [self updateDurationWatched];
    return _durationWatched;
}

- (void)resetWathchDuration {
    // 重置数据
    _durationWatched = 0;
    self.startTimeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
}

@end
