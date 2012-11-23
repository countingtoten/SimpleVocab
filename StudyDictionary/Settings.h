//
//  Settings.h
//  SimpleVocab
//
//  Created by James Weinert on 11/22/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * showAddWordToList;
@property (nonatomic, retain) NSNumber * showEditWordList;

@end
