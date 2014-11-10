//
//  SimpleVocabTheme.m
//  SimpleVocab
//
//  Created by James Weinert on 12/22/13.
//  Copyright (c) 2013 Weinert Works. All rights reserved.
//

#import "SimpleVocabTheme.h"

@interface SimpleVocabTheme()
@property (nonatomic) NSArray *otherThemes;
@end

@implementation SimpleVocabTheme
@synthesize otherThemes;

+ (SimpleVocabTheme *)sharedInstance {
    static dispatch_once_t onceToken;
    static SimpleVocabTheme *vocabTheme = nil;
    
    dispatch_once(&onceToken, ^{
        NSString *themesFilePath = [[NSBundle mainBundle] pathForResource:@"SimpleVocabTheme" ofType:@"plist"];
        NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfFile:themesFilePath];

        NSMutableArray *themes = [NSMutableArray array];
        for (NSString *oneKey in themesDictionary) {
            
            if ([[oneKey lowercaseString] isEqualToString:@"default"]) {
                vocabTheme = [[SimpleVocabTheme alloc] initWithDictionary:themesDictionary[oneKey]];
            } else {
                VSTheme *theme = [[VSTheme alloc] initWithDictionary:themesDictionary[oneKey]];
                theme.name = oneKey;
                [themes addObject:theme];
            }
        }
        
        if (vocabTheme != nil) {
            vocabTheme.otherThemes = [NSArray arrayWithArray:themes];
        }
    });
    
    return vocabTheme;
}

- (VSTheme *)themeNamed:(NSString *)themeName {
    
	for (VSTheme *oneTheme in self.otherThemes) {
		if ([themeName isEqualToString:oneTheme.name])
			return oneTheme;
	}
    
	return nil;
}

@end
