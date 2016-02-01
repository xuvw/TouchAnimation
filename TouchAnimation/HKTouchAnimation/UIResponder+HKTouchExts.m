//
//  UIResponder+HKTouchExts.m
//  LXDEventChain
//
//  Created by heke on 1/2/16.
//  Copyright © 2016年 滕雪. All rights reserved.
//

#import "UIResponder+HKTouchExts.h"
#import <objc/runtime.h>
#import "UIView+HKTouchExts.h"

@implementation UIResponder (HKTouchExts)

#pragma mark - private methods

+ (void)load {
    Method origin = class_getInstanceMethod([self class], @selector(touchesBegan:withEvent:));
    Method dest   = class_getInstanceMethod([self class], @selector(hk_touchesBegan:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(touchesMoved:withEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_touchesMoved:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(touchesEnded:withEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_touchesEnded:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([self class], @selector(touchesCancelled:withEvent:));
    dest   = class_getInstanceMethod([self class], @selector(hk_touchesCancelled:withEvent:));
    method_exchangeImplementations(origin, dest);
}

- (void)hk_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesBegan:touches withEvent:event];
}

- (void)hk_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesMoved:touches withEvent:event];
    if ([self isKindOfClass:[UIView class]]) {
        UITouch *aT = [touches anyObject];
        CGPoint p = [aT locationInView:(UIView *)self];
        [(UIView *)self addTouchAnimationWithTouchPoint:p];
    }
}

- (void)hk_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesEnded:touches withEvent:event];
    if ([self isKindOfClass:[UIView class]]) {
        UITouch *aT = [touches anyObject];
        CGPoint p = [aT locationInView:(UIView *)self];
        [(UIView *)self addTouchAnimationWithTouchPoint:p];
    }
}

- (void)hk_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesCancelled:touches withEvent:event];
}

@end
