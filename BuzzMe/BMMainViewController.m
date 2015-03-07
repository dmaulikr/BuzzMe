//
//  BMMainViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 1/29/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMMainViewController.h"

@implementation BMMainViewController

@synthesize studentButton, teacherButton, arrConnectedDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    studentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [studentButton setTitle:@"Student" forState:UIControlStateNormal];
    [studentButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [studentButton addTarget:self action:@selector(studentButtonPresed:) forControlEvents:UIControlEventTouchUpInside];
    [studentButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [studentButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    studentButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    studentButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    studentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:studentButton];
    
    teacherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [teacherButton setTitle:@"Teacher" forState:UIControlStateNormal];
    [teacherButton setTitleColor:[UIColor colorWithWhite:0.881 alpha:1.0] forState:UIControlStateNormal];
    [teacherButton addTarget:self action:@selector(teacherButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [teacherButton addTarget:self action:@selector(normalButtonPressed:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [teacherButton addTarget:self action:@selector(normalButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    teacherButton.backgroundColor = [UIColor colorWithWhite:0.0751 alpha:1.0];
    teacherButton.titleLabel.font = [UIFont fontWithName:@"Existence-Light" size:50];
    teacherButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:teacherButton];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(studentButton, teacherButton, topThingy);
    
    NSArray *verticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][studentButton(>=150)][teacherButton(==studentButton)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[studentButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[teacherButton]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint];
    [self.view addConstraints:horizontalConstraint1];
    [self.view addConstraints:horizontalConstraint2];
}
/*
#pragma mark - BMTeacherViewControllerDelegate method

- (void)didFinishWithArray:(NSMutableArray *)array {
    self.arrConnectedDevices = array;
} 
*/

#pragma mark - Button Methods

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

- (void)studentButtonPresed:(id)sender {
    BMStudentViewController *studentViewController = [[BMStudentViewController alloc] init];
    [self.navigationController pushViewController:studentViewController animated:YES];
    
}

- (void)teacherButtonPressed:(id)sender {
    BMTeacherViewController *teacherViewController = [[BMTeacherViewController alloc] init];
    //teacherViewController.delegate = self;
    //if (!arrConnectedDevices)
    //    arrConnectedDevices = [[NSMutableArray alloc] init];
    //teacherViewController.arrConnectedDevices = arrConnectedDevices;
    [self.navigationController pushViewController:teacherViewController animated:YES];
}

- (void)playSoundEffect {
    NSString *path = [NSString stringWithFormat:@"%@/Whoosh.wav", [[NSBundle mainBundle] resourcePath]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    [self.audioPlayer play];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
