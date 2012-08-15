//
//  DictionarySearchViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "DictionarySearchViewController.h"

#import "AllLists.h"
#import "List.h"
#import "SearchBarContents.h"
#import "StudyDictionaryAppDelegate.h"
#import "StudyDictionaryConstants.h"
#import "StudyDictionaryHelpers.h"
#import "SVProgressHUD.h"
#import "Word.h"
#import "WordDefinitionViewController.h"
#import "WordNetDictionary.h"

@interface DictionarySearchViewController ()
- (void)applicationWillResignActive:(NSNotification *)notification;
- (void)loadSearchBarState;
- (void)saveSearchBarState;
- (void)searchForWordFromString:(NSString *)searchString;
- (Word *)updateWordLookupCount:(NSString *)wordToLookup;
@end

@implementation DictionarySearchViewController
@synthesize searchResults, dictionary, finalSearchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dictionary = [WordNetDictionary sharedInstance];
    queue = dispatch_queue_create("com.weinertworks.queue", NULL);

    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResignActive:)
												 name:UIApplicationWillResignActiveNotification
											   object:app];
    
    [self loadSearchBarState];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self saveSearchBarState];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"WordDefinitionFromSearchSegue"]) {
        WordDefinitionViewController *wordDefViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Word *word = [self updateWordLookupCount:[searchResults objectAtIndex:indexPath.row]];
        wordDefViewController.wordToDefine = word;
    }
}

#pragma mark - Core Data Records
- (void)loadSearchBarState {
    StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kSearchBarEntityName inManagedObjectContext:moc];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if (array != nil) {
        if ([array count] > 0) {
            SearchBarContents *searchBar = [array objectAtIndex:0];
            
            if (searchBar.savedSearchString && ![searchBar.savedSearchString isEqualToString:@""]) {
                [self.searchDisplayController setActive:[searchBar.searchWasActive boolValue]];
                [self.searchDisplayController.searchBar setText:searchBar.savedSearchString];
                
                [self searchForWordFromString:searchBar.savedSearchString];
            }
        }
    } else {
        NSLog(@"Error: Unable to load saved search bar");
    }
}

- (void)saveSearchBarState {
    StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kSearchBarEntityName inManagedObjectContext:moc];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if (array != nil) {
        SearchBarContents *searchBar = nil;
        if ([array count] > 0) {
            searchBar = [array objectAtIndex:0];
        } else {
            searchBar = [NSEntityDescription insertNewObjectForEntityForName:kSearchBarEntityName inManagedObjectContext:moc];
        }
        
        searchBar.savedSearchString = self.searchDisplayController.searchBar.text;
        searchBar.searchWasActive = [NSNumber numberWithBool:[[self searchDisplayController] isActive]];
        
        [moc save:&error];
    } else {
        NSLog(@"Error: Unable to load saved search bar");
    }
}

- (Word *)updateWordLookupCount:(NSString *)wordToLookup {
    StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kWordEntityName inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(word = %@)", wordToLookup];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *wordObjects = [moc executeFetchRequest:request error:&error];
    
    Word *word = nil;
    if (wordObjects != nil) {
        if ([wordObjects count] > 0) {
            word = [wordObjects objectAtIndex:0];
        } else {
            word = [NSEntityDescription insertNewObjectForEntityForName:kWordEntityName inManagedObjectContext:moc];
            word.word = wordToLookup;
            
            // Since we are creating a Word entity entry in the database add it to the default list
            List *defaultList = [StudyDictionaryHelpers getOrCreateDefaultList];
            [word addBelongsToListObject:defaultList];
        }
        
        NSUInteger count = [word.lookupCount unsignedIntegerValue];
        count++;
        word.lookupCount = [NSNumber numberWithUnsignedInteger:count];
        
        [moc save:&error];
    } else {
        NSLog(@"Error: Unable to update word history");
    }
    
    return word;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchResultsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"WordDefinitionFromSearchSegue" sender:indexPath];
}

#pragma mark Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForWordFromString:searchText];
}

- (void)searchForWordFromString:(NSString *)searchString {
    NSString *searchStringTrimmed = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.finalSearchText = searchStringTrimmed;
    dispatch_async(queue, ^{
        if ([searchStringTrimmed isEqualToString:self.finalSearchText]) {
            if (searchStringTrimmed != nil && [searchStringTrimmed length] > 0) {
                self.searchResults = [dictionary searchForWord:searchStringTrimmed];
            } else {
                // If the text field changed to an empty string, the user cleared the search bar
                self.searchResults = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }
    });
}

// Apparently the cancel button does not trigger textDidChange when pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchResults = nil;
}

@end
