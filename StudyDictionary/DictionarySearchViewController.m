//
//  DictionarySearchViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "DictionarySearchViewController.h"

#import "AllLists.h"
#import "List.h"
#import "SearchBarContents.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"
#import "WordDefinitionViewController.h"
#import "WordNetDictionary.h"

@interface DictionarySearchViewController ()
- (void)searchForWordFromString:(NSString *)searchString;
- (Word *)updateWordLookupCount:(NSString *)wordToLookup;
@end

@implementation DictionarySearchViewController
@synthesize searchResults, dictionary, finalSearchText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kSearchTitleText;
    
    self.dictionary = [WordNetDictionary sharedInstance];
    queue = dispatch_queue_create(kDefaultQueueIdentifier, NULL);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSearchToDefinitionSegue]) {
        WordDefinitionViewController *wordDefViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        Word *word = [self updateWordLookupCount:[searchResults objectAtIndex:indexPath.row]];
        wordDefViewController.wordToDefine = word;
    }
}

#pragma mark - Core Data Records

- (Word *)updateWordLookupCount:(NSString *)wordToLookup {
    NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
    
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
            List *defaultList = [[SimpleVocabData sharedInstance] getOrCreateDefaultList];
            [word addBelongsToListObject:defaultList];
        }
        
        NSUInteger count = [word.lookupCount unsignedIntegerValue];
        count++;
        word.lookupCount = [NSNumber numberWithUnsignedInteger:count];
        
        [moc save:&error];
    } else {
//        CLS_LOG(kErrorWordCountSave, error, [error userInfo]);
    }
    
    return word;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = kSearchResultsCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
    }

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSearchToDefinitionSegue sender:indexPath];
}

#pragma mark Search Display Controller delegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchForWordFromString:searchString];
    
    return YES;
}

- (void)searchForWordFromString:(NSString *)searchString {
    NSString *searchStringTrimmed = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.finalSearchText = searchStringTrimmed;
    dispatch_async(queue, ^{
        if ([searchStringTrimmed isEqualToString:self.finalSearchText]) {
            NSArray *results = nil;
            if (searchStringTrimmed != nil && [searchStringTrimmed length] > 0) {
                 results = [dictionary searchForWord:searchStringTrimmed];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchResults = results;
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
