//
//  FPPlayerGestureManager.m
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/2.
//

#import "FPPlayerGestureManager.h"

@interface FPPlayerGestureManager () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *targetView; /**< 被添加手势的view */

@end

@implementation FPPlayerGestureManager {
    UITapGestureRecognizer * _singleTap; /**< 单击手势 */
    UITapGestureRecognizer * _doubleTap; /**< 双击手势 */
    UIPanGestureRecognizer * _panGR; /**< 拖拽手势 */
    UIPinchGestureRecognizer * _pinchGR; /**< 捏合手势 */
    UILongPressGestureRecognizer * _longPressGesture; /**< 长按手势 */
}

- (void)addGesturesToView:(UIView *)view {
    self.targetView = view;
    self.targetView.multipleTouchEnabled = YES;
    
    [self.targetView addGestureRecognizer:self.singleTap];
    [self.targetView addGestureRecognizer:self.doubleTap];
    [self.targetView addGestureRecognizer:self.panGR];
    [self.targetView addGestureRecognizer:self.pinchGR];
    [self.targetView addGestureRecognizer:self.longPressGesture];
    
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    [self.singleTap requireGestureRecognizerToFail:self.panGR];
}

- (void)removeGestureToView:(UIView *)view {
    [view removeGestureRecognizer:self.singleTap];
    [view removeGestureRecognizer:self.doubleTap];
    [view removeGestureRecognizer:self.panGR];
    [view removeGestureRecognizer:self.pinchGR];
    [view removeGestureRecognizer:self.longPressGesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGR) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.targetView];
        CGFloat x = fabs(translation.x);
        CGFloat y = fabs(translation.y);
        if (x < y && (self.disablePanMovingDirection & FPPlayerDisablePanMovingDirectionVertical)) { /// up and down moving direction.
            return NO;
        } else if (x > y && self.disablePanMovingDirection & FPPlayerDisablePanMovingDirectionHorizontal) { /// left and right moving direction.
            return NO;
        }
    }
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    FPPlayerGestureType type = FPPlayerGestureTypeUnknown;
    if (gestureRecognizer == self.singleTap) {
        type = FPPlayerGestureTypeSingleTap;
    } else if (gestureRecognizer == self.doubleTap) {
        type = FPPlayerGestureTypeDoubleTap;
    } else if (gestureRecognizer == self.panGR) {
        type = FPPlayerGestureTypePan;
    } else if (gestureRecognizer == self.pinchGR) {
        type = FPPlayerGestureTypePinch;
    }
    
    
    CGPoint locationPoint = [touch locationInView:touch.view];
    if (locationPoint.x > _targetView.bounds.size.width * 0.5) {
        _panLocation = FPPanLocationRight;
    } else {
        _panLocation = FPPanLocationLeft;
    }
    
    switch (type) {
        case FPPlayerGestureTypeUnknown:
            break;
        case FPPlayerGestureTypePan: {
            if (self.disableTypes & FPPlayerDisableGestureTypesPan) {
                return NO;
            }
        } break;
        case FPPlayerGestureTypePinch: {
            if (self.disableTypes & FPPlayerDisableGestureTypesPinch) {
                return NO;
            }
        } break;
        case FPPlayerGestureTypeDoubleTap: {
            if (self.disableTypes & FPPlayerDisableGestureTypesDoubleTap) {
                return NO;
            }
        } break;
        case FPPlayerGestureTypeSingleTap: {
            if (self.disableTypes & FPPlayerDisableGestureTypesSingleTap) {
                return NO;
            }
        } break;
    }
    
    if (self.triggerCondition) {
        return self.triggerCondition(self, type, gestureRecognizer, touch);
    };
    return YES;
}

