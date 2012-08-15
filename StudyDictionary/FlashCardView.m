//
//  FlashCardView.m
//  StudyDictionary
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "FlashCardView.h"

@implementation FlashCardView
@synthesize cardFrontText, cardBackText;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        
        self.cardFrontText = [[UILabel alloc] initWithFrame:frame];
        self.cardFrontText.textAlignment = UITextAlignmentCenter;
        self.cardFrontText.font = [UIFont systemFontOfSize:20];
        [self addSubview:cardFrontText];
        
        self.cardBackText = [[UITextView alloc] initWithFrame:frame];
        self.cardBackText.font = [UIFont systemFontOfSize:20];
        self.cardBackText.editable = NO;
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
