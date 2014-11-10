//
//  DictionarySearchViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordNetDictionary;

@interface DictionarySearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    NSArray *searchResults;
    WordNetDictionary *dictionary;

    NSString *finalSearchText;
    dispatch_queue_t queue;
}

@property (nonatomic) NSArray *searchResults;
@property (nonatomic) WordNetDictionary *dictionary;

@property (nonatomic) NSString *finalSearchText;

@end
