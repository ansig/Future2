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
//  FCAppNewEntryViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 28/10/2010.
//

#import "FCAppNewEntryViewController.h"


@implementation FCAppNewEntryViewController

@synthesize category, originalEntry, owner;
@synthesize timestampButton, unitButton;
@synthesize pickerView;

#pragma mark Init

-(id)initWithCategory:(FCCategory *)theCategory {
	
	if (self = [super init]) {
		
		category = [theCategory retain];
		
		entry = [[FCEntry newEntryWithCID:theCategory.cid] retain];
		
		NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
		entry.timestamp = now;
		[now release];
	}
	
	return self;
}

-(id)initWithCategory:(FCCategory *)theCategory owner:(FCEntry *)theOwner {
	
	if (self = [self initWithCategory:theCategory]) {
		
		owner = [theOwner retain];
	}
	
	return self;
}

-(id)initWithEntry:(FCEntry *)theEntry {
	
	if (self = [super init]) {
		
		originalEntry = [theEntry retain];
		entry = [theEntry copy];
		category = [theEntry.category retain];
	}
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[category release];
	[originalEntry release];
	[owner release];
	
	[timestampButton release];
	[unitButton release];
	
	[pickerView release];
	
    [super dealloc];
}

#pragma mark View

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	[super loadView];
}
*/

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)loadTimestampSelectorViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryObjectUpdatedNotification) name:FCNotificationEntryObjectUpdated object:nil];
	
	// update the entry's value (retains whatever is currently selected through the update)
	[self setEntryValue];
	
	// hide keyboard
	if (self.textView != nil)
		[self.textView resignFirstResponder];
	
	// create and present a new selector view controller
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = @"Date & time";
	 
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadUnitSelectorViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryObjectUpdatedNotification) name:FCNotificationEntryObjectUpdated object:nil];
	
	// update the entry's value (retains whatever is currently selected through the update)
	[self setEntryValue];
	
	// create and present a new selector view controller
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = [NSString stringWithFormat:@"%@ unit", self.category.name];
	selectorViewController.system = self.entry.unit.system;
	selectorViewController.quantity = self.entry.unit.quantity;
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadEntryViewControllerWithEntry:(FCEntry *)anEntry {

	// load the last created entry
	FCEntry *newEntry = [FCEntry lastEntryWithCID:self.entry.cid];
	
	// create an entry view controller and transition to it
	FCAppEntryViewController *entryViewController = [[FCAppEntryViewController alloc] initWithEntry:newEntry];
	entryViewController.navigationControllerFadesInOut = YES;
	entryViewController.isOpaque = YES;
	entryViewController.title = newEntry.category.name;
	
	[self transitionTo:entryViewController];
	
	[entryViewController release];
}

-(void)loadCameraViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryObjectUpdatedNotification) name:FCNotificationEntryObjectUpdated object:nil];
	
	// call up camera
	FCAppCameraViewController *cameraController = [[FCAppCameraViewController alloc] initWithEntry:self.entry];
	[self presentModalViewController:cameraController animated:YES];
	
	[cameraController release];
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

	// for decimal numbers
	
	if ([self.category.datatype isEqualToString:@"decimal"]) {
		
		NSInteger decimals = [self.category.decimals integerValue];
		
		return decimals + 1; // plus one to include integer
	}
	
	// for integers
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	// the decimal
	if (component == 1)
		return 10;
	
	// the integer
	return [self.entry.category.maximum integerValue];
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
	
	NSString *text;
	if (component < 1 && self.pickerView.numberOfComponents > 1) {
		
		// fractionals
		
		// for localisation purposes, we need to get the decimal separator
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSString *decimalSeparator = [formatter decimalSeparator];
		
		text = [[NSString alloc] initWithFormat:@"%d%@", row, decimalSeparator];
		
		[formatter release];
	
	} else {
		
		// integer
		
		NSInteger integer = [self.category.minimum integerValue] + row;
		text = [[NSString alloc] initWithFormat:@"%d", integer];
	}
	
	aLabel.text = text;
	[text release];
	
	return aLabel;
}

