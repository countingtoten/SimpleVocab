//
//  FlashCardViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 10/7/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import "FlashCardViewController.h"

#import "SimpleVocabConstants.h"

@interface FlashCardViewController ()
- (void)flipViews;
@end

@implementation FlashCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.cardFront.frame = self.view.frame;
    self.cardFront.backgroundColor = [UIColor whiteColor];
    self.cardFront.layer.cornerRadius = kFlashCardCornerRadius;
    self.cardFront.layer.masksToBounds = YES;
    self.cardFront.textAlignment = NSTextAlignmentCenter;
    self.cardFront.lineBreakMode = NSLineBreakByWordWrapping;
    self.cardFront.numberOfLines = 0;
    self.cardFront.font = [UIFont systemFontOfSize:kFlashCardFrontFontSize];

    //self.cardBack.frame = self.view.frame;
    self.cardBack.backgroundColor = [UIColor whiteColor];
    self.cardBack.layer.cornerRadius = kFlashCardCornerRadius;
    self.cardBack.layer.masksToBounds = YES;
    self.cardBack.editable = NO;
    self.cardBack.font = [UIFont systemFontOfSize:kDefaultFontSize];
    
    // If we don't add both subviews, the size will be wrong
    // Will fix this later
    //[self.view addSubview:self.cardBack];
    [self.view addSubview:self.cardFront];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self.wholeList count] > 0;
}
*/
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
        
        //[self updateTextOnCard];
    }
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:1.25
                       options:options
                    completion:^(BOOL finished) {
                        
                    }];
}

@end
