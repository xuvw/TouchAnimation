//
//  UIView+HKTouchExts.m
//  TouchAnimation
//
//  Created by heke on 1/2/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "UIView+HKTouchExts.h"
#import <objc/runtime.h>

@implementation UIView (HKTouchExts)

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
    CAAnimation *animation = [self hkTouchAnimation];
    animation.delegate = layer;
    [layer addAnimation:animation forKey:@"hkTouchAnimation"];
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
    return animationGroup;
}

@end