#pragma mark FCEntryView

-(void)onEntryObjectUpdatedNotification {
	
	// show keyboard
	if (self.textView != nil)
		[self.textView becomeFirstResponder];
	
	// update category's unit (only executes if applicable)
	[self.category saveNewUnit:self.entry.unit andConvert:YES];
	
	// update UI content
	[self updateUIContent];
	
	// stop listening to notifications about entry updates
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationEntryObjectUpdated object:nil];
}

-(void)save {
	
	// update entry's value
	[self setEntryValue];
	
	if (self.originalEntry != nil) {
		
		// save the ORIGINAL entry
		
		[self.originalEntry copyEntry:entry];
		
		[self.originalEntry save];
		
		// update category's unit (only executes if applicable)
		[self.category saveNewUnit:self.originalEntry.unit andConvert:YES];
		
		// dismiss
		[super dismiss];
		
	} else {
		
		// save entry
		[self.entry save];
		
		// load an entry view controller for the new entry
		[self loadEntryViewControllerWithEntry:self.entry];
	}
}

#pragma mark FCAppOverlayViewController

-(void)createUIContent {
/*	Creates all UI elements necessary for creating a new entry of the given category. */
	
	// navigation bar buttons
	
	// * Left button
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = newLeftButton;
	[newLeftButton release];
	
	// * Right button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Timestamp label and edit button
	
	NSString *timestampText = self.entry.timestampDescription;
	
	CGSize sizeForText = [timestampText sizeWithFont:kAppBoldCommonLabelFont];
	
	CGFloat yAnchor = 35.0f;
	CGFloat xAnchor = 160.0f;
	
	CGFloat labelWidth = sizeForText.width;
	CGFloat labelHeight = sizeForText.height;
	
	CGFloat buttonWidth = 30.0f; // (same size as buttonImage.png)
	CGFloat buttonHeight = 30.0f;
	
	CGFloat labelXPosition = xAnchor - (labelWidth/2);
	CGFloat labelYPosition = yAnchor - (labelHeight/2);
	
	CGFloat buttonXPosition = labelXPosition + labelWidth + kAppLabelSpacing;
	CGFloat buttonYPosition = yAnchor - (buttonHeight/2);
	
	UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, labelYPosition, labelWidth, labelHeight)];
	newTimestampLabel.backgroundColor = [UIColor clearColor];
	newTimestampLabel.textColor = [UIColor whiteColor];
	newTimestampLabel.textAlignment = UITextAlignmentCenter;
	newTimestampLabel.font = kAppBoldCommonLabelFont;
	
	newTimestampLabel.text = timestampText;
	
	self.timestampLabel = newTimestampLabel;
	
	[newTimestampLabel release];
	
	UIButton *newTimestampButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	[newTimestampButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
	
	newTimestampButton.frame = CGRectMake(buttonXPosition, buttonYPosition, buttonWidth, buttonHeight);
	
	[newTimestampButton addTarget:self action:@selector(loadTimestampSelectorViewController) forControlEvents:UIControlEventTouchUpInside];
	
	self.timestampButton = newTimestampButton;
	
	// * Input views and controllers
	
	// picker view
	NSString *datatype = self.category.datatype;
	if ([datatype isEqualToString:@"integer"] || [datatype isEqualToString:@"decimal"]) {
		
		UIPickerView *newPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, kEntryHeaderHeight, 320.0f, 216.0f)];
		newPickerView.delegate = self;
		newPickerView.dataSource = self;
		
		newPickerView.showsSelectionIndicator = YES;
		
		self.pickerView = newPickerView;
		
		[newPickerView release];
	
		// unit label and edit button
		
		if (self.category.uid != nil) {
			
			FCUnit *unit = self.entry.unit;
			NSString *text = unit.abbreviation;
			
			CGSize sizeForText = [text sizeWithFont:kAppBoldCommonLabelFont];
		
			CGFloat yAnchor = 325.0f;
			CGFloat xAnchor = 160.0f;
			
			CGFloat labelWidth = sizeForText.width;
			CGFloat labelHeight = sizeForText.height;
			
			CGFloat buttonWidth = 30.0f; // (same size as buttonImage.png)
			CGFloat buttonHeight = 30.0f;
			
			CGFloat labelXPosition = xAnchor - (labelWidth/2);
			CGFloat labelYPosition = yAnchor - (labelHeight/2);
			
			CGFloat buttonXPosition = labelXPosition + labelWidth + kAppLabelSpacing;
			CGFloat buttonYPosition = yAnchor - (buttonHeight/2);
			
			UILabel *newUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, labelYPosition, labelWidth, labelHeight)];
			newUnitLabel.backgroundColor = [UIColor clearColor];
			newUnitLabel.textColor = [UIColor whiteColor];
			newUnitLabel.textAlignment = UITextAlignmentCenter;
			newUnitLabel.font = kAppBoldCommonLabelFont;
			
			newUnitLabel.text = text;
			
			self.unitLabel = newUnitLabel;
			
			[newUnitLabel release];
			
			UIButton *newUnitButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[newUnitButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
			
			newUnitButton.frame = CGRectMake(buttonXPosition, buttonYPosition, buttonWidth, buttonHeight);
			
			[newUnitButton addTarget:self action:@selector(loadUnitSelectorViewController) forControlEvents:UIControlEventTouchUpInside];
			
			self.unitButton = newUnitButton;
		
		} 
	
	} else if ([datatype isEqualToString:@"string"]) {
		
		CGFloat height = self.view.frame.size.height - kEntryHeaderHeight - 216.0f; // (216.0f = standard keyboard height)
		UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, kEntryHeaderHeight, 320.0f, height)];
		newTextView.backgroundColor = [UIColor clearColor];
		newTextView.textColor = [UIColor whiteColor];
		newTextView.font = [UIFont boldSystemFontOfSize:16.0f];
		
		self.textView = newTextView;
		[newTextView release];
	
	} else if ([datatype isEqualToString:@"photo"]) {
	
		UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, kEntryHeaderHeight, 320.0f, 320.0f)];
		
		self.imageView = newImageView;
		
		[newImageView release];
	}
}

