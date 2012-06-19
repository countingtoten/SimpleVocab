//
//  WordDefinitionViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Wordnik/Wordnik.h>

@class Word;

@interface WordDefinitionViewController : UIViewController <WNClientObserver> {
    WNClient *wordnikClient;
    WNRequestTicket *defineRequest;
    
    Word *wordToDefine;
}

@property (strong, nonatomic) WNClient *wordnikClient;
@property (strong, nonatomic) WNRequestTicket *defineRequest;

@property (strong, nonatomic) Word *wordToDefine;
@property (strong, nonatomic) IBOutlet UITextView *wordDefinition;

@end
