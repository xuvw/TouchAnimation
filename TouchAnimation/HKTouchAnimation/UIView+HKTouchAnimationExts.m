//
//  UIView+HKTouchAnimationExts.m
//  TouchAnimation
//
//  Created by heke on 29/1/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "UIView+HKTouchAnimationExts.h"
#import <objc/runtime.h>

@implementation UIView (HKTouchAnimationExts)

+ (void)load {
    Method origin = class_getInstanceMethod([UIView class], @selector(touchesEnded:withEvent:));
    Method dest   = class_getInstanceMethod([UIView class], @selector(hk_touchesEnded:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([UIView class], @selector(touchesBegan:withEvent:));
    dest = class_getInstanceMethod([UIView class], @selector(hk_touchesBegan:withEvent:));
    method_exchangeImplementations(origin, dest);
    
    origin = class_getInstanceMethod([UIView class], @selector(touchesMoved:withEvent:));
    dest = class_getInstanceMethod([UIView class], @selector(hk_touchesMoved:withEvent:));
    method_exchangeImplementations(origin, dest);
}

- (void)hk_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesBegan:touches withEvent:event];
}

- (void)hk_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesMoved:touches withEvent:event];
    
    UITouch *aT = [touches anyObject];
    CGPoint p = [aT locationInView:self];
    [self addTouchAnimationWithTouchPoint:p];
}

- (void)hk_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hk_touchesEnded:touches withEvent:event];
    
    UITouch *aT = [touches anyObject];
    CGPoint p = [aT locationInView:self];
    [self addTouchAnimationWithTouchPoint:p];
}

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
    CGRect rt = CGRectMake(touchPoint.x, touchPoint.y, 2, 2);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [self randomColor].CGColor;//[[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    layer.frame = rt;
    
    UIBezierPath *bpath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 2, 2)];
    layer.path = bpath.CGPath;
    
    [self.layer addSublayer:layer];
    self.layer.masksToBounds = YES;
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
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    CGFloat v = self.bounds.size.width;
    if (v<self.bounds.size.height) {
        v = self.bounds.size.height;
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

@end

@implementation UIViewController (HKTouchAnimationExts)

- (void)hk_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //
}

- (void)hk_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //
}

- (void)hk_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //
}

@end
