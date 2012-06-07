//
//  ListViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AllLists.h"

@interface ListViewController : UITableViewController {
    AllLists *lists;
}

@property (strong, nonatomic) AllLists *lists;

@end
