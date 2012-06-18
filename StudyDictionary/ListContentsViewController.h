//
//  ListContentsViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/17/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "List.h"

@interface ListContentsViewController : UITableViewController {
    List *list;
    NSMutableArray *wordsInListSorted;
}

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) NSMutableArray *wordsInListSorted;

@end
