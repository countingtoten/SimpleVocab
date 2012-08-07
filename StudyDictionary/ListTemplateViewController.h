//
//  ListTemplateViewController.h
//  StudyDictionary
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

@property (strong, nonatomic) AllLists *lists;
@property (strong, nonatomic) NSString *listOldName;

@end
