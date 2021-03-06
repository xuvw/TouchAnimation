//
//  CALayer+HKTouchExts.h
//  TouchAnimation
//
//  Created by heke on 1/2/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (HKTouchExts)

/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim;

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end
