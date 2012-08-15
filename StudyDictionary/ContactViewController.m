//
//  ContactViewController.m
//  StudyDictionary
//
//  Created by James Weinert on 8/15/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ContactViewController.h"

#define kWebSiteCellIdentifier  @"ContactWebsiteCell"
#define kEmailCellIdentifier    @"ContactEmailCell"
#define kTwitterCellIdentifier  @"ContactTwitterCell"

@interface ContactViewController ()
- (void)displayMailComposer;
- (void)displayTweetComposer;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)displayMailComposer {
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self;
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"test@example.com"];
	
	[mailPicker setToRecipients:toRecipients];
	
    [self presentModalViewController:mailPicker animated:YES];
}

- (void)displayTweetComposer {
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    [tweetViewController setInitialText:@"@test "];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                // output = @"Tweet done.";
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
        NSURL *url = [NSURL URLWithString:@"http://www.test.com"];
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
			//message.text = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			//message.text = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			//message.text = @"Result: failed";
			break;
		default:
			//message.text = @"Result: not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
