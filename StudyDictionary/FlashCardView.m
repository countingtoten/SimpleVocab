//
//  FlashCardView.m
//  SimpleVocab
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardView.h"

#import "SimpleVocabConstants.h"

@implementation FlashCardView
@synthesize cardFrontText, cardBackText;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        
        self.cardFrontText = [[UILabel alloc] initWithFrame:frame];
        self.cardFrontText.textAlignment = NSTextAlignmentCenter;
        self.cardFrontText.lineBreakMode = NSLineBreakByWordWrapping;
        self.cardFrontText.numberOfLines = 0;
        self.cardFrontText.font = [UIFont systemFontOfSize:kFlashCardFrontFontSize];
        [self addSubview:cardFrontText];
        
        // The TextView touches the right edge
        CGRect newFrame = CGRectMake(frame.origin.x + 10, frame.origin.y + 10, frame.size.width - 20, frame.size.height - 20);
        self.cardBackText = [[UITextView alloc] initWithFrame:newFrame];
        self.cardBackText.editable = NO;
        self.cardBackText.font = [UIFont systemFontOfSize:kDefaultFontSize];
        [self addSubview:cardBackText];
    }
    return self;
}

- (void)addTextToCardFront:(NSString *)text {
    self.cardBackText.hidden = YES;
    self.cardFrontText.text = text;
}

- (void)addTextToCardBack:(NSString *)text {
    self.cardBackText.hidden = NO;
    self.cardBackText.text = text;
}

@end
