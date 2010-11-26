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
//  FCAppProfileInputViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/09/2010.
//

#import "FCAppProfileInputViewController.h"


@implementation FCAppProfileInputViewController

@synthesize cancelled;
@synthesize defaultItems;
@synthesize textView;
@synthesize label, datePicker, pickerView;

#pragma mark Init

-(id)initWithDefaultItems:(NSArray *)theDefaultItems {
	
	if (self = [super init]) {
		
		self.defaultItems = theDefaultItems;
	}
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[defaultItems release];
	
	[textView release];
	
	[label release];
	[datePicker release];
	[pickerView release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	[super loadView];
	
	// * Title
	NSArray *viewControllersInStack = [self.navigationController viewControllers];
	NSUInteger index = [viewControllersInStack indexOfObject:self];
	self.title = [[defaultItems objectAtIndex:index] objectForKey:@"Title"];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)createNewLabel {
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 24.0f)];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.textColor = [UIColor whiteColor];
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	self.label = newLabel;
	[newLabel release];
}

-(void)createNewPickerView {

	UIPickerView *newPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 216.0f)];
	newPickerView.showsSelectionIndicator = YES;
	newPickerView.delegate = self;
	newPickerView.dataSource = self;
	
	self.pickerView = newPickerView;
	[newPickerView release];
}

-(void)createCancelButton {
	
	UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = newButton;
}

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
	
	NSDictionary *item = [self defaultItem];
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	
	if (defaultKey == FCKeyCIDWeight)
		return 2;
	
	else if (defaultKey == FCDefaultProfileHeight && system != FCUnitSystemMetric)
		return 2;
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
	
	NSDictionary *item = [self defaultItem];
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	
	if (component == 0 && defaultKey == FCKeyCIDWeight) {
		
		// for weight
	
		FCCategory *weightCategory = [FCCategory categoryWithCID:FCKeyCIDWeight];
		
		FCUnit *targetUnit = system == FCUnitSystemMetric ? [FCUnit unitWithUID:FCKeyUIDKilogram] : [FCUnit unitWithUID:FCKeyUIDPound];
		FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:targetUnit];
		
		NSNumber *convertedNumber = [converter convertNumber:weightCategory.maximum withUnit:weightCategory.unit];
		
		[converter release];
		
		NSInteger integer = [convertedNumber integerValue];
		
		return integer - 1;
		
	} else if (defaultKey == FCDefaultProfileHeight) {
		
		// for height
		
		if (component == 0) {
			
			if (system == FCUnitSystemMetric)
				return 220; // centimetre
		
			return 7; // feet
		}
		
		return 12; // inches
	}
	
	return 10; // kilogram decimals
}

#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UILabel *aLabel;
	if (view == nil) {
		
		// * Create a new view
		UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
		newLabel.backgroundColor = [UIColor clearColor];
		newLabel.font = [UIFont boldSystemFontOfSize:24.0f];
		newLabel.textAlignment = UITextAlignmentCenter;
		
		aLabel = newLabel;
		[newLabel autorelease];
		
	} else {
		
		// * Reuse old view
		aLabel = (UILabel *)view;
	}
	
	NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
	
	NSDictionary *item = [self defaultItem];
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	
	if (defaultKey == FCKeyCIDWeight) {
	
		if (component == 0)
			aLabel.text = [NSString stringWithFormat:@"%d.", row];
			
		else
			aLabel.text = system == FCUnitSystemMetric ? [NSString stringWithFormat:@"%d kg", row] : [NSString stringWithFormat:@"%d lb", row];
	
	} else {
	
		if (component == 0)
			aLabel.text = system == FCUnitSystemMetric ? [NSString stringWithFormat:@"%d cm", row] : [NSString stringWithFormat:@"%d ft", row];
		
		else
			aLabel.text = [NSString stringWithFormat:@"%d in", row];
	}
	
	return aLabel;
}

#pragma mark FCAppOverlayViewController

