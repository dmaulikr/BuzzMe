//
//  BMTeacherPlayGameViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 2/20/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMTeacherPlayGameViewController.h"

@implementation BMTeacherPlayGameViewController

@synthesize arrConnectedDevices, playersPerTeam;

#pragma mark - View load/disappear

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!arrConnectedDevices)
        arrConnectedDevices = [[NSMutableArray alloc] init];
    
    _scoreConnectedDevices = [[NSMutableArray alloc] init];
    for (id device in arrConnectedDevices) {
        NSNumber *number = [NSNumber numberWithInt:0];
        [_scoreConnectedDevices addObject:number];
    }
    
    _tableViewController = [[UITableViewController alloc] init];
    _tableViewController.tableView.delegate = self;
    _tableViewController.tableView.dataSource = self;
    
    _scoresBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Scores" style:UIBarButtonItemStyleDone target:self action:@selector(showScores:)];
    _scoresBarButton.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = _scoresBarButton;
    
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    //[self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    /*
    _questionLabel = [[UILabel alloc] init];
    [_questionLabel setBackgroundColor:[UIColor clearColor]];
    [_questionLabel setText:@"Question"];
    [_questionLabel setTextColor:[UIColor whiteColor]];
    [_questionLabel setFont:[UIFont fontWithName:@"Existence-Light" size:25]];
    _questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_questionLabel];
     */
    
    //_questionTextField = [[UITextField alloc] init];
    _questionTextField = [[UITextView alloc] init];
    [_questionTextField setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    [_questionTextField setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    [_questionTextField setText:@"Question Here"];
    [_questionTextField setFont:[UIFont fontWithName:@"Existence-Light" size:25]];
    [_questionTextField setTextAlignment:NSTextAlignmentCenter];
    [_questionTextField setEditable:YES];
    //_questionTextField.enabled = YES;
    _questionTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _questionTextField.delegate = self;
    [self.view addSubview:_questionTextField];
    
    _answerTextField = [[UITextField alloc] init];
    [_answerTextField setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    [_answerTextField setTextColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
    [_answerTextField setText:@"Answer Here"];
    [_answerTextField setFont:[UIFont fontWithName:@"Existence-Light" size:25]];
    [_answerTextField setTextAlignment:NSTextAlignmentCenter];
    _answerTextField.enabled = YES;
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
    _clearButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
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
    _submitButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
    _submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    _submitButton.enabled = NO;
    [self.view addSubview:_submitButton];
    
    _roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_roundButton setTitle:@"New Round" forState:UIControlStateNormal];
    [_roundButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_roundButton addTarget:self action:@selector(roundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_roundButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_roundButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _roundButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _roundButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
    _roundButton.translatesAutoresizingMaskIntoConstraints = NO;
    _roundButton.enabled = YES;
    [self.view addSubview:_roundButton];
    
    _gameOverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gameOverButton setTitle:@"End Game" forState:UIControlStateNormal];
    [_gameOverButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_gameOverButton addTarget:self action:@selector(gameOverButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_gameOverButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_gameOverButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _gameOverButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _gameOverButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
    _gameOverButton.translatesAutoresizingMaskIntoConstraints = NO;
    _gameOverButton.enabled = YES;
    [self.view addSubview:_gameOverButton];
    
    _loadQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loadQuestionButton setTitle:@"Load Question" forState:UIControlStateNormal];
    [_loadQuestionButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_loadQuestionButton addTarget:self action:@selector(loadQuestionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_loadQuestionButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_loadQuestionButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _loadQuestionButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _loadQuestionButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
    _loadQuestionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _loadQuestionButton.enabled = YES;
    [self.view addSubview:_loadQuestionButton];
    
    _logTextView = [[UITextView alloc] init];
    [_logTextView setBackgroundColor:[UIColor clearColor]];
    [_logTextView setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    [_logTextView setText:@""];
    [_logTextView setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_logTextView setTextAlignment:NSTextAlignmentLeft];
    _logTextView.editable = NO;
    _logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_logTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherDidReceiveDataWithNotification:) name:@"MCTeacherDidReceiveData" object:nil];
    
    [self updateConstraints];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCTeacherDidReceiveData" object:nil];
}

#pragma mark - NSNotificationCenter methods

- (void)teacherDidReceiveDataWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *displayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSString *updateText = [NSString stringWithFormat:@"%@: %@\n%@", displayName, receivedText, _logTextView.text];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logTextView setText:updateText];
    });
    
    //if ([receivedText isEqualToString:_answerTextField.text]) {
    if ([receivedText caseInsensitiveCompare:_answerTextField.text] == NSOrderedSame) {
        if ([self.arrConnectedDevices containsObject:displayName]) {
            NSUInteger index = [self.arrConnectedDevices indexOfObject:displayName];
            NSNumber *origScore = [_scoreConnectedDevices objectAtIndex:index];
            int value = [origScore intValue];
            value++;
            [_scoreConnectedDevices replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
        }
        NSString *stringToSend = [NSString stringWithFormat:@"Round Over:%@: %@", displayName, receivedText];
        updateText = [NSString stringWithFormat:@"%@: %@ - Correct!\n%@", displayName, receivedText,  _logTextView.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ is correct!", displayName] maskType:SVProgressHUDMaskTypeNone];
            [_logTextView setText:updateText];
            [self submitAnswer:stringToSend];
        });
    }
    
    
}

#pragma mark - UITableView Delegate/Data Source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"ppt: %lu", (unsigned long)playersPerTeam);
    if (playersPerTeam < 1)
        return 1;
    else {
        if ([arrConnectedDevices count] % playersPerTeam == 0) return [arrConnectedDevices count]/playersPerTeam;
        else return ([arrConnectedDevices count] / playersPerTeam)+1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (playersPerTeam < 1)
        return [arrConnectedDevices count];
    else
        return playersPerTeam;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    NSLog(@"%ld %ld", (long)indexPath.section, (long)indexPath.row);
    
    NSUInteger index = (playersPerTeam*indexPath.section)+indexPath.row;
    
    if (index >= [arrConnectedDevices count])
        return cell;
    
    NSNumber *numberForCell = [NSNumber numberWithInt:0];
    
    cell.textLabel.text = [arrConnectedDevices objectAtIndex:index];
    numberForCell = [_scoreConnectedDevices objectAtIndex:index];
    
    NSInteger scoreForCell = [numberForCell integerValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Score - %ld", (long)scoreForCell];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"section: %ld", (long)section);
    NSInteger playersLoop = self.playersPerTeam * section;
    NSInteger totalScoreForSection = 0;
    
    for (NSInteger i = playersLoop; i < (playersLoop+playersPerTeam); i++) {
        if (i > [_scoreConnectedDevices count]) break;
        NSNumber *origScore = [_scoreConnectedDevices objectAtIndex:i];
        int value = [origScore intValue];
        totalScoreForSection += value;
    }
    
    return [NSString stringWithFormat:@"Team %ld - Score: %ld", (long)section+1, (long)totalScoreForSection];
}

#pragma mark - UIButton methods

- (void)clearButtonPressed:(id)sender {
    [_questionTextField setText:@"Question Here"];
    [_answerTextField setText:@"Answer Here"];
}

- (void)submitButtonPressed:(id)sender {
    NSString *message = [[NSString stringWithFormat:@"Question:"] stringByAppendingString:_questionTextField.text];
    [self submitAnswer:message];
    
    [_logTextView setText:[NSString stringWithFormat:@"You: %@", _questionTextField.text]];
    
    //[_questionTextField setText:@"Question Here"];
    
    [_questionTextField setEditable:NO];
    //_questionTextField.enabled = NO;
    _answerTextField.enabled = NO;
    _clearButton.enabled = NO;
    _submitButton.enabled = NO;
    _loadQuestionButton.enabled = NO;
}

- (void)roundButtonPressed:(id)sender {
    [_questionTextField setEditable:YES];
    //_questionTextField.enabled = YES;
    [_questionTextField setText:@"Question Here"];
    _answerTextField.enabled = YES;
    [_answerTextField setText:@"Answer Here"];
    _clearButton.enabled = YES;
    _submitButton.enabled = YES;
    _loadQuestionButton.enabled = YES;
    [_logTextView setText:@""];
    
    [self submitAnswer:@"New Round"];
}

- (void)gameOverButtonPressed:(id)sender {
    //need to update if there is a tie (maybe)
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    int highScore = 0;
    int tempScore = 0;
    int counter=0;
    
    for (NSUInteger i = 0; i < [_scoreConnectedDevices count]; i++) {
        counter++;
        
        tempScore += [(NSNumber *)[_scoreConnectedDevices objectAtIndex:i] intValue];
        
        if (counter >= playersPerTeam) {
            if (tempScore > highScore) {
                highScore = tempScore;
                winners = [[NSMutableArray alloc] init];
                [winners addObject:[NSNumber numberWithUnsignedInteger:i]];
            }
            else if (tempScore == highScore) {
                [winners addObject:[NSNumber numberWithUnsignedInteger:i]];
            }
            
            counter = 0;
            tempScore = 0;
        }
        
    }
    
    NSString *stringToSubmit = [[NSString alloc] init];
    
    if ([winners count] > 1) {
        stringToSubmit = [NSString stringWithFormat:@"Game Over: Team"];
        for (NSUInteger i = 0; i < [winners count]; i++) {
            stringToSubmit = [stringToSubmit stringByAppendingString:[NSString stringWithFormat:@" %lu", (unsigned long)[(NSNumber *)[winners objectAtIndex:i] unsignedIntegerValue]+1]];
        }
        
        stringToSubmit = [stringToSubmit stringByAppendingString:[NSString stringWithFormat:@" won with %d points", highScore]];
    }
    else {
        stringToSubmit = [NSString stringWithFormat:@"Game Over: Team %lu won with %d points!", (unsigned long)[(NSNumber *)[winners objectAtIndex:0] unsignedIntegerValue]+1, highScore];
        [self submitAnswer:stringToSubmit];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:[stringToSubmit substringFromIndex:11] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

- (void)loadQuestionButtonPressed:(id)sender {
    BMLoadViewQuestionViewController *loadQuestionViewController = [[BMLoadViewQuestionViewController alloc] init];
    loadQuestionViewController.delegate = self;
    [self.navigationController pushViewController:loadQuestionViewController animated:YES];
}

- (void)submitAnswer:(NSString *)string {
    //NSString *message = [[NSString stringWithFormat:@"Question:"] stringByAppendingString:string];
    [self playSoundEffect];
    NSData *dataToSend = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.teacher.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.teacher.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void)normalButtonPressed:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:24];
    
}

- (void)normalButtonHighlighted:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.037 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:29];
}

