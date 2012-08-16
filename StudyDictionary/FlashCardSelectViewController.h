//
//  FlashCardSelectViewController.h
//  StudyDictionary
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

@property (strong, nonatomic) NSMutableArray *listsWithWords;

@property (weak, nonatomic) id <FlashCardSelectViewControllerDelegate> delegate;

@end
