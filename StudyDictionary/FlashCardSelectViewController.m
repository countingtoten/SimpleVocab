//
//  FlashCardSelectViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardSelectViewController.h"

#import "AllLists.h"
#import "EditableTableViewCell.h"
#import "List.h"
#import "StudyDictionaryAppDelegate.h"
#import "StudyDictionaryConstants.h"
#import "Word.h"

@interface FlashCardSelectViewController ()

@end

@implementation FlashCardSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Add All Words as an option to the word lists
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.lists.userOrderedLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ListCellIdentifier = kFlashCardSelectCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    
    List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
    cell.textLabel.text = list.listName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
    [self.delegate flashCardSelectViewController:self selectedList:list];
}

@end
