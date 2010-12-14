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
//  FCAppTagsViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppViewController.h" // superclass


#import <QuartzCore/QuartzCore.h>

#import "FCModelsFramework.h"
#import "FCIOFramework.h"
#import "FCFunctionsFramework.h"

#import "FCAppCategoryViewController.h"

@interface FCAppTagsViewController : FCAppViewController <FCPlainTableSourceDelegate, FCCategoryList, UIActionSheetDelegate> {

	NSMutableArray *section;
	UITableView *tableView;
	NSIndexPath *deleteIndexPath;
}

@property (nonatomic, retain) NSMutableArray *section;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSIndexPath *deleteIndexPath;

// View

-(void)loadNewCategoryViewController;

// Events

-(void)editButtonPressed:(UIButton *)theEditButton;

// Custom

-(void)purgeDefaultGraphSetsWithCID:(NSString *)theCID;

@end
