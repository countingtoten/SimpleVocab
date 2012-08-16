//
//  SimpleVocabHelpers.m
//  SimpleVocab
//
//  Created by James Weinert on 6/6/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "SimpleVocabHelpers.h"

#import "SimpleVocabAppDelegate.h"
#import "SimpleVocabConstants.h"

@implementation SimpleVocabHelpers

+ (List *)getOrCreateDefaultList {
    SimpleVocabAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kListEntityName inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(listName = %@)", kDefaultListText];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *listObjects = [moc executeFetchRequest:request error:&error];
    
    List *list = nil;
    if (listObjects != nil) {
        if ([listObjects count] > 0) {
            list = [listObjects objectAtIndex:0];
        } else {
            list = [NSEntityDescription insertNewObjectForEntityForName:kListEntityName inManagedObjectContext:moc];
            list.listName = kDefaultListText;
            
            AllLists *allLists = [SimpleVocabHelpers getOrCreateAllLists];
            list.allLists = allLists;
            
            [moc save:&error];
        }        
    } else {
        NSLog(@"And Error Happened");
    }
    
    return list;
}

+ (AllLists *)getOrCreateAllLists {
    SimpleVocabAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kAllListsEntityName inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *allListObjects = [moc executeFetchRequest:request error:&error];
    
    AllLists *allLists = nil;
    if (allListObjects != nil) {
        if ([allListObjects count] > 0) {
            allLists = [allListObjects objectAtIndex:0];
        } else {
            allLists = [NSEntityDescription insertNewObjectForEntityForName:kAllListsEntityName inManagedObjectContext:moc];
            [moc save:&error];
        }
    } else {
        NSLog(@"Yeah, yeah, error");
    }
    
    return allLists;
}

@end