-(void)updateUIContent {
	
	// * timestamp label/button
	
	if (self.entry.timestamp == nil) {
		
		// make a new timestamp for now
		NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
		self.entry.timestamp = now;
		[now release];
	}
	
	// new text
	
	NSString *newTimestamp = self.entry.timestampDescription;
	
	self.timestampLabel.text = newTimestamp;
	
	CGSize sizeForText = [newTimestamp sizeWithFont:kAppBoldCommonLabelFont];
	
	// resize label
	
	CGPoint center = self.timestampLabel.center;
	
	CGRect oldFrame = self.timestampLabel.frame;
	
	CGFloat newXPos = center.x - (sizeForText.width/2);		// using this calculation instead of simply setting new center to the old one
	CGFloat newYPos = center.y - (sizeForText.height/2);	// because that would for some reason be 7 points off every second try... /Anders
	
	CGRect newFrame = CGRectMake(newXPos, newYPos, sizeForText.width, sizeForText.height);
	
	self.timestampLabel.frame = newFrame;
	
	// move edit button
	
	oldFrame = self.timestampButton.frame;
	newXPos = self.timestampLabel.frame.origin.x + self.timestampLabel.frame.size.width + kAppLabelSpacing;
	self.timestampButton.frame = CGRectMake(newXPos, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
	
	if (self.unitLabel != nil && self.unitButton != nil) {
	
		// * unit label/button
		
		// new text
		
		NSString *newAbbreviation = self.entry.unit.abbreviation;
		
		self.unitLabel.text = newAbbreviation;
		
		CGSize sizeForText = [newAbbreviation sizeWithFont:kAppBoldCommonLabelFont];
		
		// resize label
		
		CGPoint center = self.unitLabel.center;
		
		CGRect oldFrame = self.unitLabel.frame;
		
		CGFloat newXPos = center.x - (sizeForText.width/2);		// using this calculation instead of simply setting new center to the old one
		CGFloat newYPos = center.y - (sizeForText.height/2);	// because that would for some reason be 7 points off every second try... /Anders
		
		CGRect newFrame = CGRectMake(newXPos, newYPos, sizeForText.width, sizeForText.height);
		
		self.unitLabel.frame = newFrame;
		
		// move edit button
		
		oldFrame = self.unitButton.frame;
		newXPos = self.unitLabel.frame.origin.x + self.unitLabel.frame.size.width + kAppLabelSpacing;
		self.unitButton.frame = CGRectMake(newXPos, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
	}
	
	// * Picker rows
	
	if (self.pickerView != nil) {
	
		[self.pickerView reloadAllComponents];
		[self performSelector:@selector(setPickerViewRows) withObject:nil afterDelay:kPerceptionDelay];
	
	// * Image view
	
	} else if (self.imageView != nil) {
		
		UIImage *image = [UIImage imageNamed:self.entry.string];
		self.imageView.image = image;
	}
}

-(void)dismissUIContent {

	// remove timestamp label and button
	[self.timestampLabel removeFromSuperview];
	[self.timestampButton removeFromSuperview];
	
	// picker view and unit label/button
	if (self.pickerView != nil) {
	
		// make transformation translation to put picker view and unit label/button off screen
		CGFloat verticalOffset = self.view.frame.size.height-self.pickerView.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.pickerView.transform = translation; } 
						 completion:^ (BOOL finished) { [self.pickerView removeFromSuperview]; } ]; 
		
		if (self.unitLabel != nil && self.unitButton != nil) {
			
			[UIView animateWithDuration:kDisappearDuration 
							 animations:^ { self.unitLabel.transform = translation; }
							 completion:^ (BOOL finished) { [self.unitLabel removeFromSuperview]; } ];
			
			[UIView animateWithDuration:kDisappearDuration 
							 animations:^ { self.unitButton.transform = translation; }
							 completion:^ (BOOL finished) { [self.unitButton removeFromSuperview]; } ];
		}
	
	} else if (self.textView != nil) {
	
		[self.textView resignFirstResponder];
		[self.textView removeFromSuperview];
	
	} else if (self.imageView != nil) {
	
		[self.imageView removeFromSuperview];
	}
}

