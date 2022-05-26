//
//  FPAVPlayerManager.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/12/5.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FPPlayerMediaPlayback.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPAVPlayerManager : NSObject <FPPlayerMediaPlayback>

@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, assign) NSTimeInterval timeRefreshInterval;
/// 视频请求头
@property (nonatomic, strong) NSDictionary *requestHeader;

@property (nonatomic, strong, readonly) AVPlayerLayer *avPlayerLayer;

@end

NS_ASSUME_NONNULL_END
