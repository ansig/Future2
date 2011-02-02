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
//  FCAppProfileInputViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 01/09/2010.
//


#import "FCAppOverlayViewController.h"  // superclass

#import "FCModelsFramework.h"
#import "FCFunctionsFramework.h"

@interface FCAppProfileInputViewController : FCAppOverlayViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

	BOOL cancelled;
	
	NSArray *defaultItems;
	
	UITextView *textView;
	
	UILabel *label;
	UIDatePicker *datePicker;
	UIPickerView *pickerView;
}

@property (nonatomic) BOOL cancelled;

@property (nonatomic, retain) NSArray *defaultItems;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *pickerView;

// Init

-(id)initWithDefaultItems:(NSArray *)theDefaultItems;

// View

-(void)createNewLabel;
-(void)createNewPickerView;
-(void)createCancelButton;

// Custom

-(void)cancel;
-(void)next;

-(void)updateUserDefaults;

-(NSNumber *)convertHeight:(NSNumber *)number;
-(void)convertWeight:(FCEntry *)entry;

-(void)setPickerViewRows;

-(NSDictionary *)defaultItem;
-(id)defaultObject;
-(NSUInteger)indexInNavigationStack;
-(BOOL)isLastInNavigationStack;

@end
