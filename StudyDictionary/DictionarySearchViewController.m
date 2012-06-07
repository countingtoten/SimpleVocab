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
#import "Word.h"
#import "WordDefinitionViewController.h"

@interface DictionarySearchViewController ()
- (void)applicationWillResignActive:(NSNotification *)notification;
- (void)loadSearchBarState;
- (void)saveSearchBarState;
- (void)searchForWordFromString:(NSString *)searchString;
- (void)updateWordLookupCount:(NSString *)wordToLookup;
@end

@implementation DictionarySearchViewController
@synthesize wordnikClient = _wordnikClient;
@synthesize searchRequest;
@synthesize searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.wordnikClient addObserver: self];
    
    [self loadSearchBarState];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResignActive:)
												 name:UIApplicationWillResignActiveNotification
											   object:app];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.searchRequest cancel];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    [self saveSearchBarState];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"WordDefine"]) {
        WordDefinitionViewController *wordDefViewController = segue.destinationViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        wordDefViewController.wordToDefine = [self.searchResults objectAtIndex:indexPath.row];
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
        NSLog(@"Error");
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
        NSLog(@"Error");
    }
}

- (void)updateWordLookupCount:(NSString *)wordToLookup {
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
        NSLog(@"And Error Happened");
    }
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
    [self updateWordLookupCount:[searchResults objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"WordDefine" sender:indexPath];
}

#pragma mark Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {    
    [self searchForWordFromString:searchText];
}

- (void)searchForWordFromString:(NSString *)searchString {
    if (searchString != nil && [searchString length] > 0) {
        [self.searchRequest cancel];
        /* Submit an autocompletion request */
        WNWordSearchRequest *req = [WNWordSearchRequest requestWithWordFragment:searchString
                                                                           skip:0 
                                                                          limit:10 
                                                            includePartOfSpeech:nil
                                                            excludePartOfSpeech:nil
                                                                 minCorpusCount:0
                                                                 maxCorpusCount:0
                                                             minDictionaryCount:1
                                                             maxDictionaryCount:0
                                                                      minLength:0
                                                                      maxLength:0
                                                                resultCollation:WNAutocompleteWordCollationFrequencyDescending];
        
        self.searchRequest = [self.wordnikClient autocompletedWordsWithRequest:req];
    }
}

#pragma mark Wordnik
- (void) client: (WNClient *) client autocompleteWordRequestDidFailWithError: (NSError *) error requestTicket: (WNRequestTicket *) requestTicket {
    self.searchRequest = nil;
    
    /* Report error */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Lookup Failure" 
                                                    message: [error localizedFailureReason]
                                                   delegate: nil 
                                          cancelButtonTitle: @"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}

// from WNClientObserver protocol
- (void) client: (WNClient *) client didReceiveAutocompleteWordResponse: (WNWordSearchResponse *) response requestTicket: (WNRequestTicket *) requestTicket {
    if ([self.searchRequest isEqual:requestTicket]) {  
        self.searchRequest = nil;
        
        /* Display results */
        // NSLog([response.words componentsJoinedByString: @"\n"]);
        NSOrderedSet *tempResults = [NSOrderedSet orderedSetWithArray:response.words];
        
        self.searchResults = [tempResults array];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

#pragma mark - Wordnik Client
- (WNClient *)wordnikClient {
    if (_wordnikClient != nil) {
        return _wordnikClient;
    }
    
    WNClientConfig *config = [WNClientConfig configWithAPIKey:WORDNIK_API_KEY];
    _wordnikClient = [[WNClient alloc] initWithClientConfig: config];
    
    [_wordnikClient requestAPIUsageStatusWithCompletionBlock: ^(WNClientAPIUsageStatus *status, NSError *error) {
        if (error != nil) {
            NSLog(@"Usage request failed: %@", error);
            return;
        }
        
        NSMutableString *output = [NSMutableString string];
        [output appendFormat: @"Expires at: %@\n", status.expirationDate];
        [output appendFormat: @"Reset at: %@\n", status.resetDate];
        [output appendFormat: @"Total calls permitted: %ld\n", (long) status.totalPermittedRequestCount];
        [output appendFormat: @"Total calls remaining: %ld\n", (long) status.remainingPermittedRequestCount];
        
        NSLog(@"API Usage:\n%@", output);
    }];
    
    return _wordnikClient;
}

@end
