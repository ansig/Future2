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
//  FCGraphPullMenuViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 08/10/2010.
//

#import <UIKit/UIKit.h>


#import "FCDatabaseHandler.h"
#import "FCCategory.h"

@interface FCGraphPullMenuViewController : UIViewController <FCGraphHandleViewDelegate, FCGroupedTableSourceDelegate> {

	FCGraphMenuMode mode;
	
	NSMutableArray *sectionTitles;
	NSMutableArray *sections;
	
	UITableView *tableView;
	
	UIButton *selectButton;
	UIButton *reorderButton;
	UIButton *optionsButton;
	UIButton *doneButton;
	
	NSMutableArray *selectedIndexPaths;
	NSMutableArray *storedSections;
	
	BOOL pendingChanges;
}

@property (nonatomic) FCGraphMenuMode mode;

@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sections;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIButton *selectButton;
@property (nonatomic, retain) UIButton *reorderButton;
@property (nonatomic, retain) UIButton *optionsButton;
@property (nonatomic, retain) UIButton *doneButton;

@property (nonatomic, retain) NSMutableArray *selectedIndexPaths;
@property (nonatomic, retain) NSMutableArray *storedSections;

@property (nonatomic) BOOL pendingChanges;

// View

-(void)loadDoneButtonForCurrentMode;
-(void)reloadVisibleRows;

// Notifications

-(void)onSwitchValueChanged;
-(void)onSegmentControlValueChanged;

// Custom

-(void)saveDefaultState;

-(void)loadNormalMode;

-(void)loadSelectionMode;
-(void)unloadSelectionMode;

-(void)loadGraphOptionsMode;
-(void)unloadGraphOptionsMode;

-(void)loadGeneralOptionsMode;
-(void)unloadGeneralOptionsMode;

-(void)loadReorderMode;
-(void)unloadReorderMode;

@end
