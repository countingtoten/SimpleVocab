//
//  ListContentsViewController.h
//  SimpleVocab
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

@property (nonatomic) List *list;
@property (nonatomic) NSMutableArray *wordsInListSorted;

@end
