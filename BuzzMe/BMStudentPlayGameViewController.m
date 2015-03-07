//
//  BMStudentPlayGameViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 2/17/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMStudentPlayGameViewController.h"

@implementation BMStudentPlayGameViewController

@synthesize teacherPeerID, questionArray;

#pragma mark - load/disappear methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.questionArray = [[NSMutableArray alloc] init];
    
    _questionTextField = [[UITextView alloc] init];
    //[_questionTextField setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    [_questionTextField setBackgroundColor:[UIColor clearColor]];
    [_questionTextField setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    //_questionTextField.text = @"This is a test of something that takes up a lot of lines just to see what it does";
    [_questionTextField setText:@"Waiting for Question"];
    [_questionTextField setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_questionTextField setTextAlignment:NSTextAlignmentCenter];
    _questionTextField.editable = NO;
    _questionTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_questionTextField];
    
    _questionLabel = [[UILabel alloc] init];
    [_questionLabel setBackgroundColor:[UIColor clearColor]];
    [_questionLabel setText:@"Question"];
    [_questionLabel setTextColor:[UIColor whiteColor]];
    [_questionLabel setFont:[UIFont fontWithName:@"Existence-Light" size:25]];
    _questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_questionLabel];
    
    _answerTextField = [[UITextField alloc] init];
    [_answerTextField setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    [_answerTextField setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    [_answerTextField setText:@"Answer Here"];
    [_answerTextField setFont:[UIFont fontWithName:@"Existence-Light" size:25]];
    [_answerTextField setTextAlignment:NSTextAlignmentCenter];
    _answerTextField.enabled = NO;
    _answerTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _answerTextField.delegate = self;
    [self.view addSubview:_answerTextField];
    
    _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_clearButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_clearButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _clearButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _clearButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:20];
    _clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    _clearButton.enabled = NO;
    [self.view addSubview:_clearButton];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_submitButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _submitButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _submitButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:20];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    _submitButton.enabled = NO;
    [self.view addSubview:_submitButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studentDidReceiveDataWithNotification:) name:@"MCStudentDidReceiveData" object:nil];
    
    [self updateConstraints];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_appDelegate.manager.session disconnect];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCStudentDidReceiveData" object:nil];
}

/* - (void)dealloc {
    [_appDelegate.manager.session disconnect];
    
} */

#pragma mark - NSNotificationCenter methods

- (void)studentDidReceiveDataWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *displayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([receivedText hasPrefix:@"Question:"]) {
        NSString *questionText = [receivedText substringFromIndex:9];
        [self.questionArray addObject:questionText];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [_questionTextField setText:questionText];
            [_answerTextField setEnabled:YES];
            [_clearButton setEnabled:YES];
            [_submitButton setEnabled:YES];
        });
    }
    
    else if ([receivedText hasPrefix:@"Round Over:"])
    {
        NSString *name = [receivedText substringFromIndex:11];
        NSString *updateText = [name stringByAppendingString:@" - Correct!"];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [SVProgressHUD showSuccessWithStatus:updateText maskType:SVProgressHUDMaskTypeNone];
            [_questionTextField setText:updateText];
            [_answerTextField setEnabled:NO];
            [_answerTextField setText:@"Answer Here"];
            [_clearButton setEnabled:NO];
            [_submitButton setEnabled:NO];
        });
    }
    
    else if ([receivedText isEqualToString:@"New Round"]) {
        dispatch_async(dispatch_get_main_queue(), ^ {
            [_questionTextField setText:@"Waiting for Question"];
            [_answerTextField setEnabled:NO];
            [_clearButton setEnabled:NO];
            [_submitButton setEnabled:NO];
        });
    }
    
    else if ([receivedText hasPrefix:@"Game Over:"]) {
        NSString *gameOverText = [receivedText substringFromIndex:10];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:gameOverText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [alert show];
        });
    }
}

#pragma mark - UIButton methods

- (void)clearButtonPressed:(id)sender {
    [_answerTextField setText:@""];
}

- (void)submitButtonPressed:(id)sender {
    [self submitAnswer:_answerTextField.text];
    
    [self clearButtonPressed:_clearButton];
}

- (void)submitAnswer:(NSString *)string {
    [self playSoundEffect];
    NSData *dataToSend = [string dataUsingEncoding:NSUTF8StringEncoding];
    //weird need to check this again.
    NSArray *allPeers = _appDelegate.manager.session.connectedPeers;
    //NSArray *allPeers = [[NSArray alloc] initWithObjects:teacherPeerID, nil];
    //NSLog(@"%@", teacherPeerID.displayName);
    NSError *error;
    
    [_appDelegate.manager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
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

- (void)playSoundEffect {
    NSString *path = [NSString stringWithFormat:@"%@/Whoosh.wav", [[NSBundle mainBundle] resourcePath]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer play];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self submitButtonPressed:_submitButton];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([[textField text] isEqualToString:@"Answer Here"])
        [textField setText:@""];
}


#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    BMStudentEndGameViewController *endGameViewController = [[BMStudentEndGameViewController alloc] initWithArray:questionArray];
    
    [self.navigationController pushViewController:endGameViewController animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Constraint methods

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_questionTextField, _questionLabel, _answerTextField, _clearButton, _submitButton, topThingy);
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy]-20-[_questionLabel]-5-[_questionTextField(>=50,<=200)]-[_answerTextField]-[_clearButton]-(>=50)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *verticalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy]-20-[_questionLabel]-5-[_questionTextField(>=50,<=200)]-[_answerTextField]-[_submitButton]-(>=50)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_questionTextField(>=50)]-20-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_answerTextField(>=100)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_clearButton(>=50)]-[_submitButton(==_clearButton)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    
    [self.view addConstraints:verticalConstraint1];
    [self.view addConstraints:verticalConstraint2];
    
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
    [self.view addConstraints:horizontalConstraint3];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}




@end
