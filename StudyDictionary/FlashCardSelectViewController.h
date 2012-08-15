//
//  FlashCardSelectViewController.h
//  StudyDictionary
//
//  Created by James Weinert on 8/8/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "ListTemplateViewController.h"

@class FlashCardSelectViewController;
@class List;

@protocol FlashCardSelectViewControllerDelegate <NSObject>
- (void)flashCardSelectViewController:(FlashCardSelectViewController *)controller selectedList:(List *)listForCards;
@end

@interface FlashCardSelectViewController : ListTemplateViewController

@property (weak, nonatomic) id <FlashCardSelectViewControllerDelegate> delegate;

@end
