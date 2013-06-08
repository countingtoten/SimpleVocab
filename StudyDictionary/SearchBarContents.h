//
//  SearchBarContents.h
//  SimpleVocab
//
//  Created by James Weinert on 5/29/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchBarContents : NSManagedObject

@property (nonatomic, retain) NSString * savedSearchString;
@property (nonatomic, retain) NSNumber * searchWasActive;

@end
