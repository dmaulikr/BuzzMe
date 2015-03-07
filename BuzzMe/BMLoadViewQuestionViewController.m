//
//  BMLoadViewQuestionViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 2/22/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMLoadViewQuestionViewController.h"

@implementation BMLoadViewQuestionViewController

#define QUESTION_KEY @"kQuestionKey"
#define ANSWER_KEY @"kAnswerKey"

#pragma mark - View load/disappear methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    
    NSString *filePath;
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingString:@"questions.dat"];
        
        _questionsArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    
    if (!_questionsArray) {
        _questionsArray = [[NSArray alloc] init];
    }
    
    _questionsTableView = [[UITableView alloc] init];
    _questionsTableView.backgroundColor = [UIColor clearColor];
    _questionsTableView.allowsMultipleSelectionDuringEditing = NO;
    _questionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _questionsTableView.delegate = self;
    _questionsTableView.dataSource = self;
    [self.view addSubview:_questionsTableView];
    
    [self updateConstraints];
}

#pragma mark - UITableViewDelegate/DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_questionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    NSDictionary *dict = [_questionsArray objectAtIndex:indexPath.row];
    NSString *questionTitle = [dict objectForKey:QUESTION_KEY];
    NSString *answerSubTitle = [dict objectForKey:ANSWER_KEY];
    
    cell.textLabel.text = questionTitle;
    cell.detailTextLabel.text = answerSubTitle;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel setTextColor:[UIColor colorWithWhite:0.512 alpha:1.0]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithWhite:0.712 alpha:1.0]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Questions";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *questionString = [[_questionsArray objectAtIndex:indexPath.row] objectForKey:QUESTION_KEY];
    NSString *answerString = [[_questionsArray objectAtIndex:indexPath.row] objectForKey:ANSWER_KEY];
    
    [self.delegate didSelectQuestion:questionString withAnswer:answerString];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Constraints method

- (void)updateConstraints {
    id topThingy = self.topLayoutGuide;
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_questionsTableView, topThingy);
    
    NSArray *verticalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topThingy][_questionsTableView(>=200)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    NSArray *horizontalConstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_questionsTableView(>=100)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:dict];
    
    [self.view addConstraints:verticalConstraint1];
    [self.view addConstraints:horizontalConstraint1];
}

@end