-(void)createUIContent {
	
	// * Right button
	
	BOOL isLast = [self isLastInNavigationStack];
	
	NSString *rightButtonTitle = isLast ? @"Done" : @"Next";
	if (self.navigationItem.rightBarButtonItem == nil) {
		
		// create new button
		UIBarButtonItem *rightButton;
		if (isLast)
			rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
		
		else
			rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(next)];
		
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];
		
	} else {
		
		// update title
		self.navigationItem.rightBarButtonItem.title = rightButtonTitle;
	}
	
	// * UI elements
	
	NSDictionary *item = [self defaultItem];
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	
	if (defaultKey == FCKeyCIDWeight || defaultKey == FCDefaultProfileHeight) {
		
		[self createNewLabel];
		[self createNewPickerView];
		
	} else if (defaultKey == FCDefaultProfileDateOfBirth || defaultKey == FCDefaultProfileDiabetesDateDiagnosed) {
		
		// label
		
		[self createNewLabel];
		
		// date picker
		
		UIDatePicker *newDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 216.0f)];
		newDatePicker.datePickerMode = UIDatePickerModeDate;
		
		NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
		newDatePicker.maximumDate = now;
		[now release];
		
		self.datePicker = newDatePicker;
		[newDatePicker release];
		
	} else {
		
		// default: text view for strings
		
		UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 160.0f)];
		newTextView.backgroundColor = [UIColor clearColor];
		newTextView.font = [UIFont boldSystemFontOfSize:22.0f];
		newTextView.textColor = [UIColor whiteColor];
		newTextView.textAlignment = UITextAlignmentCenter;
						
		self.textView = newTextView;
		[newTextView release];
	}
}

-(void)presentUIContent {
	
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	if (self.label != nil)
		[self.view addSubview:self.label];
	
	if (self.textView != nil) {
		
		[self.view addSubview:self.textView];
		[self.textView becomeFirstResponder];
		[self updateUIContent];
		
	} else if (self.pickerView != nil) {
		
		// make transformation translation to put picker view off screen
		CGFloat verticalOffset = self.view.frame.size.height-self.pickerView.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		self.pickerView.transform = translation;
		
		// add the view
		[self.view addSubview:self.pickerView];
		
		// animate on screen
		[UIView animateWithDuration:kAppearDuration 
						 animations:^ { self.pickerView.transform = CGAffineTransformIdentity; } 
						 completion:^ (BOOL finished) { [self updateUIContent]; }];
	
	} else if (self.datePicker != nil) {
		
		// make transformation translation to put picker view off screen
		CGFloat verticalOffset = self.view.frame.size.height-self.datePicker.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		self.datePicker.transform = translation;
		
		// add the view
		[self.view addSubview:self.datePicker];
		
		// animate on screen
		[UIView animateWithDuration:kAppearDuration 
						 animations:^ { self.datePicker.transform = CGAffineTransformIdentity; }
						 completion:^ (BOOL finished) { [self updateUIContent]; }];
	}
}

-(void)updateUIContent {
	
	if (self.pickerView != nil) {
		
		[self createCancelButton];
		
		[self setPickerViewRows];
		
		id object = [self defaultObject];
		if ([object isKindOfClass:[FCEntry class]]) {
			
			FCEntry *lastWeightEntry = (FCEntry *)object;
			
			[self convertWeight:lastWeightEntry];
			
			self.label.text = lastWeightEntry.fullDescription;
			
		} else if ([object isKindOfClass:[NSNumber class]]) {
			
			NSNumber *number = (NSNumber *)object;
			
			NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
			if (system == FCUnitSystemMetric) {
				
				self.label.text = [NSString stringWithFormat:@"%d cm", [number integerValue]];
				
			} else {
			
				NSNumber *convertedNumber = [self convertHeight:number];
			
				NSInteger inches = (NSInteger)[convertedNumber doubleValue];
				NSInteger remainingInches = inches % 12;
				NSInteger feet = (NSInteger)inches / 12;
			
				self.label.text = [NSString stringWithFormat:@"%d ft %d in", feet, remainingInches];
			}
		}
		
	} else if (self.textView != nil) {
		
		id object = [self defaultObject];
		if ([object isKindOfClass:[NSString class]]) {
		
			NSString *string = (NSString *)object;
			self.textView.text = string;
		}
		
	} else if (self.datePicker != nil) {
		
		id object = [self defaultObject];
		if ([object isKindOfClass:[NSDate class]]) {
		
			NSDate *date = (NSDate *)object;
			[self.datePicker setDate:date];
			
			UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
			self.navigationItem.leftBarButtonItem = newButton;
			
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			formatter.dateStyle = NSDateFormatterMediumStyle;
			
			NSString *string = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
			
			[formatter release];
			
			self.label.text = string;
			
			[string release];
		
		} else {
		
			[self createCancelButton];
		}
	}
}

