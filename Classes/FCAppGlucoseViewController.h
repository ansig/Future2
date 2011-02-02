/*
 
 TiY (tm) - an iPhone app that supports self-management of type 1 diabetes
 Copyright (C) 2010  Interaction Design Centre (University of Limerick, Ireland)
 
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
//  FCAppGlucoseViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//


#import "FCAppViewController.h" // superclass

#import "FCModelsFramework.h"
#import "FCFunctionsFramework.h"

#import "FCAppPropertySelectorViewController.h"
#import "FCAppEntryViewController.h"

@interface FCAppGlucoseViewController : FCAppViewController <UIPickerViewDataSource, UIPickerViewDelegate, FCEntryView> {

	FCEntry *entry;
	
	UIPickerView *pickerView;
	
	UILabel *timestampLabel;
	UIButton *timestampButton;
	
	UILabel *unitLabel;
	UIButton *unitButton;
	
	NSTimer *_timer;
}

@property (nonatomic, retain) FCEntry *entry;

@property (nonatomic, retain) UIPickerView *pickerView;

@property (nonatomic, retain) UILabel *timestampLabel;
@property (nonatomic, retain) UIButton *timestampButton;

@property (nonatomic, retain) UILabel *unitLabel;
@property (nonatomic, retain) UIButton *unitButton;


// View

-(void)loadEntryViewController;
-(void)loadTimestampSelectionViewController;
-(void)loadUnitSelectionViewController;

// Custom

-(void)updateTimestampLabel;
-(void)updateUnitLabel;

-(void)setPickerRows;
-(void)setEntryProperties;

-(void)startTimer;
-(void)stopTimer;

// Notifications

-(void)onEntryCreatedNotification;

@end
