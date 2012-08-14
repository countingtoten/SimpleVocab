//
//  WordDefinitionViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Word;

@interface WordDefinitionViewController : UIViewController {
    Word *wordToDefine;
}

@property (strong, nonatomic) Word *wordToDefine;
@property (strong, nonatomic) IBOutlet UITextView *wordDefinition;

@end
