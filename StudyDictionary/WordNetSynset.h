//
//  WordNetSynset.h
//  WordNetDictionary
//
//  Created by James Weinert on 7/16/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum { 
    WordNetNoun,
    WordNetVerb,
    WordNetAdjective,
    WordNetAdverb
} WordNetPartOfSpeech;

@class WordNetWord;

@interface WordNetSynset : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSNumber * partOfSpeech;
@property (nonatomic, retain) NSSet *relatedWords;
@end

@interface WordNetSynset (CoreDataGeneratedAccessors)

- (void)addRelatedWordsObject:(WordNetWord *)value;
- (void)removeRelatedWordsObject:(WordNetWord *)value;
- (void)addRelatedWords:(NSSet *)values;
- (void)removeRelatedWords:(NSSet *)values;

@end
