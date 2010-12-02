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
//  FCAppNewEntryViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 28/10/2010.
//


#import "FCAppEntryViewController.h"  // superclass

#import "FCAppPropertySelectorViewController.h"
#import "FCAppCameraViewController.h"

@interface FCAppNewEntryViewController : FCAppEntryViewController <UIPickerViewDataSource, UIPickerViewDelegate> {

	FCCategory *category;
	FCEntry *originalEntry;
	FCEntry *owner;
	
	UIButton *timestampButton;
	UIButton *unitButton;
	
	UIPickerView *pickerView;
	
	UIActivityIndicatorView *activityIndicator;
	UILabel *statusLabel;
}

@property (nonatomic, retain) FCCategory *category;
@property (nonatomic, retain) FCEntry *originalEntry;
@property (nonatomic, retain) FCEntry *owner;

@property (nonatomic, retain) UIButton *timestampButton;
@property (nonatomic, retain) UIButton *unitButton;

@property (nonatomic, retain) UIPickerView *pickerView;

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *statusLabel;

// Init

-(id)initWithCategory:(FCCategory *)theCategory;
-(id)initWithCategory:(FCCategory *)theCategory owner:(FCEntry *)theOwner;

// View

-(void)loadTimestampSelectorViewController;
-(void)loadUnitSelectorViewController;
-(void)loadEntryViewControllerWithEntry:(FCEntry *)anEntry;
-(void)loadCameraViewController;
-(void)pushUnitSelectionViewController;

// Events

-(void)imageButtonPressed;

// Custom

-(void)cancel;
-(void)setPickerViewRows;
-(void)setEntryProperties;

-(void)createImageButton;
-(void)createImageView;
-(void)createActivityIndicatorAndStatusLabel;

@end
