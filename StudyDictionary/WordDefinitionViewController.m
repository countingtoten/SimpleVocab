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
    didViewJustLoad = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!didViewJustLoad && [self.wordDefinition.text length] > 0) {
        [self updateWordDefinition];
    }
    
    didViewJustLoad = NO;
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
    dispatch_queue_t queue = dispatch_queue_create("com.weinertworks.queue", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD show];
        });
        WordNetDictionary *dictionary = [WordNetDictionary sharedInstance];
        NSDictionary *defineResults = [dictionary defineWord:wordToDefine.word];
        
        // Format the definitions results
        NSMutableString *definitionsFormated = [NSMutableString string];
        
        if (defineResults != nil) {
            NSArray *partsOfSpeech = [NSArray arrayWithObjects:@"noun", @"verb", @"adjective", @"adverb", nil];
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
