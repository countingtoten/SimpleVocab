//
//  DictionarySearchViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordNetDictionary;

@interface DictionarySearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    NSArray *searchResults;
    WordNetDictionary *dictionary;

    dispatch_queue_t queue;
}

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) WordNetDictionary *dictionary;

@end
