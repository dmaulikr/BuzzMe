//
//  BMLoadViewQuestionViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 2/22/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMLoadViewQuestionViewControllerDelegate <NSObject>

- (void)didSelectQuestion:(NSString *)question withAnswer:(NSString *)answer;

@end

@interface BMLoadViewQuestionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<BMLoadViewQuestionViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *questionsArray;
@property (nonatomic, strong) UITableView *questionsTableView;

@end
