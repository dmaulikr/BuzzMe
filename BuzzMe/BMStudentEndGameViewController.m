//
//  BMStudentEndGameViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 3/1/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMStudentEndGameViewController.h"

@interface BMStudentEndGameViewController ()

@end

@implementation BMStudentEndGameViewController

@synthesize questionArray;

#pragma mark - Init methods

- (instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    
    if (self) {
        questionArray = [array copy];
    }
    
    return self;
}

#pragma mark - View load/disappear methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    
    if (!questionArray)
        questionArray = [NSArray array];
    
    _allTextView = [[UITextView alloc] init];
    [_allTextView setBackgroundColor:[UIColor clearColor]];
    [_allTextView setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    [_allTextView setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_allTextView setTextAlignment:NSTextAlignmentLeft];
    _allTextView.editable = NO;
    _allTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_allTextView];
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setTitle:@"Mail" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(mailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_saveButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_saveButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _saveButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:20];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_saveButton];
    
    self.textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.textButton setTitle:@"Text" forState:UIControlStateNormal];
    [self.textButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [self.textButton addTarget:self action:@selector(textButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.textButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self.textButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self.textButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.textButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    self.textButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:20];
    self.textButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textButton];
    
    UIBarButtonItem *returnBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(returnBarButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:returnBarButton];
    
    [self loadTextViewWithArray:questionArray];
    
    [self updateConstraints];
}

#pragma mark - helper methods

- (void)loadTextViewWithArray:(NSArray *)array {
    NSString *string = @"";
    for (NSUInteger i = 0; i < [questionArray count]; i++) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%lu. %@\n", (unsigned long)(i+1), (NSString *)[questionArray objectAtIndex:i]]];
    }
    
    self.allTextView.text = string;
    
}

#pragma mark - UIButton methods

- (void)mailButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setSubject:@"Buzz Me Study Guide"];
        [mailComposeViewController setMessageBody:self.allTextView.text isHTML:NO];
        
        [self presentViewController:mailComposeViewController animated:YES completion:NULL];
    }
}

- (void)textButtonPressed:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.messageComposeDelegate = self;
        [messageComposeViewController setBody:self.allTextView.text];
        
        [self presentViewController:messageComposeViewController animated:YES completion:NULL];
    }
}

- (void)normalButtonPressed:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:20];
    
}

- (void)normalButtonHighlighted:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.037 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:25];
}

#pragma mark - UIBarButtonItem methods

- (void)returnBarButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - MFMailComposeViewController/MFMessageComposeViewController Delegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Constraints update

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_allTextView, _saveButton, _textButton, topThingy);
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_allTextView(>=100)][_saveButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *verticalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_allTextView(>=100)][_textButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_allTextView(>=100)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_saveButton(>=50)][_textButton(==_saveButton)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint1];
    [self.view addConstraints:verticalConstraint2];
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
}

@end
