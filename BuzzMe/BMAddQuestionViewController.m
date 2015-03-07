//
//  BMAddQuestionViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 2/22/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMAddQuestionViewController.h"

@implementation BMAddQuestionViewController

#define QUESTION_KEY @"kQuestionKey"
#define ANSWER_KEY @"kAnswerKey"

@synthesize delegate, dictPlace, addAnswerViewText, addQuestionViewText, addQuestionAndAnswerButtonText;

#pragma mark - View load/disappear methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    
    _addQuestionView = [[UITextView alloc] init];
    [_addQuestionView setBackgroundColor:[UIColor clearColor]];
    [_addQuestionView setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    //[_addQuestionView setText:@"Type Question Here"];
    [_addQuestionView setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_addQuestionView setTextAlignment:NSTextAlignmentCenter];
    _addQuestionView.editable = YES;
    _addQuestionView.translatesAutoresizingMaskIntoConstraints = NO;
    _addQuestionView.delegate = self;
    
    if (!addQuestionViewText)
        [_addQuestionView setText:@"Type Question Here"];
    else
        [_addQuestionView setText:addQuestionViewText];
    
    [self.view addSubview:_addQuestionView];
    
    _addAnswerView = [[UITextView alloc] init];
    [_addAnswerView setBackgroundColor:[UIColor clearColor]];
    [_addAnswerView setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    //[_addAnswerView setText:@"Type Answer Here"];
    [_addAnswerView setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_addAnswerView setTextAlignment:NSTextAlignmentCenter];
    _addAnswerView.editable = YES;
    _addAnswerView.translatesAutoresizingMaskIntoConstraints = NO;
    _addAnswerView.delegate = self;
    
    if (!addAnswerViewText)
        [_addAnswerView setText:@"Type Answer Here"];
    else
        [_addAnswerView setText:addAnswerViewText];
    
    [self.view addSubview:_addAnswerView];
    
    _clearQuestionAndAnswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearQuestionAndAnswerButton setTitle:@"Clear" forState:UIControlStateNormal];
    [_clearQuestionAndAnswerButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_clearQuestionAndAnswerButton addTarget:self action:@selector(clearQuestionAndAnswerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_clearQuestionAndAnswerButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_clearQuestionAndAnswerButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_clearQuestionAndAnswerButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _clearQuestionAndAnswerButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _clearQuestionAndAnswerButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:25];
    _clearQuestionAndAnswerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_clearQuestionAndAnswerButton];
    
    _addQuestionAndAnswerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_addQuestionAndAnswerButton setTitle:@"Add" forState:UIControlStateNormal];
    [_addQuestionAndAnswerButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_addQuestionAndAnswerButton addTarget:self action:@selector(addQuestionAndAnswerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_addQuestionAndAnswerButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_addQuestionAndAnswerButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_addQuestionAndAnswerButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _addQuestionAndAnswerButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _addQuestionAndAnswerButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:25];
    _addQuestionAndAnswerButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!addQuestionAndAnswerButtonText)
        [_addQuestionAndAnswerButton setTitle:@"Add" forState:UIControlStateNormal];
    else
        [_addQuestionAndAnswerButton setTitle:addQuestionAndAnswerButtonText forState:UIControlStateNormal];
    
    [self.view addSubview:_addQuestionAndAnswerButton];
    
    [self updateConstraints];
}

#pragma mark - UIButton methods

- (void)clearQuestionAndAnswerButtonPressed:(id)sender {
    [_addQuestionView setText:@"Type Question Here"];
    [_addAnswerView setText:@"Type Answer Here"];
}

- (void)addQuestionAndAnswerButtonPressed:(id)sender {
    NSDictionary *dict = @{QUESTION_KEY : [_addQuestionView text],
                     ANSWER_KEY : [_addAnswerView text],
                     };
    
    if ([_addQuestionAndAnswerButton.titleLabel.text isEqualToString:@"Replace"]) {
        [self.delegate replaceQuestionAndAnswerWithDict:dict withIndex:dictPlace];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([_addQuestionAndAnswerButton.titleLabel.text isEqualToString:@"Add"]) {
        [self.delegate addQuestionAndAnswerWithDict:dict];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self clearQuestionAndAnswerButtonPressed:nil];
}

- (void)normalButtonPressed:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:25];
    
}

- (void)normalButtonHighlighted:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.037 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:30];
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Type Question Here"] || [[textView text] isEqualToString:@"Type Answer Here"])
        [textView setText:@""];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    
    return YES;
}

#pragma mark - Constraint method

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_addQuestionView, _addAnswerView, _clearQuestionAndAnswerButton, _addQuestionAndAnswerButton, topThingy);
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_addQuestionView(>=100)][_addAnswerView(==_addQuestionView)][_clearQuestionAndAnswerButton(>=40,<=60)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *verticalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_addQuestionView(>=100)][_addAnswerView(==_addQuestionView)][_addQuestionAndAnswerButton(>=40,<=60)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addQuestionView(>=100)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addAnswerView(>=100)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_clearQuestionAndAnswerButton(>=50)][_addQuestionAndAnswerButton(==_clearQuestionAndAnswerButton)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint1];
    [self.view addConstraints:verticalConstraint2];
    
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
    [self.view addConstraints:horizontalConstraint3];
}

@end
