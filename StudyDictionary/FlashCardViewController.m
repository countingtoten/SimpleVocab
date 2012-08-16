//
//  FlashCardViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 8/7/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardViewController.h"

#import "FlashCardView.h"
#import "List.h"
#import "SimpleVocabAppDelegate.h"
#import "SimpleVocabConstants.h"
#import "SVProgressHUD.h"
#import "Word.h"
#import "WordNetDictionary.h"

@interface FlashCardViewController ()
- (void)fillWordList;
@end

@implementation FlashCardViewController
@synthesize currentWord, wordsInList, wholeList;
@synthesize cardFront, cardBack;
@synthesize tapRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    if (self.cardFront.superview == nil) {
        self.cardFront = nil;
    } else {
        self.cardBack = nil;
    }
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
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.cardFront.superview == nil) {
        if (self.cardFront == nil) {
            self.cardFront = [[FlashCardView alloc] initWithFrame:self.view.frame];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        
        [self updateTextOnFrontCard];
        
        [self.cardBack removeFromSuperview];
        [self.view insertSubview:self.cardFront atIndex:0];
    } else {
        if (self.cardBack == nil) {
            self.cardBack = [[FlashCardView alloc] initWithFrame:self.view.frame];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [SVProgressHUD show];
        
        dispatch_queue_t queue = dispatch_queue_create(kDefaultQueueIdentifier, NULL);
        dispatch_async(queue, ^{
            WordNetDictionary *dictionary = [WordNetDictionary sharedInstance];
            NSDictionary *defineResults = [dictionary defineWord:currentWord];
            
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
                definitionsFormated = [NSString stringWithFormat:@"Could not find definition for %@, sorry.", currentWord];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cardBack addTextToCardBack:definitionsFormated];
                [self.cardFront removeFromSuperview];
                [self.view insertSubview:self.cardBack atIndex:0];
                [SVProgressHUD dismiss];
            });
        });
    }
    [UIView commitAnimations];
}

- (void)fillWordList {
    self.wordsInList = [NSMutableArray arrayWithArray:self.wholeList];
}

- (void)updateTextOnFrontCard {
    // Remove a random word from the list and set its text
    if ([self.wordsInList count] == 0) {
        [self fillWordList];
    }
    
    NSUInteger randomIndex = arc4random() % [self.wordsInList count];
    NSString *word = [self.wordsInList objectAtIndex:randomIndex];
    [self.wordsInList removeObjectAtIndex:randomIndex];
    [self.cardFront addTextToCardFront:word];
    self.currentWord = word;
}

#pragma mark - FlashCardSelectViewControllerDelegate Methods

- (void)flashCardSelectViewController:(FlashCardSelectViewController *)controller selectedListName:(NSString *)listName; {
    SimpleVocabAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
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
        
        [self.cardBack removeFromSuperview];
        if (self.cardFront == nil) {
            self.cardFront = [[FlashCardView alloc] initWithFrame:self.view.frame];
        } else {
            [self.cardFront removeFromSuperview];
        }
        
        [self updateTextOnFrontCard];
        [self.view insertSubview:self.cardFront atIndex:0];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