// Whether to support multi-trigger, return YES, you can trigger a method with multiple gestures, return NO is mutually exclusive
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer != self.singleTap &&
        otherGestureRecognizer != self.doubleTap &&
        otherGestureRecognizer != self.panGR &&
        otherGestureRecognizer != self.pinchGR) {
        return NO;
    };
    
    if (gestureRecognizer == self.panGR) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.targetView];
        CGFloat x = fabs(translation.x);
        CGFloat y = fabs(translation.y);
        if (x < y && (self.disablePanMovingDirection & FPPlayerDisablePanMovingDirectionVertical)) {
            return YES;
        } else if (x > y && self.disablePanMovingDirection & FPPlayerDisablePanMovingDirectionHorizontal) {
            return YES;
        }
    }
    if (gestureRecognizer.numberOfTouches >= 2) {
        return NO;
    }
    return YES;
}

#pragma mark - 手势事件

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    !self.singleTapped ?: self.singleTapped(self);
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    !self.doubleTapped ?: self.doubleTapped(self);
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translate = [pan translationInView:pan.view];
    CGPoint velocity = [pan velocityInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            _panMovingDirection = FPPlayerPanMovingDirectionUnkown;
            CGFloat x = fabs(velocity.x);
            CGFloat y = fabs(velocity.y);
            if (x > y) {
                _panDirection = FPPlayerPanDirectionH;
            } else if (x < y) {
                _panDirection = FPPlayerPanDirectionV;
            } else {
                _panDirection = FPPlayerPanDirectionUnknown;
            }
            
            if (self.beganPan) self.beganPan(self, self.panDirection, self.panLocation);
        } break;
            
        case UIGestureRecognizerStateChanged: {
            switch (_panDirection) {
                case FPPlayerPanDirectionH: {
                    if (translate.x > 0) {
                        _panMovingDirection = FPPlayerPanMovingDirectionRight;
                    } else {
                        _panMovingDirection = FPPlayerPanMovingDirectionLeft;
                    }
                } break;
                    
                case FPPlayerPanDirectionV: {
                    if (translate.y > 0) {
                        _panMovingDirection = FPPlayerPanMovingDirectionBottom;
                    } else {
                        _panMovingDirection = FPPlayerPanMovingDirectionTop;
                    }
                } break;
                case FPPlayerPanDirectionUnknown:
                    break;
            }
            !self.changedPan ?: self.changedPan(self, self.panDirection, self.panLocation, velocity);
        } break;
            
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            !self.endedPan ?: self.endedPan(self, self.panDirection, self.panLocation);
        } break;
            
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    switch (pinch.state) {
        case UIGestureRecognizerStateEnded: {
            if (self.pinched) self.pinched(self, pinch.scale);
        }
            break;
        default:
            break;
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        !self.longPressed ?: self.longPressed(self);
    }
}


//- (BOOL)checkGestureIsSupported:(PFPlayerGestureType) gestureType {
//    return self.supportedGestureTypes & gestureType;
//}

#pragma mark - 懒加载
- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.delegate = self;
        _singleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.numberOfTapsRequired = 1;
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.delegate = self;
        _doubleTap.delaysTouchesBegan = YES;
        _singleTap.delaysTouchesEnded = YES;
        _doubleTap.numberOfTouchesRequired = 1;
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)panGR {
    if (!_panGR) {
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGR.delegate = self;
        _panGR.delaysTouchesBegan = YES;
        _panGR.delaysTouchesEnded = YES;
        _panGR.maximumNumberOfTouches = 1;
        _panGR.cancelsTouchesInView = YES;
    }
    return _panGR;
}

- (UIPinchGestureRecognizer *)pinchGR {
    if (!_pinchGR) {
        _pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        _pinchGR.delegate = self;
        _pinchGR.delaysTouchesBegan = YES;
    }
    return _pinchGR;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [UILongPressGestureRecognizer.alloc initWithTarget:self action:@selector(handleLongPress:)];
        _longPressGesture.delaysTouchesBegan = YES;
        _longPressGesture.delegate = self;
        _longPressGesture.minimumPressDuration = 1.5;
        [self.panGR shouldRequireFailureOfGestureRecognizer:_longPressGesture];
    }
    return _longPressGesture;
}
@end
