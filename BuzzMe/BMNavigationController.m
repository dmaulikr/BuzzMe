//
//  BMNavigationController.m
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMNavigationController.h"

@implementation BMNavigationController

/*- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIView *theWindow = self.view ;
    if( animated ) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[theWindow layer] addAnimation:animation forKey:@""];
    }
    
    [super pushViewController:viewController animated:NO];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIView *theWindow = self.view ;
    if( animated ) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.45f];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[theWindow layer] addAnimation:animation forKey:@""];
    }
    return [super popViewControllerAnimated:NO];
} */

@end
