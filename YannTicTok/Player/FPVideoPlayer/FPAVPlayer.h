//
//  FPAVPlayer.h
//  Funnyplanet
//
//  Created by YannChee on 2021/12/5.
//

#import "FPPlayer.h"
#import "FPPlayerGestureManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FPAVPlayer : FPPlayer

+ (instancetype)player;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// 扩充属性
@property (nonatomic, readonly) FPPlayerGestureManager *gestureManager; /**< 手势manager */

@property(nonatomic, assign, readonly) float progress; /**< 视频进度 */
@property(nonatomic, assign, readonly) float bufferProgress; /**< 缓冲进度 */


@property (nonatomic,assign) float brightness; /**<  亮度范围0到1 ,只支持在主屏幕上才生效 */

- (void)rotatePlayerViewIfNeed;

@end

NS_ASSUME_NONNULL_END
