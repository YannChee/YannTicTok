//
//  FPAVPlayer.m
//  Funnyplanet
//
//  Created by YannChee on 2021/12/5.
//

#import "FPAVPlayer.h"
#import "FPAVPlayerManager.h"



@implementation FPAVPlayer {
    float _brightness;
    FPPlayerGestureManager * _gestureManager;
}

+ (instancetype)player {
    FPAVPlayerManager *manager = [FPAVPlayerManager new];
    
    FPAVPlayer *player = [[self.class alloc] initWithPlayerManager:manager];
    [player setupPlayerUIInteraction];
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetooth
                   error:nil];
    return player;
}

- (void)setupPlayerUIInteraction {
    
    [self.gestureManager addGesturesToView:self.playerView];
    self.gestureManager.disableTypes = FPPlayerDisableGestureTypesAll; // 禁用所有手势
}

- (void)setAssetURL:(NSURL *)assetURL {
    [super setAssetURL:assetURL];
    
}

// 旋转播放器的view
- (void)rotatePlayerViewIfNeed { }

#pragma mark - only getter
- (float)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}

- (float)bufferProgress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.bufferTime / self.totalTime;
}

#pragma mark - 懒加载

- (FPPlayerGestureManager *)gestureManager {
    if (!_gestureManager) {
        FPPlayerGestureManager *manager = [[FPPlayerGestureManager alloc] init];
        _gestureManager = manager;
    }
    return _gestureManager;
}

@end