-(void)presentUIContent {
	
	// show timestamp label and button
	[self.view addSubview:self.timestampLabel];
	[self.view addSubview:self.timestampButton];
	
	// show navigation bar
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// picker view and unit label
	if (self.pickerView != nil) {
	
		// make transformation translation to put picker view off screen
		CGFloat verticalOffset = self.view.frame.size.height-self.pickerView.frame.origin.y;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		self.pickerView.transform = translation;
		
		// add the view
		[self.view addSubview:self.pickerView];
		
		// animate on screen
		[UIView animateWithDuration:kAppearDuration 
						 animations:^ { self.pickerView.transform = CGAffineTransformIdentity; } 
						 completion:^ (BOOL finished) { [self setPickerViewRows]; }];
		
		if (self.unitLabel != nil && self.unitButton != nil) {
			
			self.unitLabel.transform = translation;
			
			[self.view addSubview:self.unitLabel];
			
			[UIView animateWithDuration:kAppearDuration 
							 animations:^ { self.unitLabel.transform = CGAffineTransformIdentity; } ];
			
			self.unitButton.transform = translation;
			
			[self.view addSubview:self.unitButton];
			
			[UIView animateWithDuration:kAppearDuration 
							 animations:^ { self.unitButton.transform = CGAffineTransformIdentity; } ];
		}
	
	} else if (self.textView != nil) {
	
		self.textView.text = self.entry.string;
		
		[self.view addSubview:self.textView];
		[self.textView becomeFirstResponder];
	
	} else if (self.imageView != nil) {
	
		[self performSelector:@selector(loadCameraViewController) withObject:nil afterDelay:kPerceptionDelay];
	}
}

