//
//  AllLists.m
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "AllLists.h"

#import "List.h"

@implementation AllLists

@dynamic userOrderedLists;

- (void)insertObject:(List *)value inUserOrderedListsAtIndex:(NSUInteger)idx {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.userOrderedLists];
    [tempSet insertObject:value atIndex:idx];
    self.userOrderedLists = tempSet;
}

- (void)addUserOrderedListsObject:(List *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.userOrderedLists];
    [tempSet addObject:value];
    self.userOrderedLists = tempSet;
}

- (void)removeUserOrderedListsObject:(List *)value {
    NSMutableOrderedSet *tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.userOrderedLists];
    [tempSet removeObject:value];
    self.userOrderedLists = tempSet;
}

@end
