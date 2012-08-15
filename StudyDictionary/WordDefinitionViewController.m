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
#import "WordNetDictionary.h"

@interface WordDefinitionViewController ()
- (void)updateWordDefinition;
@end

@implementation WordDefinitionViewController
@synthesize wordToDefine;
@synthesize wordDefinition;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = self.wordToDefine.word;
    
    [self updateWordDefinition];
    [SVProgressHUD show];
}

- (void)viewDidUnload {
    [self setWordDefinition:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kDefinitionToListModalSegue]) {
        ListModalViewController *listModalViewController = segue.destinationViewController;
        listModalViewController.word = wordToDefine;
    }
}

- (void)updateWordDefinition {
    dispatch_queue_t queue = dispatch_queue_create(kDefaultQueueIdentifier, NULL);
    dispatch_async(queue, ^{
        WordNetDictionary *dictionary = [WordNetDictionary sharedInstance];
        NSDictionary *defineResults = [dictionary defineWord:wordToDefine.word];
        
        // Format the definitions results
        NSMutableString *definitionsFormated = [NSMutableString string];
        
        if (defineResults != nil) {
            NSArray *partsOfSpeech = kPartsOfSpeechArrayInOrderOfImportance;
            NSInteger i = 1;
            for (NSString *key in partsOfSpeech) {
                NSArray *definitions = [defineResults objectForKey:key];
                if (definitions != nil) {
                    [definitionsFormated appendFormat:@"-%@\n", key];
                    for(NSString *def in definitions) {
                        [definitionsFormated appendFormat:@"%d. %@\n\n", i, def];
                        i++;
                    }
                }
            }
        } else {
            definitionsFormated = [NSString stringWithFormat:@"Could not find definition for %@, sorry.", wordToDefine.word];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.wordDefinition.text = definitionsFormated;
            [SVProgressHUD dismiss];
        });
    });
}

@end
