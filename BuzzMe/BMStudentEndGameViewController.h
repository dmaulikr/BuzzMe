//
//  BMStudentEndGameViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 3/1/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface BMStudentEndGameViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITextView *allTextView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *textButton;

@property (nonatomic, strong) NSArray *questionArray;

- (instancetype)initWithArray:(NSArray *)array;

@end
