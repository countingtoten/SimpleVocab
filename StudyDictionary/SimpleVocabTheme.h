//
//  SimpleVocabTheme.h
//  SimpleVocab
//
//  Created by James Weinert on 12/22/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VSTheme.h"

@interface SimpleVocabTheme : VSTheme

+ (SimpleVocabTheme *)sharedInstance;
- (VSTheme *)themeNamed:(NSString *)themeName;

@end
