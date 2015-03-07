//
//  BMStudentPlayGameViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 2/17/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BMStudentEndGameViewController.h"


@interface BMStudentPlayGameViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UITextView *questionTextField;
@property (nonatomic, strong) UITextField *answerTextField;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) MCPeerID *teacherPeerID;

@property (nonatomic, strong) NSMutableArray *questionArray;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
