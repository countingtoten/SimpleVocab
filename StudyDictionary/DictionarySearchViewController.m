//
//  DictionarySearchViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "DictionarySearchViewController.h"
#import "StudyDictionaryAppDelegate.h"

@interface DictionarySearchViewController ()
- (void)searchForWordFromString:(NSString *)searchString;
@end

@implementation DictionarySearchViewController
@synthesize searchResults;
//@synthesize wordnikClient, searchRequest;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    StudyDictionaryAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    wordnikClient = [appDelegate wordnikClient];
    [wordnikClient addObserver: self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [searchRequest cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    }
    
    cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark Search Bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {    
    [self searchForWordFromString:searchText];
}

- (void)searchForWordFromString:(NSString *)searchString {
    if (searchString != nil && [searchString length] > 0) {
//        NSLog(@"searcfForWordFromString");
        [searchRequest cancel];
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
        
        searchRequest = [wordnikClient autocompletedWordsWithRequest:req];
    }
}

#pragma mark Wordnik
- (void) client: (WNClient *) client autocompleteWordRequestDidFailWithError: (NSError *) error requestTicket: (WNRequestTicket *) requestTicket {
    NSLog(@"autocompleteWordRequestDidFailWithError");
    searchRequest = nil;
    
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
//    NSLog(@"didReceiveAutoCompleteWordResponse");
    if ([searchRequest isEqual:requestTicket]) {  
        searchRequest = nil;
        
        /* Display results */
        // NSLog([response.words componentsJoinedByString: @"\n"]);
        NSOrderedSet *tempResults = [NSOrderedSet orderedSetWithArray:response.words];
        
        self.searchResults = [tempResults array];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

@end
