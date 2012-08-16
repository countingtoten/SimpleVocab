//
//  WNDictionary.h
//  WNDictionary
//
//  Created by James Weinert on 6/29/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordNetDictionary : NSObject

+ (WordNetDictionary *)sharedInstance;

// Returns 
- (NSArray *)searchForWord:(NSString *)searchText;
- (NSArray *)searchForWord:(NSString *)searchText withLimit:(int)limit;

// Returns a dictionary of definitions. The keys are the part of speech and can be
// @"noun", @"verb", @"adjective", or @"adverb"
- (NSDictionary *)defineWord:(NSString *)wordToDefine;

- (NSArray *)randomWords:(int )limit;

@end
