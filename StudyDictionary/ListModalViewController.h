//
//  ListModalViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 6/18/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListTemplateViewController.h"

@class Word;

@interface ListModalViewController : ListTemplateViewController {
    Word *word;
}

@property (strong, nonatomic) Word *word;

@end
