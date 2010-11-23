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


#import "FCAppOverlayViewController.h"  // superclass


#import "FCAppEntryAttachmentsView.h"
#import "TKGlobal.h"
#import "FCModelsFramework.h"

@interface FCAppEntryViewController : FCAppOverlayViewController <FCEntryView, FCGroupedTableSourceDelegate, UIScrollViewDelegate> {
	
	FCEntry *entry;
	
	UIImageView *iconImageView;
	
	UILabel *timestampLabel;
	
	UIButton *editButton;
	
	UILabel *numberLabel;
	UILabel *unitLabel;
	
	UITextView *textView;
	
	UIButton *imageButton;
	UIScrollView *scrollView;
	UIImageView *imageView;
	UIButton *closeButton;
	
	FCAppEntryAttachmentsView *attachmentsView;
	
	UITableView *tableView;
	NSMutableArray *sectionTitles;
	NSMutableArray *sections;
}

@property (nonatomic, retain) FCEntry *entry;

@property (nonatomic, retain) UIImageView *iconImageView;

@property (nonatomic, retain) UIButton *editButton;

@property (nonatomic, retain) UILabel *timestampLabel;

@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, retain) UILabel *unitLabel;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *closeButton;

@property (nonatomic, retain) FCAppEntryAttachmentsView *attachmentsView;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sections;

// Init

-(id)initWithEntry:(FCEntry *)theEntry;

// View

-(void)loadNewEntryViewController;

-(void)loadScrollViewForImage;
-(void)unloadScrollViewForImage;

// Custom

-(void)save;

-(void)createAndDisplayCloseButton;
-(void)setNewFrameForTableView;
-(void)scrollToTop;

@end
