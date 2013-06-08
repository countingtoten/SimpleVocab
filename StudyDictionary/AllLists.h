//
//  AllLists.h
//  SimpleVocab
//
//  Created by James Weinert on 5/29/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AllLists : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *userOrderedLists;
@end

@interface AllLists (CoreDataGeneratedAccessors)

- (void)insertObject:(NSManagedObject *)value inUserOrderedListsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUserOrderedListsAtIndex:(NSUInteger)idx;
- (void)insertUserOrderedLists:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUserOrderedListsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUserOrderedListsAtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
- (void)replaceUserOrderedListsAtIndexes:(NSIndexSet *)indexes withUserOrderedLists:(NSArray *)values;
- (void)addUserOrderedListsObject:(NSManagedObject *)value;
- (void)removeUserOrderedListsObject:(NSManagedObject *)value;
- (void)addUserOrderedLists:(NSOrderedSet *)values;
- (void)removeUserOrderedLists:(NSOrderedSet *)values;
@end
