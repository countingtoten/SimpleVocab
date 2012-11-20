//
//  FlashCardSelectViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardSelectViewController.h"

#import "AllLists.h"
#import "EditableTableViewCell.h"
#import "List.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"

@interface FlashCardSelectViewController ()
- (void)cancelFlashCardSelect;
@end

@implementation FlashCardSelectViewController
@synthesize listsWithWords;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(cancelFlashCardSelect)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.listsWithWords = [NSMutableArray array];
    
    [self loadAllLists];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadAllLists {
    AllLists *lists = [[SimpleVocabData sharedInstance] getOrCreateAllLists];
    
    // Filter results
    for (List *list in lists.userOrderedLists) {
        if ([list.listContents count] > 0) {
            [self.listsWithWords addObject:list.listName];
        }
    }
    
    // Possibly Include Custom Lists Here
    
	[self.tableView reloadData];
}

- (void)cancelFlashCardSelect {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Add All Words as an option to the word lists
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listsWithWords count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ListCellIdentifier = kFlashCardSelectCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    
    cell.textLabel.text = [self.listsWithWords objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *listName = [self.listsWithWords objectAtIndex:indexPath.row];
    [self.delegate flashCardSelectViewController:self selectedListName:listName];
}

@end
