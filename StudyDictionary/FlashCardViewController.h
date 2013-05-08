//
//  FlashCardViewController.h
//  SimpleVocab
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

@property (strong, nonatomic) IBOutlet UILabel *cardFront;
@property (strong, nonatomic) IBOutlet UITextView *cardBack;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

- (void)flipViews;
- (void)fillWordList;
- (void)updateTextOnCard;

@end
