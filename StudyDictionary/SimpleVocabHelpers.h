//
//  SimpleVocabHelpers.h
//  SimpleVocab
//
//  Created by James Weinert on 6/6/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AllLists.h"
#import "List.h"

@interface SimpleVocabHelpers : NSObject

+ (List *)getOrCreateDefaultList;
+ (AllLists *)getOrCreateAllLists;

@end
