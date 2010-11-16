/*
 
 TiY (tm) - an adaptable iPhone application for self-management of type 1 diabetes
 Copyright (C) 2010  Anders Sigfridsson
 
 TiY (tm) is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TiY (tm) is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See  the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TiY (tm).  If not, see <http://www.gnu.org/licenses/>.
 
 */  

//
//  FCAppEntryAttachmentsView.h
//  Future2
//
//  Created by Anders Sigfridsson on 12/11/2010.
//

#import "FCModelsFramework.h"

@interface FCAppEntryAttachmentsView : UIScrollView <UITableViewDataSource> {

	id tableViewDelegate;
	
	FCEntry *entryRef;

	NSMutableArray *attachmentButtons;
	UILabel *noAttachmentsLabel;
	
	UITableView *tableView;
	NSInteger sections;
	NSInteger rows;
	
	NSInteger selectedIndex;
	NSInteger previouslySelectedIndex;
}

@property (assign) id tableViewDelegate;

@property (assign) FCEntry *entryRef;

@property (nonatomic, retain) NSMutableArray *attachmentButtons;
@property (nonatomic, retain) UILabel *noAttachmentsLabel;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic) NSInteger sections;
@property (nonatomic) NSInteger rows;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger previouslySelectedIndex;

// Init

-(id)initWithEntry:(FCEntry *)anEntry frame:(CGRect)frame;

// Events

-(void)buttonClicked:(UIButton *)theButton;

// Get

-(FCEntry *)getSelectedAttachment;

// Custom

-(void)loadAttachments;
-(void)updateTableView;

@end
