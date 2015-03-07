//
//  BMMakeQuestionsViewController.m
//  BuzzMe
//
//  Created by Tim Wong on 2/16/15.
//  Copyright (c) 2015 Tim Wong. All rights reserved.
//

#import "BMMakeQuestionsViewController.h"

@implementation BMMakeQuestionsViewController

#define QUESTION_KEY @"kQuestionKey"
#define ANSWER_KEY @"kAnswerKey"

@synthesize filePath;

#pragma mark - View load/disappear methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0751 alpha:1.0]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingString:@"questions.dat"];
        
        _questionsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    if (!_questionsArray) {
        _questionsArray = [[NSMutableArray alloc] init];
    }
    
    
    _questionsTableView = [[UITableView alloc] init];
    _questionsTableView.backgroundColor = [UIColor clearColor];
    _questionsTableView.allowsMultipleSelectionDuringEditing = NO;
    _questionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _questionsTableView.delegate = self;
    _questionsTableView.dataSource = self;
    [self.view addSubview:_questionsTableView];
    
    _addQuestionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuestion:)];
    _addQuestionBarButton.enabled = YES;
    
    self.navigationItem.rightBarButtonItem = _addQuestionBarButton;
    
    [self updateConstraints];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_questionsArray writeToFile:filePath atomically:YES];
}


#pragma mark - BMAddQuestionViewControllerDelegate method

- (void)addQuestionAndAnswerWithDict:(NSDictionary *)dict {
    [_questionsArray addObject:dict];
    
    [_questionsTableView reloadData];
}

- (void)replaceQuestionAndAnswerWithDict:(NSDictionary *)dict withIndex:(NSUInteger)index {
    [_questionsArray replaceObjectAtIndex:index withObject:dict];
    
    [_questionsTableView reloadData];
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
    BMAddQuestionViewController *addQuestionViewController = [[BMAddQuestionViewController alloc] init];
    addQuestionViewController.delegate = self;
    addQuestionViewController.dictPlace = indexPath.row;
    addQuestionViewController.addQuestionViewText = [[_questionsArray objectAtIndex:indexPath.row] objectForKey:QUESTION_KEY];
    addQuestionViewController.addAnswerViewText = [[_questionsArray objectAtIndex:indexPath.row] objectForKey:ANSWER_KEY];
    addQuestionViewController.addQuestionAndAnswerButtonText = @"Replace";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController pushViewController:addQuestionViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_questionsArray removeObjectAtIndex:indexPath.row];
        
        [_questionsTableView reloadData];
    }
}

#pragma mark - UIBarButtonItem methods

- (void)addQuestion:(id)sender {
    BMAddQuestionViewController *addQuestionViewController = [[BMAddQuestionViewController alloc] init];
    addQuestionViewController.delegate = self;
    [self.navigationController pushViewController:addQuestionViewController animated:YES];
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
