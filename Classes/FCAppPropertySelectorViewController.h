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
//  FCAppPropertySelectorViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 13/09/2010.
//


#import "FCAppOverlayViewController.h"  // superclass


#import "FCModelsFramework.h"
#import "FCFunctionsFramework.h"

@interface FCAppPropertySelectorViewController : FCAppOverlayViewController <FCGroupedTableSourceDelegate> {

	FCEntry *entry;
	FCCategory *category;
	
	FCProperty propertyToSelect;
	
	// timestamp
	UILabel *timestampLabel;
	UIDatePicker *datePicker;
	
	// unit
	UITableView *tableView;
	NSMutableArray *rows;
	
	FCUnitQuantity quantity;
	FCUnitSystem system;
}

@property (nonatomic, retain) FCEntry *entry;
@property (nonatomic, retain) FCCategory *category;

@property (nonatomic) FCProperty propertyToSelect;

@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UIDatePicker *datePicker;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *rows;

@property (nonatomic) FCUnitQuantity quantity;
@property (nonatomic) FCUnitSystem system;

// Init

-(id)initWithEntry:(FCEntry *)theEntry;
-(id)initWithCategory:(FCCategory *)theCategory;

// View

-(void)pushUnitSystemSelectionViewController;
-(void)pushUnitSelectionViewController;

// Animation

-(void)animateTableViewAppearance;

// Custom

-(void)save;
-(void)cancel;

-(void)createContentForTimestampSelection;
-(void)createContentForUnitSelection;
-(void)createContentForUnitQuantitySelection;
-(void)createContentForUnitSystemSelection;
-(void)createContentForIconSelection;
-(void)createContentForColorSelection;

-(void)presentContentForTimestampSelection;

-(void)createTableView;

@end
