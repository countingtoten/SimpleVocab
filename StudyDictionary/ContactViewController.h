//
//  AboutViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 8/15/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import <UIKit/UIKit.h>

@interface ContactViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    
}

@property (nonatomic) IBOutlet UITableViewCell *emailCell;
@property (nonatomic) IBOutlet UITableViewCell *twitterCell;

@end
