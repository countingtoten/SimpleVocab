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

@interface NSArray (WNAdditions)
- (NSArray *)wn_map:(id (^)(id obj))block;
@end

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
}

- (void)viewDidUnload {
    [self setWordDefinition:nil];
    [super viewDidUnload];
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
    WordNetDictionary *dict = [WordNetDictionary sharedInstance];
    NSDictionary *defineResults = [dict defineWord:wordToDefine.word];
    
    // Format the definitions results
    NSMutableString *definitionsFormated = [NSMutableString string];
    
    if (defineResults != nil) {
        
        NSInteger i = 1;
        for (NSString *key in defineResults) {
            NSArray *definitions = [defineResults objectForKey:key];
            
            [definitionsFormated appendFormat:@"-%@\n", key];
            for(NSString *def in definitions) {
                [definitionsFormated appendFormat:@"%d. %@\n\n", i, def];
                i++;
            }
        }
        
        self.wordDefinition.text = definitionsFormated;
    } else {
        self.wordDefinition.text = [NSString stringWithFormat:@"Could not find definition for %@, sorry.", wordToDefine.word];
    }
}

@end
