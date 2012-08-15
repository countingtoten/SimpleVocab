//
//  FlashCardViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 8/7/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlashCardSelectViewController.h"

@class FlashCardView;
@class List;
@class Word;

@interface FlashCardViewController : UIViewController <UIGestureRecognizerDelegate, FlashCardSelectViewControllerDelegate> {
    List *list;
    Word *currentWord;
    NSMutableArray *wordsInList;
}

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) Word *currentWord;
@property (strong, nonatomic) NSMutableArray *wordsInList;

@property (strong, nonatomic) FlashCardView *cardFront;
@property (strong, nonatomic) FlashCardView *cardBack;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

- (void)flipViews;
- (void)fillWordList;
- (void)updateTextOnFrontCard;

@end
