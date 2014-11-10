//
//  ListTemplateViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 6/18/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllLists;

@interface ListTemplateViewController : UITableViewController <UITextFieldDelegate> {
    AllLists *lists;
    NSString *listOldName;
    
    BOOL didViewJustLoad;
}

@property (nonatomic) AllLists *lists;
@property (nonatomic) NSString *listOldName;

@end
