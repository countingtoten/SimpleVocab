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
	
    [self presentViewController:mailPicker animated:YES completion:nil];
}

- (void)displayTweetComposer {
    SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [tweetViewController setInitialText:[NSString stringWithFormat:@"%@ ", kDeveloperTwitter]];
    
    // Present the tweet composition view controller modally.
    [self presentViewController:tweetViewController animated:YES completion:nil];
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
