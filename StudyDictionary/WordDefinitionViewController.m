//
//  WordDefinitionViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "WordDefinitionViewController.h"

#import "ListModalViewController.h"
#import "StudyDictionaryConstants.h"
#import "SVProgressHUD.h"
#import "Word.h"

@interface NSArray (WNAdditions)
- (NSArray *)wn_map:(id (^)(id obj))block;
@end

@interface WordDefinitionViewController ()
- (void)updateWordDefinition;
@end

@implementation WordDefinitionViewController
@synthesize wordnikClient = _wordnikClient;
@synthesize defineRequest;
@synthesize wordToDefine;
@synthesize wordDefinition;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.wordToDefine.word;
    
    [self.wordnikClient addObserver: self];
    
    [self updateWordDefinition];
}

- (void)viewDidUnload {
    [self setWordDefinition:nil];
    [super viewDidUnload];

    [self.defineRequest cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ListModalViewSegue"]) {
        ListModalViewController *listModalViewController = segue.destinationViewController;
        listModalViewController.word = wordToDefine;
    }
}

- (void)updateWordDefinition {
    if (self.wordToDefine.word != nil && [self.wordToDefine.word length] > 0) {
        [self.defineRequest cancel];
        
        NSArray *elements = [NSArray arrayWithObjects:
                             [WNWordDefinitionRequest requestWithDictionary: [WNDictionary wordnetDictionary]],
                             [WNWordExampleRequest request],
                             nil];
        WNWordRequest *req = [WNWordRequest requestWithWord:self.wordToDefine.word
                                       requestCanonicalForm:YES
                                 requestSpellingSuggestions:YES
                                            elementRequests:elements];
        
        self.defineRequest = [self.wordnikClient wordWithRequest:req];
        
        [SVProgressHUD show];
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

#pragma mark Wordnik
- (void) client: (WNClient *) client autocompleteWordRequestDidFailWithError: (NSError *) error requestTicket: (WNRequestTicket *) requestTicket {
    self.defineRequest = nil;
    
    /* Report error */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Lookup Failure" 
                                                    message: [error localizedFailureReason]
                                                   delegate: nil 
                                          cancelButtonTitle: @"OK" 
                                          otherButtonTitles: nil];
    [alert show];
    
    [SVProgressHUD dismissWithError:[NSString stringWithFormat:@"Unable to find definition for %@", wordToDefine.word]];
}

// from WNClientObserver protocol
- (void) client: (WNClient *) client didReceiveWordResponse:(WNWordResponse *)response requestTicket:(WNRequestTicket *)requestTicket {
    if ([self.defineRequest isEqual:requestTicket]) { 
        NSMutableString *infoText = [NSMutableString string];
        WNWordObject *word = response.wordObject;
        BOOL hasDefinitionOrExample = NO;
        
        /* Definitions */
        if (word.definitions != nil && word.definitions.count > 0) {
            hasDefinitionOrExample = YES;
            
            NSString *partOfSpeech = @"";
            for (WNDefinitionList *list in word.definitions) {
                if (list.definitions.count == 0)
                    continue;
                
                NSUInteger count = 1;
                for (WNDefinition *def in list.definitions) {
                    if (![partOfSpeech isEqualToString:def.partOfSpeech.name]) {
                        partOfSpeech = def.partOfSpeech.name;
                        [infoText appendString:[NSString stringWithFormat:@"-%@\n", partOfSpeech]];
                    }
                    
                    [infoText appendString:[NSString stringWithFormat:@"%d. ", count]];
                    count++;
                    
                    if (def.extendedText != nil) {
                        [infoText appendString:def.extendedText];
                    } else {
                        [infoText appendString:def.text];
                    }
                    
                    [infoText appendString: @"\n\n"];
                }
            }
        }
        
        /* Example sentences. */
        if (word.examples != nil && word.examples.count > 0) {
            hasDefinitionOrExample = YES;
            
            NSArray *strings = [word.examples wn_map:^(id obj) {
                WNExample *sentence = obj;
                return [NSString stringWithFormat: @"“%@”\n%@ (%d)", 
                        sentence.text, sentence.title, [sentence.publicationDateComponents year]];
            }];
            
            [infoText appendFormat: @"Examples:\n%@", [strings componentsJoinedByString: @"\n\n"]];
        }
/*        
        if (hasDefinitionOrExample) {
            [infoText appendFormat:@"\n\nhttp://www.wordnik.com/words/%@", self.wordToDefine];
        }
*/        
        self.wordDefinition.text = infoText;
        [SVProgressHUD dismiss];
    }
}

@end
