//
//  FlashCardView.h
//  SimpleVocab
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface FlashCardView : UIScrollView {
    UILabel *cardFrontText;
    UITextView *cardBackText;
}

@property (strong, nonatomic) UILabel *cardFrontText;
@property (strong, nonatomic) UITextView *cardBackText;

- (id)initWithFrame:(CGRect)frame;
- (void)addTextToCardFront:(NSString *)text;
- (void)addTextToCardBack:(NSString *)text;

@end
