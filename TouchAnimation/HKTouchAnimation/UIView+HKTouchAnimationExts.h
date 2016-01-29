//
//  UIView+HKTouchAnimationExts.h
//  TouchAnimation
//
//  Created by heke on 29/1/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HKTouchAnimationExts)

//default YES;
@property (nonatomic, assign) BOOL enableTouchAnimation;

- (void)addTouchAnimationWithTouchPoint:(CGPoint)touchPoint;

@end

@interface UIViewController (HKTouchAnimationExts)

@end
