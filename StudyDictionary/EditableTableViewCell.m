//
//  EditableTableViewCell.m
//  StudyDictionary
//
//  Created by James Weinert on 6/13/12.
//  Copyright (c) 2012 Weinert Works. All rights reserved.
//

#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

@synthesize textField;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	textField.enabled = editing;
}

@end
