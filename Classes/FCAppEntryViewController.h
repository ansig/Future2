/*
 
 TiY (tm) - an adaptable iPhone application for self-management of type 1 diabetes
 Copyright (C) 2010  Anders Sigfridsson
 
 TiY (tm) is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TiY (tm) is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TiY (tm).  If not, see <http://www.gnu.org/licenses/>.
 
 */

//
//  FCAppEntryViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 16/09/2010.
//

#import <UIKit/UIKit.h>


#import "FCAppCustomViewController.h"
#import "FCEntry.h"
#import "FCCategory.h"
#import "FCUnit.h"

@interface FCAppEntryViewController : FCAppCustomViewController {
	
	UIImageView *iconImageView;
	UILabel *timestampLabel;
	UILabel *numberLabel;
	UITextView *textView;
	UILabel *unitLabel;
}

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *unitLabel;

// Custom

-(void)createContentForCreatingNewEntry;
-(void)createContentForAddingAttachments;

-(void)showContentForAddingAttachments;

-(void)setContentsForUIElements;

-(void)save;

@end
