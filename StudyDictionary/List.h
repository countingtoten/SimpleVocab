//
//  List.h
//  StudyDictionary
//
//  Created by James Weinert on 6/5/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllLists, Word;

@interface List : NSManagedObject

@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSSet *listContents;
@property (nonatomic, retain) AllLists *allLists;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addListContentsObject:(Word *)value;
- (void)removeListContentsObject:(Word *)value;
- (void)addListContents:(NSSet *)values;
- (void)removeListContents:(NSSet *)values;

@end
