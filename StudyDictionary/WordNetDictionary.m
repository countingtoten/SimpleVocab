//
//  WNDictionary.m
//  WNDictionary
//
//  Created by James Weinert on 6/29/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "WordNetDictionary.h"

#import "WordNetSynset.h"
#import "WordNetWord.h"

@interface WordNetDictionary ()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
@end

@implementation WordNetDictionary
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+ (WordNetDictionary *)sharedInstance {
    static dispatch_once_t onceToken;
    static WordNetDictionary *dictionary = nil;
    
    dispatch_once(&onceToken, ^{
        dictionary = [[WordNetDictionary alloc] init];
    });
    
    return dictionary;
}

#pragma mark - Search

- (NSArray *)searchForWord:(NSString *)searchText {
    return [self searchForWord:searchText withLimit:10];
}

- (NSArray *)searchForWord:(NSString *)searchText withLimit:(int)limit {
    if ([searchText isEqualToString:@""]) {
        return nil;
    }
    
    NSFetchRequest *wordRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *wordEntity = [NSEntityDescription entityForName:@"WordNetWord" inManagedObjectContext:self.managedObjectContext];
    [wordRequest setEntity:wordEntity];
    
    NSString *regexFine = [NSString stringWithFormat:@"(lemma matches '%@*')", searchText];
    
    NSPredicate *wordPredicateFineSearch = [NSPredicate predicateWithFormat:regexFine];
    NSLog(@"pred: %@", [wordPredicateFineSearch predicateFormat]);
    [wordRequest setPredicate:wordPredicateFineSearch];
    [wordRequest setFetchLimit:limit];
    
    NSError *error = nil;
    NSArray *wordObjects = [self.managedObjectContext executeFetchRequest:wordRequest error:&error];
    
    NSMutableSet *words = [NSMutableSet setWithCapacity:limit];
    
    if (wordObjects != nil) {
        for (WordNetWord *word in wordObjects) {
            [words addObject:word.lemma];
        }
    } else {
        // Error occurred
        return nil;
    }
    
    if ([words count] < limit) {
        NSString *regexBroad = [NSString stringWithFormat:@"(lemma matches '%@.*')", searchText];
        NSPredicate *wordPredicateBroadSearch = [NSPredicate predicateWithFormat:regexBroad];
        NSLog(@"pred: %@", [wordPredicateBroadSearch predicateFormat]);
        [wordRequest setPredicate:wordPredicateBroadSearch];
        [wordRequest setFetchLimit:(limit - [words count])];
        
        NSError *error = nil;
        NSArray *wordObjects = [self.managedObjectContext executeFetchRequest:wordRequest error:&error];
        
        if (wordObjects != nil) {
            for (WordNetWord *word in wordObjects) {
                [words addObject:word.lemma];
            }
        } else {
            // Error occurred
            return nil;
        }
    }
    
    if ([words count] < limit) {
        NSString *regexBeginning = [NSString stringWithFormat:@"(lemma matches '.*%@.*')", searchText];
        NSPredicate *wordPredicateBroadSearch = [NSPredicate predicateWithFormat:regexBeginning];
        NSLog(@"pred: %@", [wordPredicateBroadSearch predicateFormat]);
        [wordRequest setPredicate:wordPredicateBroadSearch];
        [wordRequest setFetchLimit:(limit - [words count])];
        
        NSError *error = nil;
        NSArray *wordObjects = [self.managedObjectContext executeFetchRequest:wordRequest error:&error];
        
        if (wordObjects != nil) {
            for (WordNetWord *word in wordObjects) {
                [words addObject:word.lemma];
            }
        } else {
            // Error occurred
            return nil;
        }
    }
    NSArray *wordsArray = [[words allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    return wordsArray;
}

#pragma mark - Define

- (NSDictionary *)defineWord:(NSString *)wordToDefine {
    NSFetchRequest *wordRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *wordEntity = [NSEntityDescription entityForName:@"WordNetWord" inManagedObjectContext:self.managedObjectContext];
    [wordRequest setEntity:wordEntity];
    
    NSPredicate *wordPredicate = [NSPredicate predicateWithFormat:@"(lemma = %@)", wordToDefine];
    [wordRequest setPredicate:wordPredicate];
    
    NSError *error = nil;
    NSArray *wordObjects = [self.managedObjectContext executeFetchRequest:wordRequest error:&error];
    
    WordNetWord *word = nil;
    if (wordObjects != nil) {
        if ([wordObjects count] > 0) {
            word = [wordObjects objectAtIndex:0];
        } else {
            return nil;
        }
    } else {
        // Error occurred
        return nil;
    }
    
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    
    for (WordNetSynset *syn in word.relatedSynsets) {
//        NSLog(@"%@: %d - %@", word.lemma, [syn.partOfSpeech intValue], syn.definition);
        int partOfSpeech = [syn.partOfSpeech intValue];
        switch (partOfSpeech) {
            case WordNetNoun:
            {
                NSMutableArray *nounArray = [results objectForKey:@"noun"];
                if (nounArray) {
                    [nounArray addObject:syn.definition];
                } else {
                    nounArray = [NSMutableArray arrayWithObject:syn.definition];
                }
                
                [results setObject:nounArray forKey:@"noun"];
                break;
            }
            case WordNetVerb:
            {
                NSMutableArray *verbArray = [results objectForKey:@"verb"];
                if (verbArray) {
                    [verbArray addObject:syn.definition];
                } else {
                    verbArray = [NSMutableArray arrayWithObject:syn.definition];
                }
                
                [results setObject:verbArray forKey:@"verb"];
                break;
            }
            case WordNetAdjective:
            {
                NSMutableArray *adjArray = [results objectForKey:@"adjective"];
                if (adjArray) {
                    [adjArray addObject:syn.definition];
                } else {
                    adjArray = [NSMutableArray arrayWithObject:syn.definition];
                }
                
                [results setObject:adjArray forKey:@"adjective"];
                break;
            }
            case WordNetAdverb:
            {
                NSMutableArray *adverbArray = [results objectForKey:@"adverb"];
                if (adverbArray) {
                    [adverbArray addObject:syn.definition];
                } else {
                    adverbArray = [NSMutableArray arrayWithObject:syn.definition];
                }
                
                [results setObject:adverbArray forKey:@"adverb"];
                break;
            }
            default:
            {
                // Error occurred
                return nil;
            }
        }
    }
    
    return results;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WordNetDictionary" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"WordNetDictionary.sqlite"];

	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"WordNetDictionary" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
