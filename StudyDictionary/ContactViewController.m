//
//  ContactViewController.m
//  SimpleVocab
//
//  Created by James Weinert on 8/15/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ContactViewController.h"

#import "SimpleVocabConstants.h"

@interface ContactViewController ()
- (void)displayMailComposer;
- (void)displayTweetComposer;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)displayMailComposer {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self;
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:kDeveloperEmail];
	
	[mailPicker setToRecipients:toRecipients];
	
    [self presentModalViewController:mailPicker animated:YES];
}

- (void)displayTweetComposer {
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    [tweetViewController setInitialText:[NSString stringWithFormat:@"%@ ", kDeveloperTwitter]];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                
                break;
            case TWTweetComposeViewControllerResultDone:
                
                break;
            default:
                break;
        }
        
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [self presentModalViewController:tweetViewController animated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:kWebSiteCellIdentifier]) {
        NSURL *url = [NSURL URLWithString:kDeveloperWebsite];
        [[UIApplication sharedApplication] openURL:url];
    } else if ([cell.reuseIdentifier isEqualToString:kEmailCellIdentifier]) {
        [self displayMailComposer];
    } else if ([cell.reuseIdentifier isEqualToString:kTwitterCellIdentifier]) {
        [self displayTweetComposer];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Mail Composer view delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			
			break;
		case MFMailComposeResultSaved:
			
			break;
		case MFMailComposeResultSent:
			
			break;
		case MFMailComposeResultFailed:
			
			break;
		default:
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
