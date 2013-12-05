//
//  FlashCardViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 10/7/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashCardViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *cardFront;
@property (strong, nonatomic) IBOutlet UITextView *cardBack;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer;

@end
