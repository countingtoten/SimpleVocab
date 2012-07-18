//
//  WordNetWord.h
//  WordNetDictionary
//
//  Created by James Weinert on 7/16/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WordNetSynset;

@interface WordNetWord : NSManagedObject

@property (nonatomic, retain) NSString * lemma;
@property (nonatomic, retain) NSSet *relatedSynsets;
@end

@interface WordNetWord (CoreDataGeneratedAccessors)

- (void)addRelatedSynsetsObject:(WordNetSynset *)value;
- (void)removeRelatedSynsetsObject:(WordNetSynset *)value;
- (void)addRelatedSynsets:(NSSet *)values;
- (void)removeRelatedSynsets:(NSSet *)values;

@end
