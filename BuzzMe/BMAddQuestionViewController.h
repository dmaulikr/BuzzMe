//
//  BMAddQuestionViewController.h
//  BuzzMe
//
//  Created by Tim Wong on 2/22/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMAddQuestionViewControllerDelegate <NSObject>

- (void)addQuestionAndAnswerWithDict:(NSDictionary *)dict;
- (void)replaceQuestionAndAnswerWithDict:(NSDictionary *)dict withIndex:(NSUInteger)index;

@end


@interface BMAddQuestionViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<BMAddQuestionViewControllerDelegate> delegate;

@property (nonatomic, strong) UITextView *addQuestionView;
@property (nonatomic, strong) UITextView *addAnswerView;
@property (nonatomic, strong) UIButton *addQuestionAndAnswerButton;
@property (nonatomic, strong) UIButton *clearQuestionAndAnswerButton;

@property (nonatomic, strong) NSString *addQuestionViewText;
@property (nonatomic, strong) NSString *addAnswerViewText;
@property (nonatomic, strong) NSString *addQuestionAndAnswerButtonText;

@property NSUInteger dictPlace;

@end