#pragma mark Custom

-(void)cancel {
	
	// make sure category's unit is equal to original entry's unit
	// (only executes if applicable)
	if (self.originalEntry != nil)
		[self.category saveNewUnit:self.originalEntry.unit andConvert:YES];
	
	[super dismiss];
}
													 
-(void)setPickerViewRows {
/*	Selects the correct rows in the picker view if applicable. */
	
	if (self.pickerView != nil) {
		
		FCEntry *anEntry;
	
		// use the existing entry
		if (self.entry.integer != nil || self.entry.decimal != nil)
			anEntry = self.entry;
		
		// use last entry of category
		else
			anEntry = [FCEntry lastEntryWithCID:self.category.cid];
		
		if (anEntry.integer != nil) {
			
			// integer
			NSInteger integer = [anEntry.integer integerValue] - [self.category.minimum integerValue];
			[self.pickerView selectRow:integer inComponent:0 animated:YES];
			
		} else if (anEntry.decimal != nil) {
			
			// the decimal number
			
			NSNumber *decimalNumber = anEntry.decimal;
			
			// use a number formatter to get correctly rounded number
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			
			NSInteger digits = [decimalNumber countIntegralDigits];
			NSInteger decimals = [self.category.decimals integerValue];
			
			[formatter setMinimumFractionDigits:decimals];
			[formatter setMaximumFractionDigits:decimals];
			
			NSString *decimalNumberAsString = [[NSString alloc] initWithString:[formatter stringFromNumber:decimalNumber]];
			
			[formatter release];
			
			// get the integer and set the first component to that value
			
			NSInteger integer = [decimalNumberAsString integerValue] - [self.category.minimum integerValue];
			[self.pickerView selectRow:integer inComponent:0 animated:YES];
			
			// get the fractionals and set each remaining component accordingly
			
			for (int i = 1; i <= decimals; i++) {
			
				NSRange range = NSMakeRange(digits+i, 1);
				NSInteger fractional = [[decimalNumberAsString substringWithRange:range] integerValue];
				
				[self.pickerView selectRow:fractional inComponent:i animated:YES];
			}
			
			[decimalNumberAsString release];
		}
	}
}

-(void)setEntryValue {
/*	Sets correct numerical value of the entry to the currently selected rows in the pickerview. */
	
	if (self.pickerView != nil) {
	
		// integer 
		NSInteger integer = [self.category.minimum integerValue] + [self.pickerView selectedRowInComponent:0];
		
		// initial string value
		NSString *stringValue = [[NSString alloc] initWithFormat:@"%d", integer];
		
		if ([self.category.datatype isEqualToString:@"decimal"]) {
			
			// add decimal separator (localised)
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			NSString *decimalSeparator = [formatter decimalSeparator];
			[formatter release];
			
			NSString *oldStringValue = stringValue;
			stringValue = [[NSString alloc] initWithFormat:@"%@%@", oldStringValue, decimalSeparator];
			[oldStringValue release];
			
			// add each fractional
			NSInteger decimals = [self.category.decimals integerValue];
			for (int i = 1; i <= decimals; i++) {
				
				NSInteger fractional = [self.pickerView selectedRowInComponent:i];
				
				oldStringValue = stringValue;
				stringValue = [[NSString alloc] initWithFormat:@"%@%d", oldStringValue, fractional];
				[oldStringValue release];
			}
			
			// set decimal
			
			NSNumber *decimalNumber = [[NSNumber alloc] initWithDouble:[stringValue doubleValue]];
			self.entry.decimal = decimalNumber;
			[decimalNumber release];
			
		} else {
			
			// set integer
			
			NSNumber *integerNumber = [[NSNumber alloc] initWithInteger:[stringValue integerValue]];
			self.entry.integer = integerNumber;
			[integerNumber release];
		}
		
		[stringValue release];
		
	} else if (self.textView != nil) {
	
		self.entry.string = self.textView.text;
	}
}

@end
