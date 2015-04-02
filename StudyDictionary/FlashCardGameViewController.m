//
//  FlashCardViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 8/7/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardGameViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "FlashCardViewController.h"
#import "List.h"
#import "SimpleVocabData.h"
#import "SimpleVocabConstants.h"
#import "Word.h"
#import "WordNetDictionary.h"

@interface FlashCardGameViewController () {
    NSString *currentWord;
    NSMutableArray *wordsInList;
    NSArray *wholeList;
}

@property (nonatomic) NSString *currentWord;
@property (nonatomic) NSMutableArray *wordsInList;
@property (nonatomic) NSArray *wholeList;

- (void)fillWordList;
@end

@implementation FlashCardGameViewController
@synthesize currentWord, wordsInList, wholeList;
@synthesize tapRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.bounds.size.width - (2 * kFlashCardEdgeBorder);
    CGFloat height = self.view.bounds.size.height - (2 * kFlashCardEdgeBorder);
    
    FlashCardViewController *childController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashCardViewController"];
    
    childController.view.frame = CGRectMake(kFlashCardEdgeBorder, kFlashCardEdgeBorder, width, height);
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    
    //if ([wordsInList count] == 0) {
    //    [self performSegueWithIdentifier:kFlashToFlashSelectSegue sender: self];
    //}
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self.wholeList count] > 0;
}

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer {
    //[self flipViews];
}

- (void)fillWordList {
    self.wordsInList = [NSMutableArray arrayWithArray:self.wholeList];
}

- (void)updateTextOnCard {
/*    // Remove a random word from the list and set its text
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
            definitionsFormated = [NSMutableString stringWithFormat:@"Could not find definition for %@, sorry.", word];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cardBack.text = definitionsFormated;
        });
    });*/
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
//        CLS_LOG(kErrorFlashCardLoad, error, [error userInfo]);
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
