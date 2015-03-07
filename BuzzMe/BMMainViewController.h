//
//  BMMainViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BMTeacherViewController.h"
#import "BMStudentViewController.h"
#import "BMTeacherViewController.h"

@interface BMMainViewController : UIViewController

@property (nonatomic, strong) UIButton *studentButton;
@property (nonatomic, strong) UIButton *teacherButton;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (void)normalButtonPressed:(id)sender;
- (void)normalButtonHighlighted:(id)sender;
- (void)studentButtonPresed:(id)sender;
- (void)teacherButtonPressed:(id)sender;
- (void)setupConstraints;

@end
