//
//  ListTemplateViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 6/18/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListTemplateViewController.h"

#import "AllLists.h"
#import "EditableTableViewCell.h"
#import "List.h"
#import "ListContentsViewController.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"

@interface ListTemplateViewController ()
- (void)loadAllLists;
@end

@implementation ListTemplateViewController
@synthesize lists, listOldName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadAllLists];
    didViewJustLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!didViewJustLoad) {
        [self loadAllLists];
    }
    
    didViewJustLoad = NO;
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
    self.lists = [[SimpleVocabData sharedInstance] getOrCreateAllLists];
	
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
        static NSString *ListCellIdentifier = kListCellIdentifier;
        EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
        
        List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
        cell.textField.text = list.listName;
        cell.textField.delegate = self;
        
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    if (row < [self.lists.userOrderedLists count]) {
        List *list = [self.lists.userOrderedLists objectAtIndex:row];
        if ([list.listName isEqualToString:kDefaultListText]) {
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
    NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        List *list = [self.lists.userOrderedLists objectAtIndex:indexPath.row];
        [self.lists removeUserOrderedListsObject:list];
        [moc deleteObject:list];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        List *list = [NSEntityDescription insertNewObjectForEntityForName:kListEntityName inManagedObjectContext:moc];
        
        list.listName = @"";
        [self.lists addUserOrderedListsObject:list];
        
        UITableViewRowAnimation animationStyle = UITableViewRowAnimationFade;
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animationStyle];
        EditableTableViewCell *cell = (EditableTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField becomeFirstResponder];
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

#pragma mark -
#pragma mark Editing text fields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.listOldName = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *listNewName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([listNewName length] == 0) {
        listNewName = kBlankListText;
    }
    
    if (![self.listOldName isEqualToString:listNewName]) {
        NSOrderedSet *tempOrderedSet = self.lists.userOrderedLists;
        
        NSUInteger idx = [tempOrderedSet indexOfObjectPassingTest:^BOOL(id listObject, NSUInteger idx, BOOL *stop) {
            List *list = (List *)listObject;
            return [list.listName isEqualToString:self.listOldName];
        }];
        
        if (idx != NSNotFound) {
            BOOL hasSameName;
            NSUInteger i = 1;
            List *currentList = [self.lists.userOrderedLists objectAtIndex:idx];
            
            NSString *tempListName = [[NSString alloc] initWithString:listNewName];
            do {
                hasSameName = NO;
                
                idx = [tempOrderedSet indexOfObjectPassingTest:^BOOL(id listObject, NSUInteger idx, BOOL *stop) {
                    List *list = (List *)listObject;
                    return [list.listName isEqualToString:listNewName];
                }];
                
                if (idx != NSNotFound) {
                    listNewName = [tempListName stringByAppendingString:[NSString stringWithFormat:@" %d", i]];
                    i++;
                    hasSameName = YES;
                }
            } while (hasSameName);
            
            currentList.listName = listNewName;
            textField.text = listNewName;
        } 
        // Error occurred do nothing
    }
    self.listOldName = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {	
	[textField resignFirstResponder];
	return YES;	
}


@end
