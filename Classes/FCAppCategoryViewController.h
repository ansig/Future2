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
//  FCAppCategoryViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 17/11/2010.
//

#import "FCAppOverlayViewController.h" // superclass


#import "FCModelsFramework.h"

@interface FCAppCategoryViewController : FCAppOverlayViewController <FCGroupedTableSourceDelegate, UITextFieldDelegate> {

	FCCategory *category;
	
	NSMutableArray *sections;
	
	UITableView *tableView;
	
	UITextField *nameTextField;
	UISwitch *countableSwitch;
	
	UITextField *minimumTextField;
	UITextField *maximumTextField;
	UISegmentedControl *decimalsSegmentedControl;
	UIButton *unitButton;
	
	BOOL beingEdited;
}

@property (nonatomic, retain) FCCategory *category;

@property (nonatomic, retain) NSMutableArray *sections;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UISwitch *countableSwitch;

@property (nonatomic, retain) UITextField *minimumTextField;
@property (nonatomic, retain) UITextField *maximumTextField;
@property (nonatomic, retain) UISegmentedControl *decimalsSegmentedControl;
@property (nonatomic, retain) UIButton *unitButton;

@property (nonatomic) BOOL beingEdited;

// Events

-(void)countableSwitchValueChanged;
-(void)unitButtonPressed;

// Custom

-(void)save;
-(void)cancel;

@end
