//
//  BMStudentViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMStudentViewController.h"

@implementation BMStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate manager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    
    //BMStudentPlayGameViewController *test = [[BMStudentPlayGameViewController alloc] init];
    //[self.navigationController pushViewController:test animated:YES];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:@"Start Searching" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(startBrowsing:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_searchButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [_searchButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _searchButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    _searchButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    _searchButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_searchButton];
    
    _disconnectBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStyleDone target:self action:@selector(disconnect:)];
    _disconnectBarButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = _disconnectBarButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studentDidChangeWithNotification:) name:@"MCStudentDidChangeStateNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(studentDidReceiveDataWithNotification:) name:@"MCStudentDidReceiveData" object:nil];
    
    self.navigationController.navigationBar.topItem.title = [[UIDevice currentDevice] name];
    
    [self setupConstraints];
    
}

/* - (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self disconnect:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCStudentDidChangeStateNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCStudentDidReceiveData" object:nil];
} */

- (void)dealloc {
    //because pull up window searching for devices will call viewDidDisappear
    
    //[self disconnect:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCStudentDidChangeStateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MCStudentDidReceiveData" object:nil];
}

- (void)startBrowsing:(id)sender {
    [[_appDelegate manager] setupMCBrowser];
    [[_appDelegate manager] browser].delegate = self;
    
    [self presentViewController:[[_appDelegate manager] browser] animated:YES completion:nil];
}

#pragma mark - MCBrowserViewControllerDelegate methods

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.manager.browser dismissViewControllerAnimated:YES completion:nil];
}


- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.manager.browser dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIButton helper methods

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

- (void)playSoundEffect {
    NSString *path = [NSString stringWithFormat:@"%@/Whoosh.wav", [[NSBundle mainBundle] resourcePath]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer play];
}


#pragma mark - UIBarButton helper methods

- (void)disconnect:(id)sender {
    [_disconnectBarButton setEnabled:NO];
    
    [_appDelegate.manager.session disconnect];
    
}


#pragma mark - NSNotificationCenter methods

- (void)studentDidChangeWithNotification:(NSNotification *)notification {
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    _teacherPeerID = peerID;
    if (state != MCSessionStateConnecting)
    {
        if (state == MCSessionStateConnected) {
            //BOOL connected = ([[_appDelegate.manager.session connectedPeers] count] > 0);
            [_disconnectBarButton setEnabled:YES];
            //[_searchButton setTitle:@"Waiting..." forState:UIControlStateNormal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_searchButton setTitle:@"Waiting..." forState:UIControlStateNormal];
                [_searchButton setTitleColor:[UIColor colorWithWhite:0.231 alpha:1.0] forState:UIControlStateNormal]; });
            [_searchButton setEnabled:NO];
            
        }
        else if (state == MCSessionStateNotConnected) {
            //NSAttributedString *attributedTitle = [_searchButton attributedTitleForState:UIControlStateNormal];
            //NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:attributedTitle];
            //[mas.mutableString setString:@"Start Searching"];
            //[_searchButton setTitle:@"Start Searching" forState:UIControlStateNormal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_searchButton setTitle:@"Start Searching" forState:UIControlStateNormal];
                [_searchButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
                [_disconnectBarButton setEnabled:NO];
            });
            //[_searchButton setAttributedTitle:mas forState:UIControlStateNormal];
            [_searchButton setEnabled:YES];

        }
    }
    
}

- (void)studentDidReceiveDataWithNotification:(NSNotification *)notifictation {
    NSArray *allPeers = _appDelegate.manager.session.connectedPeers;
    NSLog(@"%@", allPeers);
    MCPeerID *peerID = [[notifictation userInfo] objectForKey:@"peerID"];
    NSString *displayName = peerID.displayName;
    
    NSData *receivedData = [[notifictation userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([receivedText isEqualToString:@"Play Game"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playGame];
        });
    }
}

#pragma mark - Game methods

- (void)playGame {
    BMStudentPlayGameViewController *studentPlayGameViewController = [[BMStudentPlayGameViewController alloc] init];
    studentPlayGameViewController.teacherPeerID = _teacherPeerID;
    [self.navigationController pushViewController:studentPlayGameViewController animated:YES];
    
}



#pragma mark - Constraint Setup


- (void)setupConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_searchButton, topThingy);
    
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_searchButton(>=300)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint];
    [self.view addConstraints:horizontalConstraint];
}

@end