-(void)dismissUIContent {
	
	if (self.textView != nil) {
		
		[self.textView resignFirstResponder];
		[self.textView removeFromSuperview];
		
	} else if (self.pickerView != nil) {
		
		[self.label removeFromSuperview];
		
		// make transformation translation to put picker view
		CGFloat verticalOffset = self.view.frame.size.height-self.pickerView.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.pickerView.transform = translation; } 
						 completion:^ (BOOL finished) { [self.pickerView removeFromSuperview]; } ]; 
		
	} else if (self.datePicker != nil) {
		
		[self.label removeFromSuperview];
		
		// make transformation translation to put picker view
		CGFloat verticalOffset = self.view.frame.size.height-self.datePicker.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.datePicker.transform = translation; } 
						 completion:^ (BOOL finished) { [self.datePicker removeFromSuperview]; } ]; 
	}
}

-(void)dismiss {

	// * Update the user defaults
	[self updateUserDefaults];
	
	// * Super dismiss
	[super dismiss];
}

#pragma mark Custom

-(void)next {
	
}

-(void)cancel {
	
	// flag that cancel/remove has been pressed
	self.cancelled = YES;
	
	// update user defaults
	[self updateUserDefaults];
	
	[super dismiss];
}

-(void)updateUserDefaults {
	
	NSDictionary *item = [self defaultItem];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (self.textView != nil) {
		
		NSString *string = [(NSString *)self.textView.text copy];
		if ([string length] == 0)
			[defaults removeObjectForKey:[item objectForKey:@"DefaultKey"]];
		else
			[defaults setObject:string forKey:[item objectForKey:@"DefaultKey"]];
		
	} else if (self.datePicker != nil) {
		
		NSDate *date = [(NSDate *)self.datePicker.date copy];
		if (cancelled)
			[defaults removeObjectForKey:[item objectForKey:@"DefaultKey"]];
		else 
			[defaults setObject:date forKey:[item objectForKey:@"DefaultKey"]];
	
	} else if (self.pickerView != nil) {
	
		if (!cancelled) {
		
			NSDictionary *item = [self defaultItem];
			NSString *defaultKey = [item objectForKey:@"DefaultKey"];
			if (defaultKey == FCKeyCIDWeight) {
				
				// for localisation purposes, we need to get the decimal separator
				NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
				NSString *decimalSeparator = [formatter decimalSeparator];
				
				NSString *decimalAsString = [[NSString alloc] initWithFormat:@"%d%@%d", [self.pickerView selectedRowInComponent:0], decimalSeparator, [self.pickerView selectedRowInComponent:1]];
				NSNumber *newDecimal = [[NSNumber alloc] initWithDouble:[decimalAsString doubleValue]];
				
				[decimalAsString release];
				[formatter release];
				
				FCEntry *newWeightEntry = [FCEntry newEntryWithCID:FCKeyCIDWeight];
				
				NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
				FCUnit *targetUnit = system == FCUnitSystemMetric ? [FCUnit unitWithUID:FCKeyUIDKilogram] : [FCUnit unitWithUID:FCKeyUIDPound];
				newWeightEntry.uid = targetUnit.uid;
				
				newWeightEntry.decimal = newDecimal;
				
				[newWeightEntry save];
				
				[newDecimal release];
				
			} else {
				
				NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
				if (system == FCUnitSystemMetric) {
					
					NSNumber *newHeight = [NSNumber numberWithInteger:[self.pickerView selectedRowInComponent:0]];
					[defaults setObject:newHeight forKey:FCDefaultProfileHeight];
					
				} else {
					
					NSInteger feet = [self.pickerView selectedRowInComponent:0];
					NSInteger inches = [self.pickerView selectedRowInComponent:1];
					
					// find total number of inches
					
					FCUnit *targetUnit = [FCUnit unitWithUID:FCKeyUIDInch];
					FCUnitConverter *converterFeetToInches = [[FCUnitConverter alloc] initWithTarget:targetUnit];
					
					FCUnit *originUnit = [FCUnit unitWithUID:FCKeyUIDFoot];
					
					NSNumber *feetNumber = [[NSNumber alloc] initWithInteger:feet];
					NSNumber *convertedFeetNumber = [converterFeetToInches convertNumber:feetNumber withUnit:originUnit roundedToScale:0];
					[feetNumber release];
					
					NSInteger totalInches = [convertedFeetNumber integerValue] + inches;
					
					[converterFeetToInches release];
					
					// convert to centimetre
					
					targetUnit = [FCUnit unitWithUID:FCKeyUIDCentimetre];
					FCUnitConverter *converterInchToCentimetre = [[FCUnitConverter alloc] initWithTarget:targetUnit];
					
					originUnit = [FCUnit unitWithUID:FCKeyUIDInch];
					
					NSNumber *totalInchesNumber = [[NSNumber alloc] initWithInteger:totalInches];
					NSNumber *centimetre = [converterInchToCentimetre convertNumber:totalInchesNumber withUnit:originUnit roundedToScale:0];
					[totalInchesNumber release];
					
					// set user defaults
					
					[defaults setObject:centimetre forKey:FCDefaultProfileHeight];
					
					[converterInchToCentimetre release];
				}
			}
		}
	}
	
	// synchronise user defaults and send notification
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationUserDefaultsUpdated object:self];
}

