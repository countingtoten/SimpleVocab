//
//  SearchBarContents.h
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchBarContents : NSManagedObject

@property (nonatomic, retain) NSString * savedSearchString;
@property (nonatomic, retain) NSNumber * searchWasActive;

@end
