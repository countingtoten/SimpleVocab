//
//  ListViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListViewController.h"

#import "List.h"
#import "StudyDictionaryAppDelegate.h"
#import "StudyDictionaryConstants.h"
#import "StudyDictionaryHelpers.h"

@interface ListViewController ()
- (void)loadAllLists;
@end

@implementation ListViewController
@synthesize lists;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadAllLists];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadAllLists {
    self.lists = [StudyDictionaryHelpers getOrCreateAllLists];    
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [self.lists.userOrderedLists count];
    if(self.editing) {
        count++;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.lists.userOrderedLists count]) {
        static NSString *ListCellIdentifier = @"ListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
        
        List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
        cell.textLabel.text = list.listName;
  //      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    static NSString *AddCellIdentifier = @"AddListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier];
        cell.textLabel.text = @"Add New List";
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
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
        StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *moc = [appDelegate managedObjectContext];
        
        NSError *error = nil;
        if (![moc save:&error]) {
            NSLog(@"Error");
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    if (row < [self.lists.userOrderedLists count]) {
        List *list = [self.lists.userOrderedLists objectAtIndex:row];
        if ([list.listName isEqualToString:kListDefaultName]) {
            return NO;
        }
    }
    
    return self.editing;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [self.lists.userOrderedLists count]) {
		return UITableViewCellEditingStyleInsert;
	}
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
        [self.lists removeUserOrderedListsObject:list];
        [moc deleteObject:list];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        List *list = [NSEntityDescription insertNewObjectForEntityForName:kListEntityName inManagedObjectContext:moc];
        
        list.listName = @"New String";
        [self.lists addUserOrderedListsObject:list];
        
        UITableViewRowAnimation animationStyle = UITableViewRowAnimationFade;
    
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.lists.userOrderedLists count] - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animationStyle];
    }
    
    NSError *error = nil;
    if (![moc save:&error]) {
        NSLog(@"Error");
    }
}

#pragma mark - Moving Rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.lists.userOrderedLists count]) 
        return NO;
    
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSIndexPath *destination = proposedDestinationIndexPath;
    NSUInteger section = proposedDestinationIndexPath.section;
    
    NSUInteger lastIndex = [self.lists.userOrderedLists count] - 1;
    NSUInteger firstEditableIndex = 1; // Assume Default List cannot be moved
    
    if (proposedDestinationIndexPath.row > lastIndex) {
        destination = [NSIndexPath indexPathForRow:lastIndex inSection:section];
    } else if (proposedDestinationIndexPath.row < firstEditableIndex) {
        destination = [NSIndexPath indexPathForRow:firstEditableIndex inSection:section];
    }
    
    return destination;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    List *listToMove = [self.lists.userOrderedLists objectAtIndex:fromIndexPath.row];
    [lists removeUserOrderedListsObject:listToMove];
    [lists insertObject:listToMove inUserOrderedListsAtIndex:toIndexPath.row];
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [self.lists.userOrderedLists count]) {
		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
