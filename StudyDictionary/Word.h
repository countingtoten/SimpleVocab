//
//  Word.h
//  SimpleVocab
//
//  Created by James Weinert on 5/29/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSNumber * lookupCount;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSSet *belongsToList;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addBelongsToListObject:(List *)value;
- (void)removeBelongsToListObject:(List *)value;
- (void)addBelongsToList:(NSSet *)values;
- (void)removeBelongsToList:(NSSet *)values;

@end
