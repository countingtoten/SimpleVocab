//
//  List.h
//  SimpleVocab
//
//  Created by James Weinert on 5/29/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AllLists, Word;

@interface List : NSManagedObject

@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) AllLists *allLists;
@property (nonatomic, retain) NSSet *listContents;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addListContentsObject:(Word *)value;
- (void)removeListContentsObject:(Word *)value;
- (void)addListContents:(NSSet *)values;
- (void)removeListContents:(NSSet *)values;

@end
