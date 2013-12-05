//
//  FlashCardGameViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 8/7/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlashCardSelectViewController.h"

@interface FlashCardGameViewController : UIViewController <UIGestureRecognizerDelegate, FlashCardSelectViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

- (void)fillWordList;
- (void)updateTextOnCard;

@end
