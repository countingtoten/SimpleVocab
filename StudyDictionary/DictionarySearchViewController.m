//
//  DictionarySearchViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "DictionarySearchViewController.h"
#import "StudyDictionaryAPIConstants.h"
#import "WordDefinitionViewController.h"

@interface DictionarySearchViewController ()
- (void)searchForWordFromString:(NSString *)searchString;
@end

@implementation DictionarySearchViewController
@synthesize wordnikClient = _wordnikClient;
@synthesize searchRequest;
@synthesize searchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self.wordnikClient addObserver: self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.searchRequest cancel];
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
