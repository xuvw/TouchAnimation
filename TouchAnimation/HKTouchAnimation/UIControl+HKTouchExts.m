//
//  UIControl+HKTouchExts.m
//  TouchAnimation
//
//  Created by heke on 1/2/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "UIControl+HKTouchExts.h"
#import <objc/runtime.h>
#import "UIView+HKTouchExts.h"

@implementation UIControl (HKTouchExts)

+ (void)load {
    Method origin = class_getInstanceMethod([self class], @selector(beginTrackingWithTouch:withEvent:));
    Method dest   = class_getInstanceMethod([self class], @selector(hk_beginTrackingWithTouch:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(continueTrackingWithTouch:withEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_continueTrackingWithTouch:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(endTrackingWithTouch:withEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_endTrackingWithTouch:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(cancelTrackingWithEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_cancelTrackingWithEvent:));
    method_exchangeImplementations(origin, dest);
}

- (BOOL)hk_beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    BOOL code = [self hk_beginTrackingWithTouch:touch withEvent:event];
    
    return code;
}

- (BOOL)hk_continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    BOOL code = [self hk_continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint p = [touch locationInView:self];
    [self addTouchAnimationWithTouchPoint:p];
    
    return code;
}

- (void)hk_endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    [self hk_endTrackingWithTouch:touch withEvent:event];
    
    CGPoint p = [touch locationInView:self];
    [self addTouchAnimationWithTouchPoint:p];
}

- (void)hk_cancelTrackingWithEvent:(nullable UIEvent *)event {
    [self hk_cancelTrackingWithEvent:event];
}

@end