- (void)playSoundEffect {
    NSString *path = [NSString stringWithFormat:@"%@/Whoosh.wav", [[NSBundle mainBundle] resourcePath]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer play];
}

#pragma mark - UIBarButton methods

- (void)showScores:(id)sender {
    [_tableViewController.tableView reloadData];
    [self.navigationController pushViewController:_tableViewController animated:YES];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (![_answerTextField.text isEqualToString:@"Answer Here"] && ![_answerTextField.text isEqualToString:@""] && ![_questionTextField.text isEqualToString:@"Question Here"] && ![_questionTextField.text isEqualToString:@""]) {
        [self submitButtonPressed:_submitButton];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _clearButton.enabled = YES;
    _submitButton.enabled = YES;
    if ([[textField text] isEqualToString:@"Question Here"] || [[textField text] isEqualToString:@"Answer Here"])
        [textField setText:@""];
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([[textView text] isEqualToString:@"Question Here"]) {
        [textView setText:@""];
    }
}


#pragma mark - BMLoadViewQuestionViewControllerDelegate method

- (void)didSelectQuestion:(NSString *)question withAnswer:(NSString *)answer {
    _questionTextField.text = question;
    _answerTextField.text = answer;
    
    _clearButton.enabled = YES;
    _submitButton.enabled = YES;
}


#pragma mark - UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Constraint methods

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_questionTextField, _answerTextField, _clearButton, _submitButton, _logTextView, _gameOverButton, _roundButton, _loadQuestionButton, topThingy);
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy]-[_questionTextField(>=70,<=100)]-5-[_answerTextField]-5-[_clearButton]-5-[_gameOverButton]-5-[_loadQuestionButton]-15-[_logTextView(>=100)]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *verticalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy]-[_questionTextField(>=70,<=100)]-5-[_answerTextField]-5-[_submitButton]-5-[_roundButton]-5-[_loadQuestionButton]-15-[_logTextView(>=100)]-15-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_questionTextField(>=100)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_clearButton(>=50)][_submitButton(==_clearButton)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];

    NSArray *horizontalConstraint3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logTextView(>=100)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_answerTextField(>=100)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint5 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_gameOverButton(>=50)][_roundButton(==_gameOverButton)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint6 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_loadQuestionButton(>=100)]-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    
    [self.view addConstraints:verticalConstraint1];
    [self.view addConstraints:verticalConstraint2];
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
    [self.view addConstraints:horizontalConstraint3];
    [self.view addConstraints:horizontalConstraint4];
    [self.view addConstraints:horizontalConstraint5];
    [self.view addConstraints:horizontalConstraint6];
    
    //[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

@end
