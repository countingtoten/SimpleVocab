//
//  FlashCardViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 8/7/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "List.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"
#import "WordNetDictionary.h"

@interface FlashCardViewController ()
- (void)fillWordList;
@end

@implementation FlashCardViewController
@synthesize currentWord, wordsInList, wholeList;
@synthesize tapRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cardFront setFrame:self.view.bounds];
    self.cardFront.backgroundColor = [UIColor whiteColor];
    self.cardFront.layer.cornerRadius = kFlashCardCornerRadius;
    self.cardFront.layer.masksToBounds = YES;
    self.cardFront.textAlignment = NSTextAlignmentCenter;
    self.cardFront.lineBreakMode = NSLineBreakByWordWrapping;
    self.cardFront.numberOfLines = 0;
    self.cardFront.font = [UIFont systemFontOfSize:kFlashCardFrontFontSize];
    
    [self.cardBack setFrame:self.view.bounds];
    self.cardBack.backgroundColor = [UIColor whiteColor];
    self.cardBack.layer.cornerRadius = kFlashCardCornerRadius;
    self.cardBack.layer.masksToBounds = YES;
    self.cardBack.editable = NO;
    self.cardBack.font = [UIFont systemFontOfSize:kDefaultFontSize];
    
    // If we don't add both subviews, the size will be wrong
    // Will fix this later
    [self.view addSubview:self.cardBack];
    [self.view addSubview:self.cardFront];
    
    if ([wordsInList count] == 0) {
        [self performSegueWithIdentifier:kFlashToFlashSelectSegue sender: self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kFlashToFlashSelectSegue]) {
        UINavigationController *navigationController = segue.destinationViewController;
        FlashCardSelectViewController *listModalViewController = [[navigationController viewControllers] objectAtIndex:0];
        listModalViewController.delegate = self;
    }
}

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    [self flipViews];
}

- (void)flipViews {
    UIView *fromView, *toView;
    UIViewAnimationOptions options;
    
    if([self.cardFront superview] != nil) {
        fromView = self.cardFront;
        toView = self.cardBack;

        options = UIViewAnimationOptionTransitionFlipFromRight;
    } else {
        fromView = self.cardBack;
        toView = self.cardFront;
        
        options = UIViewAnimationOptionTransitionFlipFromLeft;
        
        [self updateTextOnCard];
    }
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:1.25
                       options:options
                    completion:^(BOOL finished) {
                        
                    }];
}

- (void)fillWordList {
    self.wordsInList = [NSMutableArray arrayWithArray:self.wholeList];
}

- (void)updateTextOnCard {
    // Remove a random word from the list and set its text
    if ([self.wordsInList count] == 0) {
        [self fillWordList];
    }
    
    NSUInteger randomIndex = arc4random() % [self.wordsInList count];
    NSString *word = [self.wordsInList objectAtIndex:randomIndex];
    [self.wordsInList removeObjectAtIndex:randomIndex];
    self.cardFront.text = word;
    
    dispatch_queue_t queue = dispatch_queue_create(kDefaultQueueIdentifier, NULL);
    dispatch_async(queue, ^{
        WordNetDictionary *dictionary = [WordNetDictionary sharedInstance];
        NSDictionary *defineResults = [dictionary defineWord:word];
        
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
            definitionsFormated = [NSString stringWithFormat:@"Could not find definition for %@, sorry.", word];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cardBack.text = definitionsFormated;
        });
    });
}

#pragma mark - FlashCardSelectViewControllerDelegate Methods

- (void)flashCardSelectViewController:(FlashCardSelectViewController *)controller selectedListName:(NSString *)listName; {
    NSManagedObjectContext *moc = [[SimpleVocabData sharedInstance] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kListEntityName inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(listName = %@)", listName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listObjects = [moc executeFetchRequest:request error:&error];
    
    List *listObject = nil;
    if (listObjects != nil) {
        if ([listObjects count] > 0) {
            listObject = [listObjects objectAtIndex:0];
        } else {
            // The list name doesn't exist
            // but self.wholeList will equal nil
            // and we won't have to worry about this
        }
    } else {
        NSLog(@"And Error Happened");
    }
    
    NSMutableArray *wordList = [NSMutableArray array];
    for (Word *word in listObject.listContents) {
        [wordList addObject:word.word];
    }
    
    self.wholeList = [NSArray arrayWithArray:wordList];
    
    if ([self.wholeList count] > 0) {        
        [self fillWordList];
        [self updateTextOnCard];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
