//
//  BMTeacherViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMTeacherViewController.h"

@implementation BMTeacherViewController

@synthesize playersPerTeam, arrConnectedDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    
    //[self playGame:nil];
    
    playersPerTeam = 1;
    
    //_arrConnectedDevices = [[NSMutableArray alloc] init];
    _tblConnectedDevices = [[UITableViewController alloc] init];
    [_tblConnectedDevices.tableView setDelegate:self];
    [_tblConnectedDevices.tableView setDataSource:self];
    
    arrConnectedDevices = [[NSMutableArray alloc] init];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate teacher] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate teacher] advertiseSelf:YES];
    
    _teamsBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Teams" style:UIBarButtonItemStyleDone target:self action:@selector(showTeams:)];
    _teamsBarButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = _teamsBarButton;
    
    _makeQuestionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_makeQuestionsButton setTitle:@"Questions" forState:UIControlStateNormal];
    [_makeQuestionsButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_makeQuestionsButton addTarget:self action:@selector(makeQuestionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_makeQuestionsButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_makeQuestionsButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _makeQuestionsButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _makeQuestionsButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    _makeQuestionsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_makeQuestionsButton];
    
    _playGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playGameButton setTitle:@"Play Game" forState:UIControlStateNormal];
    [_playGameButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_playGameButton addTarget:self action:@selector(playGame:) forControlEvents:UIControlEventTouchUpInside];
    [_playGameButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_playGameButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    _playGameButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _playGameButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    _playGameButton.translatesAutoresizingMaskIntoConstraints = NO;
    _playGameButton.enabled = NO;
    [self.view addSubview:_playGameButton];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTappedAndWillDisappear)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    _navTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [_navTextField setText:@"Players Per Team: 1"];
    [_navTextField setFont:[UIFont fontWithName:@"Existence-Light" size:20]];
    [_navTextField setTextAlignment:NSTextAlignmentCenter];
    _navTextField.keyboardType = UIKeyboardTypeNumberPad;
    _navTextField.delegate = self;
    self.navigationItem.titleView = _navTextField;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teacherDidChangeWithNotification:) name:@"MCTeacherDidChangeStateNotification" object:nil];
    
    [self updateConstraints];
}
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //[self.delegate didFinishWithArray:arrConnectedDevices];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCTeacherDidChangeStateNotification" object:nil];
    
    //[_appDelegate.teacher advertiseSelf:NO];
}
*/

- (void)dealloc {
    //[self.delegate didFinishWithArray:arrConnectedDevices];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCTeacherDidChangeStateNotification" object:nil];
    
    [_appDelegate.teacher advertiseSelf:NO];
}

- (void)sendMessage:(NSString *)message {
    NSData *dataToSend = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.teacher.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.teacher.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}



#pragma mark - NSNotificationCenter methods

- (void)teacherDidChangeWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [arrConnectedDevices addObject:peerDisplayName];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [_teamsBarButton setEnabled:YES];
            });
        }
        else if (state == MCSessionStateNotConnected) {
            if ([arrConnectedDevices count] > 0) {
                NSUInteger indexOfPair = [arrConnectedDevices indexOfObject:peerDisplayName];
                [arrConnectedDevices removeObjectAtIndex:indexOfPair];
            }
        }
        
    }
    
    if ([_appDelegate.teacher.session.connectedPeers count] > 0)
        _playGameButton.enabled = YES;
    else
        _playGameButton.enabled = NO;
}


#pragma mark - UITableView Delegate/Data Source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    NSUInteger index = (playersPerTeam*indexPath.section)+indexPath.row;
    
    if (index >= [arrConnectedDevices count])
        return cell;
    
    cell.textLabel.text = [arrConnectedDevices objectAtIndex:index];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Team %ld", (long)section+1];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setText:@""];
    _makeQuestionsButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"navTextField stopped editting");
    playersPerTeam = [textField.text intValue];
    NSLog(@"%ld", (unsigned long)playersPerTeam);
    _makeQuestionsButton.enabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [textField setText:@""];
    return YES;
}

#pragma mark - UITapGestureRecognizer method

- (void)viewWasTappedAndWillDisappear {
    if ([_navTextField isFirstResponder]) {
        NSLog(@"here gesture tapped - resigned");
        [_navTextField resignFirstResponder];
    }
}

#pragma mark - UIButton methods

- (void)normalButtonPressed:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    
}

- (void)normalButtonHighlighted:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;
    pressedButton.backgroundColor = [UIColor colorWithWhite:0.037 alpha:1.0];
    pressedButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:55];
    
}

- (void)makeQuestionsButtonPressed:(id)sender {
    BMMakeQuestionsViewController *makeQuestionsViewController = [[BMMakeQuestionsViewController alloc] init];
    [self.navigationController pushViewController:makeQuestionsViewController animated:YES];
}


- (void)playGame:(id)sender {
    NSLog(@"ppt: %lu", (unsigned long)playersPerTeam);
    [self sendMessage:@"Play Game"];
    BMTeacherPlayGameViewController *teacherPlayGameViewController = [[BMTeacherPlayGameViewController alloc] init];
    teacherPlayGameViewController.arrConnectedDevices = self.arrConnectedDevices;
    teacherPlayGameViewController.playersPerTeam = self.playersPerTeam;
    //teacherPlayGameViewController.playersPerTeam = [arrConnectedDevices count];
    [self.navigationController pushViewController:teacherPlayGameViewController animated:YES];
}

- (void)playSoundEffect {
    NSString *path = [NSString stringWithFormat:@"%@/Whoosh.wav", [[NSBundle mainBundle] resourcePath]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer play];
}


#pragma mark - UIBarButton methods

- (void)showTeams:(id)sender {
    if ([arrConnectedDevices count] < playersPerTeam) {
        playersPerTeam = [arrConnectedDevices count];
        [_navTextField setText:[NSString stringWithFormat:@"%ld", (unsigned long)playersPerTeam]];
    }
    [_tblConnectedDevices.tableView reloadData];
    [self.navigationController pushViewController:_tblConnectedDevices animated:YES];
    
}

#pragma mark - Constraint method

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_makeQuestionsButton, _playGameButton, topThingy);
    
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_makeQuestionsButton(>=150)][_playGameButton(==_makeQuestionsButton)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_makeQuestionsButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_playGameButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint];
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
}


#pragma mark - getter methods

- (NSMutableArray *)arrConnectedDevices {
    if (!arrConnectedDevices)
        arrConnectedDevices = [[NSMutableArray alloc] init];
    return arrConnectedDevices;
}

@end
