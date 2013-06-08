//
//  ListModalViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 6/18/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListModalViewController.h"

#import <Crashlytics/Crashlytics.h>

#import "AllLists.h"
#import "EditableTableViewCell.h"
#import "List.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"

@interface ListModalViewController ()

@end

@implementation ListModalViewController
@synthesize word;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.lists.userOrderedLists count]) {
        static NSString *ListCellIdentifier = kListCellIdentifier;
        EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
        
        List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
        cell.textField.text = list.listName;
        cell.textField.delegate = self;
        
        if ([self.word.belongsToList containsObject:list]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
    static NSString *AddCellIdentifier = kAddListCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
    
    cell.textLabel.text = kAddListText;
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
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
            CLS_LOG(kErrorCommitEditModal, error, [error userInfo]);
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
    EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.word.belongsToList containsObject:list]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.word removeBelongsToListObject:list];
        [list removeListContentsObject:self.word];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.word addBelongsToListObject:list];
    }
    
    NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        CLS_LOG(kErrorCommitAdd, error, [error userInfo]);
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
