//
//  AllLists.h
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface AllLists : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *userOrderedLists;
@end

@interface AllLists (CoreDataGeneratedAccessors)

- (void)insertObject:(List *)value inUserOrderedListsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUserOrderedListsAtIndex:(NSUInteger)idx;
- (void)insertUserOrderedLists:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUserOrderedListsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUserOrderedListsAtIndex:(NSUInteger)idx withObject:(List *)value;
- (void)replaceUserOrderedListsAtIndexes:(NSIndexSet *)indexes withUserOrderedLists:(NSArray *)values;
- (void)addUserOrderedListsObject:(List *)value;
- (void)removeUserOrderedListsObject:(List *)value;
- (void)addUserOrderedLists:(NSOrderedSet *)values;
- (void)removeUserOrderedLists:(NSOrderedSet *)values;
@end
