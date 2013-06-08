//
//  SimpleVocabData.m
//  SimpleVocab
//
//  Created by James Weinert on 10/20/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "SimpleVocabData.h"

#import <Crashlytics/Crashlytics.h>

#import "AllLists.h"
#import "List.h"
#import "SearchBarContents.h"
#import "Settings.h"
#import "SimpleVocabConstants.h"

@implementation SimpleVocabData
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize searchBarContents = _searchBarContents;
@synthesize appSettings = _appSettings;

+ (SimpleVocabData *)sharedInstance {
    static dispatch_once_t onceToken;
    static SimpleVocabData *vocabData = nil;
    
    dispatch_once(&onceToken, ^{
        vocabData = [[SimpleVocabData alloc] init];
    });
    
    return vocabData;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            CLS_LOG(kErrorCoreDataSave, error, [error userInfo]);
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SimpleVocab" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SimpleVocab.sqlite"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SimpleVocab" ofType:@"sqlite"]];
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&error]) {
            CLS_LOG(kStatusCopiedCoreDataFile);
        }
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        CLS_LOG(kErrorPersistentStore, error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application Settings

- (SearchBarContents *)searchBarContents {
    SearchBarContents *searchBar;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kSearchBarEntityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        if ([array count] > 0) {
            searchBar = [array objectAtIndex:0];
        }
    } else {
        CLS_LOG(kErrorSearchBarContentsLoad);
    }
    
    return searchBar;
}

- (void)setSearchBarContents:(SearchBarContents *)searchBarContents {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kSearchBarEntityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        SearchBarContents *searchBar = nil;
        if ([array count] > 0) {
            searchBar = [array objectAtIndex:0];
        } else {
            searchBar = [NSEntityDescription insertNewObjectForEntityForName:kSearchBarEntityName inManagedObjectContext:self.managedObjectContext];
        }
        
        searchBar.savedSearchString = searchBarContents.savedSearchString;
        searchBar.searchWasActive = searchBarContents.searchWasActive;
        
        [self.managedObjectContext save:&error];
    } else {
        CLS_LOG(kErrorSearchBarContentsSave);
    }
}

- (Settings *)appSettings {
    Settings *settings;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAppSettingsEntityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        if ([array count] > 0) {
            settings = [array objectAtIndex:0];
        }
    } else {
        CLS_LOG(kErrorSettingsLoad);
    }
    
    return settings;
}

- (void)setAppSettings:(Settings *)appSettings {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAppSettingsEntityName inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (array != nil) {
        Settings *settings = nil;
        if ([array count] > 0) {
            settings = [array objectAtIndex:0];
        } else {
            settings = [NSEntityDescription insertNewObjectForEntityForName:kAppSettingsEntityName inManagedObjectContext:self.managedObjectContext];
        }
        
        settings.showAddWordToList = appSettings.showAddWordToList;
        settings.showEditWordList = appSettings.showEditWordList;
        
        [self.managedObjectContext save:&error];
    } else {
        CLS_LOG(kErrorSettingsSave);
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Application Helpers

- (List *)getOrCreateDefaultList {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kListEntityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(listName = %@)", kDefaultListText];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    List *list = nil;
    if (listObjects != nil) {
        if ([listObjects count] > 0) {
            list = [listObjects objectAtIndex:0];
        } else {
            list = [NSEntityDescription insertNewObjectForEntityForName:kListEntityName inManagedObjectContext:self.managedObjectContext];
            list.listName = kDefaultListText;
            
            AllLists *allLists = [self getOrCreateAllLists];
            list.allLists = allLists;
            
            [self.managedObjectContext save:&error];
        }
    } else {
        CLS_LOG(kErrorCoreDataLoad, error, [error userInfo]);
    }
    
    return list;
}

- (AllLists *)getOrCreateAllLists {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAllListsEntityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *allListObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    AllLists *allLists = nil;
    if (allListObjects != nil) {
        if ([allListObjects count] > 0) {
            allLists = [allListObjects objectAtIndex:0];
        } else {
            allLists = [NSEntityDescription insertNewObjectForEntityForName:kAllListsEntityName inManagedObjectContext:self.managedObjectContext];
            [self.managedObjectContext save:&error];
        }
    } else {
        CLS_LOG(kErrorCoreDataLoad, error, [error userInfo]);
    }
    
    return allLists;
}

@end
