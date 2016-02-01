//
//  UIResponder+HKTouchExts.m
//  LXDEventChain
//
//  Created by heke on 1/2/16.
//  Copyright © 2016年 滕雪. All rights reserved.
//

#import "UIResponder+HKTouchExts.h"
#import <objc/runtime.h>

@implementation UIResponder (HKTouchExts)

#pragma mark - Custom behave
#pragma mark - private
- (void)setEnableTouchAnimation:(BOOL)enableTouchAnimation {
    objc_setAssociatedObject(self, _cmd, [NSNumber numberWithBool:enableTouchAnimation], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)enableTouchAnimation {
    NSNumber *n = objc_getAssociatedObject(self, @selector(setEnableTouchAnimation:));
    if (!n) {
        return YES;
    }
    return n.boolValue;
}

//stote the animation layer weak reference
- (void)setHkTouchAnimationLayer:(CAShapeLayer *)layer {
    objc_setAssociatedObject(self, _cmd, layer, OBJC_ASSOCIATION_ASSIGN);
}

- (CAShapeLayer *)hkTouchAnimationLayer {
    CAShapeLayer *l = objc_getAssociatedObject(self, @selector(setHkTouchAnimationLayer:));
    return l;
}

- (void)addTouchAnimationWithTouchPoint:(CGPoint)touchPoint {
    UIView *viewSelf = (UIView *)self;
    
    CGRect rt = CGRectMake(touchPoint.x, touchPoint.y, 2, 2);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [self randomColor].CGColor;//[[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    layer.frame = rt;
    
    UIBezierPath *bpath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 2, 2)];
    layer.path = bpath.CGPath;
    
    [viewSelf.layer addSublayer:layer];
    viewSelf.layer.masksToBounds = YES;
    [layer addAnimation:[self hkTouchAnimation] forKey:@"hkTouchAnimation"];
}

- (UIColor *)randomColor {
    CGFloat red   = arc4random()%256;
    CGFloat green = arc4random()%256;
    CGFloat blue  = arc4random()%256;
    UIColor *randomC = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return randomC;
}

- (CAAnimation *)hkTouchAnimation {
    UIView *viewSelf = (UIView *)self;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    CGFloat v = viewSelf.bounds.size.width;
    if (v<viewSelf.bounds.size.height) {
        v = viewSelf.bounds.size.height;
    }
    animation.toValue = [NSNumber numberWithFloat:1.5*v/2.0];
    animation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    alphaAnimation.repeatCount = 1;
    alphaAnimation.autoreverses = NO;
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    alphaAnimation.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[animation, alphaAnimation];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = 0.8;
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    return animationGroup;
}

- (void)animationDidStart:(CAAnimation *)anim {
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [[self hkTouchAnimationLayer] removeAnimationForKey:@"hkTouchAnimation"];
    [[self hkTouchAnimationLayer] removeFromSuperlayer];
}

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
    NSLog(@"object:%@,touch Func:%@",[self class],@"hk_touchesBegan");
}

- (void)hk_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesMoved:touches withEvent:event];
    NSLog(@"object:%@,touch Func:%@",[self class],@"hk_touchesMoved");
    if ([self isKindOfClass:[UIView class]]) {
        UITouch *aT = [touches anyObject];
        CGPoint p = [aT locationInView:(UIView *)self];
        [self addTouchAnimationWithTouchPoint:p];
    }
}

- (void)hk_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesEnded:touches withEvent:event];
    NSLog(@"object:%@,touch Func:%@",[self class],@"hk_touchesEnded");
    if ([self isKindOfClass:[UIView class]]) {
        UITouch *aT = [touches anyObject];
        CGPoint p = [aT locationInView:(UIView *)self];
        [self addTouchAnimationWithTouchPoint:p];
    }
}

- (void)hk_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesCancelled:touches withEvent:event];
    NSLog(@"object:%@,touch Func:%@",[self class],@"hk_touchesCancelled");
}

@end
