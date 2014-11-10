//
//  FlashCardViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 10/7/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashCardViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet UILabel *cardFront;
@property (nonatomic) IBOutlet UITextView *cardBack;
@property (nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

@end
