//
//  DictionarySearchViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 6/4/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Wordnik/Wordnik.h>

@interface DictionarySearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, WNClientObserver> {
    WNClient *wordnikClient;
    WNRequestTicket *searchRequest;
    
    NSArray *searchResults;
}

//@property (strong, nonatomic) WNClient *wordnikClient;
//@property (strong, nonatomic) WNRequestTicket *searchRequest;

@property (strong, nonatomic) NSArray *searchResults;

@end
