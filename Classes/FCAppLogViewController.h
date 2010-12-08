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
//  FCAppLogViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//


#import "FCAppViewController.h" // superclass

#import "FCAppLogDateSelectorViewController.h"
#import "FCAppEntryViewController.h"

@interface FCAppLogViewController : FCAppViewController <FCGroupedTableSourceDelegate, FCEntryList, UIActionSheetDelegate> {

	NSDate *startDate;
	NSDate *endDate;
	
	UITableView *tableView;
	
	NSMutableArray *sectionTitles;
	NSMutableArray *sections;
}

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sections;

// View

-(void)loadDateSelectorViewController;
-(void)loadSortByActionSheet;

// Notifications

-(void)onLogDateChangedNotification;
-(void)onConvertLogOrUnitChange;

// Custom

-(NSDictionary *)sectionsAndRowsSortedByDate;
-(NSDictionary *)sectionsAndRowsSortedByCategory;
-(NSDictionary *)sectionsAndRowsSortedByAttachment;

@end
