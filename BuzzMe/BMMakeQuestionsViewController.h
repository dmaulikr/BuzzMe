//
//  BMMakeQuestionsViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 2/16/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMAddQuestionViewController.h"

@interface BMMakeQuestionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, BMAddQuestionViewControllerDelegate>

@property (nonatomic, strong) UITableView *questionsTableView;
@property (nonatomic, strong) UIBarButtonItem *addQuestionBarButton;

@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) NSString *filePath;

@end
