//
//  AppDelegate.h
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCStudent.h"
#import "MCTeacher.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MCStudent *manager;
@property (nonatomic, strong) MCTeacher *teacher;

@end

