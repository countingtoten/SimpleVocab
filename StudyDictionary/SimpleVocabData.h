//
//  SimpleVocabData.h
//  SimpleVocab
//
//  Created by James Weinert on 10/20/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AllLists;
@class List;
@class SearchBarContents;
@class Settings;

@interface SimpleVocabData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) SearchBarContents *searchBarContents;
@property (strong, nonatomic) Settings *appSettings;

+ (SimpleVocabData *)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (List *)getOrCreateDefaultList;
- (AllLists *)getOrCreateAllLists;

@end
