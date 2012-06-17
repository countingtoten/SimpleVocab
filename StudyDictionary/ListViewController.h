//
//  ListViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AllLists.h"

@interface ListViewController : UITableViewController <UITextFieldDelegate> {
    AllLists *lists;
    NSString *listOldName;
}

@property (strong, nonatomic) AllLists *lists;
@property (strong, nonatomic) NSString *listOldName;

@end
