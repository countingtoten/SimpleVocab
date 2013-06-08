//
//  ListViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListViewController.h"

#import <Crashlytics/Crashlytics.h>

#import "AllLists.h"
#import "ListContentsViewController.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kListToListContentsSegue]) {
        ListContentsViewController *listContViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        listContViewController.list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
    }
}

#pragma mark -
#pragma mark Editing Table Rows

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    
    [self.tableView beginUpdates];
    NSUInteger listsCount = [self.lists.userOrderedLists count];
    
    NSArray *listsIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:listsCount inSection:0]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:listsIndexPath withRowAnimation:UITableViewRowAnimationFade];
	} else {
        [self.tableView deleteRowsAtIndexPaths:listsIndexPath withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
    
    if (!self.editing) {
        NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
        
        NSError *error = nil;
        if (![moc save:&error]) {
            CLS_LOG(kErrorCommitEditView, error, [error userInfo]);
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kListToListContentsSegue sender:indexPath];
}

@end

