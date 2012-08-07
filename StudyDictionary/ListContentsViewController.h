//
//  ListContentsViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/17/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class List;

@interface ListContentsViewController : UITableViewController {
    List *list;
    NSMutableArray *wordsInListSorted;
    
    BOOL didViewJustLoad;
}

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) NSMutableArray *wordsInListSorted;

@end
