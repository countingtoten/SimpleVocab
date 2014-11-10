//
//  FlashCardSelectViewController.h
//  SimpleVocab
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashCardSelectViewController;

@protocol FlashCardSelectViewControllerDelegate <NSObject>
- (void)flashCardSelectViewController:(FlashCardSelectViewController *)controller selectedListName:(NSString *)listName;
@end

@interface FlashCardSelectViewController : UITableViewController {
    NSMutableArray *listsWithWords;
}

@property (nonatomic) NSMutableArray *listsWithWords;

@property (nonatomic, weak) id <FlashCardSelectViewControllerDelegate> delegate;

@end
