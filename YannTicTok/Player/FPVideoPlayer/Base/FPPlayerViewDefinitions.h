//
//  FPPlayerViewDefinitions.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//

#ifndef FPPlayerViewDefinitions_h
#define FPPlayerViewDefinitions_h


typedef NS_ENUM(NSInteger, FPPlayerScalingMode) {
    FPPlayerScalingModeNone,       // No scaling.
    FPPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits.
    FPPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents.
    FPPlayerScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds.
};

typedef NS_ENUM(NSUInteger, FPPlayerPlaybackState) {
    FPPlayerPlayStateUnknown, /**< 未知 */
    FPPlayerPlayStatePlaying, /**< 播放中 */
    FPPlayerPlayStatePaused, /**< 暂停 */
    FPPlayerPlayStateInterrupted, /**< 被中断,例如来电中断 */
    FPPlayerPlayStatePlayFailed, /**< 失败 */
    FPPlayerPlayStatePlayStopped /**< 停止 */
};

typedef NS_OPTIONS(NSUInteger, FPPlayerLoadState) {
    FPPlayerLoadStateUnknown        = 0,
    FPPlayerLoadStatePrepare        = 1 << 0, /**< 准备阶段 */
    FPPlayerLoadStatePlayable       = 1 << 1, /**< 随时可播放 */
    FPPlayerLoadStatePlaythroughOK  = 1 << 2, // Playback will be automatically started.
    FPPlayerLoadStateStalled        = 1 << 3, /**< 开始播放时候,网络比较差等原因导致播放器buffer不够用,会进入这个状态,此时视频会自动暂停 */
};





#ifndef fp_weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define fp_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define fp_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define fp_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define fp_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef fp_strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define fp_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
    #else
        #define fp_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
#else
    #if __has_feature(objc_arc)
        #define fp_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
    #else
        #define fp_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
    #endif
    #endif
#endif


#endif /* FPPlayerViewDefinitions_h */

//#ifndef fp_weakify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//        #define fp_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
//        #else
//        #define fp_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//        #define fp_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
//        #else
//        #define fp_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
//        #endif
//    #endif
//#endif
//
//#ifndef fp_strongify
//    #if DEBUG
//        #if __has_feature(objc_arc)
//        #define fp_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
//        #else
//        #define fp_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
//        #endif
//    #else
//        #if __has_feature(objc_arc)
//        #define fp_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
//        #else
//        #define fp_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
//        #endif
//    #endif
//#endif

