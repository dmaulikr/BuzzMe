//
//  BMTeacherViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "BMTeacherPlayGameViewController.h"
#import "BMMakeQuestionsViewController.h"

/*
@protocol BMTeacherViewControllerDelegate<NSObject>
@required
- (void)didFinishWithArray:(NSMutableArray *)array;
@end
 */

@interface BMTeacherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

//@property (nonatomic, weak) id<BMTeacherViewControllerDelegate> delegate;

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;
@property (nonatomic, strong) UIBarButtonItem *teamsBarButton;
@property (nonatomic, strong) UITableViewController *tblConnectedDevices;
@property (nonatomic, strong) UITextField *navTextField;

@property (nonatomic, strong) UIButton *makeQuestionsButton;
@property (nonatomic, strong) UIButton *playGameButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property NSUInteger playersPerTeam;

@end
