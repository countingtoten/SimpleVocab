//
//  EditableTableViewCell.h
//  SimpleVocab
//
//  Created by James Weinert on 6/13/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditableTableViewCell : UITableViewCell {
    UITextField *textField;
}

@property (nonatomic) IBOutlet UITextField *textField;

@end