-(NSNumber *)convertHeight:(NSNumber *)number {
	
	NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
	FCUnit *targetUnit = system == FCUnitSystemMetric ? [FCUnit unitWithUID:FCKeyUIDCentimetre] : [FCUnit unitWithUID:FCKeyUIDInch];
	FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:targetUnit];
	
	FCUnit *originUnit = [FCUnit unitWithUID:FCKeyUIDCentimetre];
	
	NSNumber *convertedHeight = [converter convertNumber:number withUnit:originUnit roundedToScale:0];
	
	[converter release];
	
	return convertedHeight;
}

-(void)convertWeight:(FCEntry *)entry {
	
	NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
	FCUnit *targetUnit = system == FCUnitSystemMetric ? [FCUnit unitWithUID:FCKeyUIDKilogram] : [FCUnit unitWithUID:FCKeyUIDPound];
	
	[entry convertToNewUnit:targetUnit];
}

-(void)setPickerViewRows {

	id object = [self defaultObject];
	
	if ([object isKindOfClass:[FCEntry class]]) {
		
		FCEntry *entry = (FCEntry *)object;
		
		[self convertWeight:entry];
		
		NSNumber *decimalNumber = entry.decimal;
		
		// set the number up in a number formatter to get correctly rounded number
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[formatter setMinimumFractionDigits:1];
		[formatter setMaximumFractionDigits:1];
		
		NSString *decimalNumberAsString = [[NSString alloc] initWithString:[formatter stringFromNumber:decimalNumber]];
		
		[formatter release];
		
		// get the integer and set the first component to that value
		
		[self.pickerView selectRow:[decimalNumberAsString intValue] inComponent:0 animated:YES];
		
		// get the fractional and set the second component to that value
		
		NSInteger digits = [decimalNumber countIntegralDigits];
		NSRange range = NSMakeRange(digits+1, 1);
		NSInteger fractional = [[decimalNumberAsString substringWithRange:range] integerValue];
		
		[decimalNumberAsString release];
		
		[self.pickerView selectRow:fractional inComponent:1 animated:YES];
		
	} else if ([object isKindOfClass:[NSNumber class]]) {
		
		NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
		if (system == FCUnitSystemMetric) {
			
			NSNumber *number = [object copy];
			NSInteger integer = [number integerValue];
			[number release];
			
			[self.pickerView selectRow:integer inComponent:0 animated:YES];
			
		} else {
		
			NSNumber *number = [object copy];
			NSNumber *decimalNumber = [self convertHeight:number];
			[number release];
			
			NSInteger inches = (NSInteger)[decimalNumber doubleValue];
			NSInteger remainingInches = inches % 12;
			NSInteger feet = (NSInteger)inches / 12;
			
			[self.pickerView selectRow:feet inComponent:0 animated:YES];
			[self.pickerView selectRow:remainingInches inComponent:1 animated:YES];
		}		
	}
}

-(NSDictionary *)defaultItem {
	
	NSUInteger index = [self indexInNavigationStack];
	NSDictionary *item = [self.defaultItems objectAtIndex:index];
	
	return item;
}

-(id)defaultObject {
	
	NSUInteger index = [self indexInNavigationStack];
	NSDictionary *item = [self.defaultItems objectAtIndex:index];
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	
	if (defaultKey == FCKeyCIDWeight) {
		
		FCEntry *lastWeightEntry = [FCEntry lastEntryWithCID:FCKeyCIDWeight];
		
		return lastWeightEntry;
	}
		
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id object = [defaults objectForKey:defaultKey];
	
	return object;
}

-(NSUInteger)indexInNavigationStack {

	NSArray *viewControllersInStack = [self.navigationController viewControllers];
	return [viewControllersInStack indexOfObject:self];	
}

-(BOOL)isLastInNavigationStack {
	
	NSUInteger lastIndex = [self.defaultItems count] - 1;
	
	if ([self indexInNavigationStack] == lastIndex) 
		return YES;
	
	return NO;
}

@end
