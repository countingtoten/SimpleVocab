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

@interface FlashCardViewController : UIViewController <UIGestureRecognizerDelegate, FlashCardSelectViewControllerDelegate> {
    NSString *currentWord;
    NSMutableArray *wordsInList;
    NSArray *wholeList;
}

@property (strong, nonatomic) NSString *currentWord;
@property (strong, nonatomic) NSMutableArray *wordsInList;
@property (strong, nonatomic) NSArray *wholeList;

@property (strong, nonatomic) FlashCardView *cardFront;
@property (strong, nonatomic) FlashCardView *cardBack;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

- (void)flipViews;
- (void)fillWordList;
- (void)updateTextOnFrontCard;

@end
