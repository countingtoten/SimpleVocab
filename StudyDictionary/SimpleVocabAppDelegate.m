//
//  SimpleVocabAppDelegate.m
//  SimpleVocab
//
//  Created by James Weinert on 6/3/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "SimpleVocabAppDelegate.h"

#import <Crashlytics/Crashlytics.h>

#import "SimpleVocabData.h"

@implementation SimpleVocabAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"11bee23f6e449407d34a542118f1d544183478cf"];
    
    // Create default list if it doesn't exist
    [[SimpleVocabData sharedInstance] getOrCreateDefaultList];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SimpleVocabData sharedInstance] saveContext];
}

@end
