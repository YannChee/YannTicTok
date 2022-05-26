//
//  FPPlayerGestureManager.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/2.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

/** 手势 */
typedef NS_ENUM(NSUInteger,FPPlayerGestureType) {
   FPPlayerGestureTypeUnknown,
   FPPlayerGestureTypeSingleTap, /**< 单击 */
   FPPlayerGestureTypeDoubleTap, /**< 双击 */
   FPPlayerGestureTypePan, /**< 拖拽 */
   FPPlayerGestureTypePinch /**< 捏合 */
};

/** 拖拽方向 */
typedef NS_ENUM(NSUInteger, FPPlayerPanDirection) {
    FPPlayerPanDirectionUnknown,
    FPPlayerPanDirectionV, /**< 竖直方向拖拽 */
    FPPlayerPanDirectionH /**< 水平方向拖拽 */
};

typedef NS_ENUM(NSUInteger, FPPanLocation) {
    FPPanLocationUnknown,
    FPPanLocationLeft,
    FPPanLocationRight,
};

/** 拖拽移动方向 */
typedef NS_ENUM(NSUInteger, FPPlayerPanMovingDirection) {
    FPPlayerPanMovingDirectionUnkown,
    FPPlayerPanMovingDirectionTop,
    FPPlayerPanMovingDirectionLeft,
    FPPlayerPanMovingDirectionBottom,
    FPPlayerPanMovingDirectionRight,
};



typedef NS_OPTIONS(NSUInteger, FPPlayerDisableGestureTypes) {
    FPPlayerDisableGestureTypesNone         = 0,
    FPPlayerDisableGestureTypesSingleTap    = 1 << 0,
    FPPlayerDisableGestureTypesDoubleTap    = 1 << 1,
    FPPlayerDisableGestureTypesPan          = 1 << 2,
    FPPlayerDisableGestureTypesPinch        = 1 << 3,
    FPPlayerDisableGestureTypesLongPress    = 1 << 4,
    
    FPPlayerDisableGestureTypesAll          = (FPPlayerDisableGestureTypesSingleTap | FPPlayerDisableGestureTypesDoubleTap | FPPlayerDisableGestureTypesPan | FPPlayerDisableGestureTypesPinch | FPPlayerDisableGestureTypesLongPress)
};

///** 支持的手势 */
//typedef NS_OPTIONS(NSUInteger, PFPlayerGestureType) {
//    PFPlayerGestureTypeNone,
//    PFPlayerGestureTypeSingleTap   = 1 << 0,
//    PFPlayerGestureTypeDoubleTap   = 1 << 1,
//    PFPlayerGestureTypePan         = 1 << 2,
//    PFPlayerGestureTypePinch       = 1 << 3,
//    PFPlayerGestureTypeLongPress   = 1 << 4,
//
//    PFPlayerGestureTypeAll = (PFPlayerGestureTypeSingleTap | PFPlayerGestureTypeDoubleTap | PFPlayerGestureTypePan | PFPlayerGestureTypePinch | PFPlayerGestureTypeLongPress)
//};


/** 禁用的拖拽方向 */
typedef NS_OPTIONS(NSUInteger, FPPlayerDisablePanMovingDirection) {
    FPPlayerDisablePanMovingDirectionNone         = 0,  /**<  不禁用 */
    FPPlayerDisablePanMovingDirectionVertical     = 1 << 0,  /**<  禁用竖直方向拖拽 */
    FPPlayerDisablePanMovingDirectionHorizontal   = 1 << 1,  /**<  禁用水平方向拖拽 */
    FPPlayerDisablePanMovingDirectionAll          = (FPPlayerDisablePanMovingDirectionVertical | FPPlayerDisablePanMovingDirectionHorizontal) /**< 禁用所有方向 */
};



@interface FPPlayerGestureManager : NSObject

/** 手势是否支持 */
@property (nonatomic, copy, nullable) BOOL(^triggerCondition)(FPPlayerGestureManager *manager, FPPlayerGestureType type, UIGestureRecognizer *gesture, UITouch *touch);

/** 点击手势回调 */
@property (nonatomic, copy, nullable) void(^singleTapped)(FPPlayerGestureManager *manager);
/** 双击手势回调 */
@property (nonatomic, copy, nullable) void(^doubleTapped)(FPPlayerGestureManager *manager);

/** 拖拽手势开始 */
@property (nonatomic, copy, nullable) void(^beganPan)(FPPlayerGestureManager *manager, FPPlayerPanDirection direction, FPPanLocation location);
/** 拖拽手势变化中 */
@property (nonatomic, copy, nullable) void(^changedPan)(FPPlayerGestureManager *manager, FPPlayerPanDirection direction, FPPanLocation location, CGPoint velocity);
/** 拖拽手势结束 */
@property (nonatomic, copy, nullable) void(^endedPan)(FPPlayerGestureManager *manager, FPPlayerPanDirection direction, FPPanLocation location);

/** 捏合手势 */
@property (nonatomic, copy, nullable) void(^pinched)(FPPlayerGestureManager *manager, float scale);
/** 长按手势回调 */
@property (nonatomic, copy, nullable) void(^longPressed)(FPPlayerGestureManager *manager);

@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTap; /**< 单击手势 */
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTap; /**< 双击手势 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGR; /**< 拖拽手势 */
@property (nonatomic, strong, readonly) UIPinchGestureRecognizer *pinchGR; /**< 捏合手势 */
@property(nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture; /**< 长按手势 */

@property (nonatomic, readonly) FPPlayerPanDirection panDirection; /**< 拖拽方向 */

/// The pan location.
@property (nonatomic, readonly) FPPanLocation panLocation;

/// The moving drection.
@property (nonatomic, readonly) FPPlayerPanMovingDirection panMovingDirection;

@property (nonatomic) FPPlayerDisableGestureTypes disableTypes; /**< 禁用的手势 */
@property (nonatomic) FPPlayerDisablePanMovingDirection disablePanMovingDirection; /**< 禁用的拖拽方向 */


/** 默认添加所有手势到view上 */
- (void)addGesturesToView:(UIView *)view;

/**
 Remove all gestures(singleTap、doubleTap、panGR、pinchGR) form the view.
 */
- (void)removeGestureToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
