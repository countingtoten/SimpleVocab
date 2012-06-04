//
//  StudyDictionaryAppDelegate.m
//  StudyDictionary
//
//  Created by James Weinert on 6/3/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "StudyDictionaryAppDelegate.h"
#import "StudyDictionaryAPIConstants.h"

@implementation StudyDictionaryAppDelegate

@synthesize window = _window;
@synthesize wordnikClient = _wordnikClient;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

}

#pragma mark - Wordnik Client
- (WNClient *)wordnikClient {
    if (_wordnikClient != nil) {
        return _wordnikClient;
    }
    
    WNClientConfig *config = [WNClientConfig configWithAPIKey:WORDNIK_API_KEY];
    _wordnikClient = [[WNClient alloc] initWithClientConfig: config];
    
    [_wordnikClient requestAPIUsageStatusWithCompletionBlock: ^(WNClientAPIUsageStatus *status, NSError *error) {
        if (error != nil) {
            NSLog(@"Usage request failed: %@", error);
            return;
        }
        
        NSMutableString *output = [NSMutableString string];
        [output appendFormat: @"Expires at: %@\n", status.expirationDate];
        [output appendFormat: @"Reset at: %@\n", status.resetDate];
        [output appendFormat: @"Total calls permitted: %ld\n", (long) status.totalPermittedRequestCount];
        [output appendFormat: @"Total calls remaining: %ld\n", (long) status.remainingPermittedRequestCount];
        
        NSLog(@"API Usage:\n%@", output);
    }];
    
    return _wordnikClient;
}


@end
