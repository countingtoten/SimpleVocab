//
//  ListContentsViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 6/17/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListContentsViewController.h"

#import "List.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"
#import "WordDefinitionViewController.h"

@interface ListContentsViewController ()
- (void)loadWordsFromList;
@end

@implementation ListContentsViewController
@synthesize list, wordsInListSorted;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = list.listName;
    [self loadWordsFromList];
    didViewJustLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!didViewJustLoad) {
        [self loadWordsFromList];
    }
    
    didViewJustLoad = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kDefinitionToListContentsSegue]) {
        WordDefinitionViewController *wordDefViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        wordDefViewController.wordToDefine = [self.wordsInListSorted objectAtIndex:indexPath.row];
    }
}

- (void)loadWordsFromList {
    wordsInListSorted = [[NSMutableArray alloc] initWithArray:[self.list.listContents allObjects]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [wordsInListSorted sortUsingDescriptors:sortDescriptors];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.wordsInListSorted count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = kListContentsCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Word *word = [self.wordsInListSorted objectAtIndex:indexPath.row];
    cell.textLabel.text = word.word;
    cell.textLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
        
        Word *word = [self.wordsInListSorted objectAtIndex:indexPath.row];
        
        [moc deleteObject:word];
        [self.wordsInListSorted removeObject:word];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSError *error = nil;
        if (![moc save:&error]) {
//            CLS_LOG(kErrorCommitEditContents, error, [error userInfo]);
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kDefinitionToListContentsSegue sender:indexPath];
}

@end
