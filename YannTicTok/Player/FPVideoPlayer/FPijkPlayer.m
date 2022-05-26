////
////  FPijkPlayer.m
////  YannIjkPlayer
////
////  Created by YannChee on 2021/11/2.
////
//
//#import "FPijkPlayer.h"
//#import "FPIJKPlayerManager.h"
//
//@interface FPijkPlayer ()
//
//@property(nonatomic, assign) NSInteger rotationNumber;
//@property(nonatomic, assign) BOOL isRotatedPlayerView;
//
//@end
//
//
//@implementation FPijkPlayer {
//    float _brightness;
//    FPPlayerGestureManager * _gestureManager;
//}
//
//+ (instancetype)player {
//    FPIJKPlayerManager *manager = [FPIJKPlayerManager new];
//
//    // 是否开启硬件解码
//    [manager.options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
//    // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
//    [manager.options setPlayerOptionIntValue:512 forKey:@"vol"];
//    // 最大fps
//    [manager.options setPlayerOptionIntValue:30 forKey:@"max-fps"];
//    // 跳帧开关，如果cpu解码能力不足，可以设置成5，否则
//    // 会引起音视频不同步，也可以通过设置它来跳帧达到倍速播放
//    [manager.options setPlayerOptionIntValue:5 forKey:@"framedrop"];
//    // 指定最大宽度
//    [manager.options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
//    // 自动转屏开关
//    [manager.options setFormatOptionIntValue:0 forKey:@"auto_convert"]; // 自动转屏开关
//    [manager.options setFormatOptionIntValue:1 forKey:@"reconnect"]; // 重连开启 BOOL
//    // 超时时间，timeout参数只对http设置有效，若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。rtmp的timeout参数含义和http的不一样。
//    [manager.options setFormatOptionIntValue:20 * 1000 * 1000 forKey:@"timeout"];
//    // 帧速率(fps)  （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
//    [manager.options setPlayerOptionIntValue:29.97 forKey:@"r"];
//    [manager.options setPlayerOptionIntValue:10 forKey:@"min-frames"];// 默认最小帧数 10
//
//    [manager.options setCodecOptionIntValue:IJK_AVDISCARD_NONREF forKey:@"skip_loop_filter"];//开启环路滤波（0比48清楚，但解码开销大，48基本没有开启环路滤波，清晰度低，解码开销小）
//
//    [manager.options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];// 如果使用rtsp协议，可以优先用tcp（默认udp）
//    // 播放前的探测Size，默认是1M, 改小一点会出画面更快
//    [manager.options setFormatOptionIntValue:1024 * 512 forKey:@"probesize"]; // 改成0.5M
//
//    //param for playback
//    [manager.options setPlayerOptionIntValue:10000 forKey:@"max_cached_duration"]; // 最大缓存时长10秒
////    [manager.options setPlayerOptionIntValue:4 * 1024 * 1024 forKey:@"max-buffer-size"]; // 最大缓存4 M, 这个属性不要设置,否则导致音画不同步
//    [manager.options setPlayerOptionIntValue:0 forKey:@"infbuf"]; // 关闭无限读
//    [manager.options setPlayerOptionIntValue:1 forKey:@"packet-buffering"]; // 开启播放器缓冲
//    
//    
//    
//    FPijkPlayer *player = [[self.class alloc] initWithPlayerManager:manager];
//    player.rotationNumber = -1;
//    [player setupPlayerUIInteraction];
//    return player;
//}
//
//- (void)setupPlayerUIInteraction {
//    
//    [self.gestureManager addGesturesToView:self.playerView];
//    self.gestureManager.disableTypes = FPPlayerDisableGestureTypesAll; // 禁用所有手势
//}
//
//- (void)setAssetURL:(NSURL *)assetURL {
//    //先获取视频地址的旋转方向
//    dispatch_queue_t serialQueue = dispatch_queue_create("mySerialQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(serialQueue, ^{
//        self.rotationNumber = [self degressFromVideoFileWithURL:assetURL];
//    });
//    self.isRotatedPlayerView = NO;
//    [super setAssetURL:assetURL];
//}
//
//// 旋转播放器的view
//- (void)rotatePlayerViewIfNeed {
//    if (self.rotationNumber <= 0 || self.isRotatedPlayerView) {
//        return;
//    }
//    
//    UIView *targetView = self.currentPlayerManager.view;
//    // 先复原
//    targetView.transform = CGAffineTransformIdentity;
//    
//    //判断旋转角度
//    if (self.rotationNumber == 90) {
//        targetView.transform = CGAffineTransformMakeRotation(M_PI_2);
//        CGSize newVideoSize = CGSizeMake(self.presentationSize.height, self.presentationSize.width);
//        targetView.frame =  [self calculatePlayerViewFrameWithPlayerFrame:self.frame videoSize:newVideoSize];
//        self.isRotatedPlayerView = YES;
//        return;
//    }
//    
//    //判断旋转角度
//    if (self.rotationNumber == 180) {
//        targetView.transform = CGAffineTransformMakeRotation(M_PI);
//        targetView.frame =  [self calculatePlayerViewFrameWithPlayerFrame:self.frame videoSize:self.presentationSize];
//        self.isRotatedPlayerView = YES;
//        return;
//    }
//    
//    //判断旋转角度
//    if (self.rotationNumber == 270) {
//        targetView.transform = CGAffineTransformMakeRotation(3 * M_PI_2);
//        CGSize newVideoSize = CGSizeMake(self.presentationSize.height, self.presentationSize.width);
//        targetView.frame =  [self calculatePlayerViewFrameWithPlayerFrame:self.frame videoSize:newVideoSize];
//        self.isRotatedPlayerView = YES;
//        return;
//    }
//}
//
//// 获取视频URL的旋转方向
//- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url {
//    NSUInteger degress = 0;
//    
//    AVAsset *asset = [AVAsset assetWithURL:url];
//    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
//    if([tracks count] > 0) {
//        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
//        CGAffineTransform t = videoTrack.preferredTransform;
//        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
//            // Portrait
//            degress = 90;
//        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
//            // PortraitUpsideDown
//            degress = 270;
//        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
//            // LandscapeRight
//            degress = 0;
//        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
//            // LandscapeLeft
//            degress = 180;
//        }
//    }
//    
//    return degress;
//}
//
//
//#pragma mark - setter and getter
//
//- (void)setBrightness:(float)brightness {
//    brightness = MIN(MAX(0, brightness), 1);
//    _brightness = brightness;
//    [UIScreen mainScreen].brightness = brightness;
//}
//
//- (float)brightness {
//    return [UIScreen mainScreen].brightness;
//}
//
//#pragma mark - only getter
//
//
//- (float)progress {
//    if (self.totalTime == 0) {
//        return 0;
//    }
//    return self.currentTime / self.totalTime;
//}
//
//- (float)bufferProgress {
//    if (self.totalTime == 0) {
//        return 0;
//    }
//    return self.bufferTime / self.totalTime;
//}
//
//#pragma mark - 懒加载
//
//- (FPPlayerGestureManager *)gestureManager {
//    if (!_gestureManager) {
//        FPPlayerGestureManager *manager = [[FPPlayerGestureManager alloc] init];
//        _gestureManager = manager;
//    }
//    return _gestureManager;
//}
//
//@end
