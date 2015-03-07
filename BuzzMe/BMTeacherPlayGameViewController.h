//
//  BMTeacherPlayGameViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 2/20/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "BMLoadViewQuestionViewController.h"

@interface BMTeacherPlayGameViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate, BMLoadViewQuestionViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) NSMutableArray *scoreConnectedDevices;
@property (nonatomic, strong) NSArray *questionsArray;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UITextView *questionTextField;
@property (nonatomic, strong) UITextField *answerTextField;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *roundButton;
@property (nonatomic, strong) UIButton *gameOverButton;
@property (nonatomic, strong) UIButton *loadQuestionButton;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, strong) UIBarButtonItem *scoresBarButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property NSUInteger playersPerTeam;

@end
