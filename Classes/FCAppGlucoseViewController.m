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
//  FCAppGlucoseViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppGlucoseViewController.h"


@implementation FCAppGlucoseViewController

@synthesize entry;
@synthesize pickerView;
@synthesize timestampLabel, timestampButton;
@synthesize unitLabel, unitButton;

#pragma mark Init

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
	
	[entry release];
	
	[pickerView release];
	
	[timestampLabel release];
	[timestampButton release];
	
	[unitLabel release];
	[unitButton release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppGlucoseViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// * Picker view
	UIPickerView *newPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 75.0f, 320.0f, 216.0f)];
	newPickerView.delegate = self;
	newPickerView.showsSelectionIndicator = YES;
	newPickerView.dataSource = self;
	
	self.pickerView = newPickerView;
	[self.view addSubview:newPickerView];
	
	[newPickerView release];
	
	// * Right navigation bar button
	UIBarButtonItem *newBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(loadEntryViewController)];
	self.navigationItem.rightBarButtonItem = newBarButton;
	[newBarButton release];
	
	// * Initial data
	
	// get the last made glucose entry or create a new entry altogether to use as template
	self.entry = [FCEntry lastEntryWithCID:FCKeyCIDGlucose];
	
	if (self.entry == nil)
		self.entry = [FCEntry newEntryWithCID:FCKeyCIDGlucose];
	
	else {
		
		FCCategory *aCategory = self.entry.category;		// this ensures the entry template 
		[self.entry convertToNewUnit:aCategory.unit];		// is always shown in the correct unit
		
		[self.entry makeNew];	// this removes any specific information about the entry,
								// leaving only its data and category information
	}
	
	// * Timestamp and unit labels
	
	[self updateTimestampLabel];
	[self updateUnitLabel];
	
	// set the picker components to show the last entered reading if there was one
	if (self.entry.decimal != nil) {
	
		[self performSelector:@selector(setPickerRows) withObject:self afterDelay:kPerceptionDelay];
	}
}

-(void)viewDidAppear:(BOOL)animated {
	
	// if the user hasn't selected a timestamp for the entry,
	// use a timer to keep the timestamp up to now
	if (self.entry.timestamp == nil) {
	
		[self updateTimestampLabel];
		[self startTimer];
	}
	
	// stop listening to notifications about category updates
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationCategoryUpdated object:nil];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultShowHelpMessageGlucose]) {
		
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:FCDefaultShowHelpMessageGlucose];
		[self showAlertUsingResourceWithName:@"Glucose"];
	}
	
	[super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {

	// make sure timer is stopped
	[self stopTimer];
	
	// start listening to notifications about category updates
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCategoryUpdatedNotification) name:FCNotificationCategoryUpdated object:nil];
	
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

-(void)loadEntryViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryCreatedNotification) name:FCNotificationEntryCreated object:nil];
	
	// update the entry's value
	[self setEntryProperties];
	
	// if there isn't a timestamp for the entry, set it to now
	if (self.entry.timestamp == nil) {
		
		NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
		self.entry.timestamp = now;
		[now release];
	}
	
	// create and present an entry input view controller
	FCAppEntryViewController *entryViewController = [[FCAppEntryViewController alloc] initWithEntry:self.entry];
	entryViewController.title = @"Glucose";
	entryViewController.navigationControllerFadesInOut = YES;
	entryViewController.isOpaque = YES;
	entryViewController.shouldAnimateToCoverTabBar = YES;
	
	[self presentOverlayViewController:entryViewController];
	
	[entryViewController release];
}

-(void)loadTimestampSelectionViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryObjectUpdatedNotification) name:FCNotificationEntryObjectUpdated object:nil];
	
	// update the entry's value
	[self setEntryProperties];
	
	// create and present a new selector view controller
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = @"Date & time";
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadUnitSelectionViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryObjectUpdatedNotification) name:FCNotificationEntryObjectUpdated object:nil];
	
	// update the entry's value
	[self setEntryProperties];
	
	// create a new selector view controller
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = @"Glucose unit";
	
	selectorViewController.propertyToSelect = FCPropertyUnit;
	selectorViewController.system = self.entry.unit.system;
	selectorViewController.quantity = self.entry.unit.quantity;
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
	
#pragma mark FCEntryView

-(void)onEntryObjectUpdatedNotification {
	
	// if the timestamp was removed, start the timer
	if (self.entry.timestamp == nil)
		[self startTimer];
	
	// if it was set, stop the timer
	else
		[self stopTimer];
	
	// update category's unit (only executes if applicable)
	[self.entry.category saveNewUnit:self.entry.unit andConvert:YES];
	
	// update the visible entry information
	[self updateTimestampLabel];
	[self updateUnitLabel];
	
	// wait a second before resetting the picker rows
	[self.pickerView reloadAllComponents];
	[self performSelector:@selector(setPickerRows) withObject:nil afterDelay:kPerceptionDelay];
	
	// stop listening to notifications about entry updates
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationEntryObjectUpdated object:nil];
}

#pragma mark Picker view
	
// Data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {

	// the decimal
	if (component == 1)
		return 10;
	
	// the integer
	return [self.entry.category.maximum intValue];
}

// Delegate

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
	
	// for localisation purposes, we need to get the decimal separator
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	NSString *decimalSeparator = [formatter decimalSeparator];
	
	NSString *text;
	if (component < 1)
		text = [[NSString alloc] initWithFormat:@"%d%@", row, decimalSeparator];
	else 
		text = [[NSString alloc] initWithFormat:@"%d", row];
	
	[formatter release];
	
	aLabel.text = text;
	[text release];
	
	return aLabel;
}

#pragma mark Custom

-(void)updateTimestampLabel {
/*	Updates the text of the timestamp label and also resizes it and moves the
	edit button accordingly. */
	
	// * Get text for the label
	
	NSDate *theTimestamp;
	
	// if the user hasn't selected a timestamp for their
	// glucose entry, set it to now
	if (self.entry.timestamp == nil) {
	
		theTimestamp = [NSDate dateWithTimeIntervalSinceNow:0.0f]; // autoreleased
	
	// otherwise, use the entry's timestamp
	} else {
		
		theTimestamp = self.entry.timestamp;
	}
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *text = [formatter stringFromDate:theTimestamp];
	
	[formatter release];
	
	// * Create/resize and position the label and button if necessary
	
	CGSize sizeForText = [text sizeWithFont:kAppCommonLabelFont];
	
	if (self.timestampLabel == nil || self.timestampButton == nil) {
		
		// create new label and button
		
		CGFloat yAnchor = 35.0f;
		CGFloat xAnchor = 160.0f;
		
		CGFloat labelWidth = sizeForText.width;
		CGFloat labelHeight = sizeForText.height;
		
		CGFloat buttonWidth = 30.0f; // (same size as buttonImage.png)
		CGFloat buttonHeight = 30.0f;
		
		CGFloat labelXPosition = xAnchor - (labelWidth/2);
		CGFloat labelYPosition = yAnchor - (labelHeight/2);
		
		CGFloat buttonXPosition = labelXPosition + labelWidth + kAppSpacing;
		CGFloat buttonYPosition = yAnchor - (buttonHeight/2);
		
		UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, labelYPosition, labelWidth, labelHeight)];
		newTimestampLabel.backgroundColor = [UIColor clearColor];
		newTimestampLabel.textAlignment = UITextAlignmentCenter;
		newTimestampLabel.font = kAppCommonLabelFont;
		
		self.timestampLabel = newTimestampLabel;
		[self.view addSubview:newTimestampLabel];
		
		[newTimestampLabel release];
		
		UIButton *newTimestampButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[newTimestampButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
		
		newTimestampButton.frame = CGRectMake(buttonXPosition, buttonYPosition, buttonWidth, buttonHeight);
		
		[newTimestampButton addTarget:self action:@selector(loadTimestampSelectionViewController) forControlEvents:UIControlEventTouchUpInside];
		
		self.timestampButton = newTimestampButton;
		[self.view addSubview:newTimestampButton];
		
	} else {
		
		// resize label
		
		CGPoint center = self.timestampLabel.center;
		
		CGRect oldFrame = self.timestampLabel.frame;
		
		CGFloat newXPos = center.x - (sizeForText.width/2);		// using this calculation instead of simply setting new center to the old one
		CGFloat newYPos = center.y - (sizeForText.height/2);	// because that would for some reason be 7 points off every second try... /Anders
		
		CGRect newFrame = CGRectMake(newXPos, newYPos, sizeForText.width, sizeForText.height);
		
		self.timestampLabel.frame = newFrame;
		
		// move edit button
		
		oldFrame = self.timestampButton.frame;
		newXPos = self.timestampLabel.frame.origin.x + self.timestampLabel.frame.size.width + kAppSpacing;
		self.timestampButton.frame = CGRectMake(newXPos, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);	
	}
	
	self.timestampLabel.text = text;
}

-(void)updateUnitLabel {
	
	// * Unit abbreviation
	
	FCUnit *unit = self.entry.unit;
	NSString *text = unit.abbreviation;
	
	// * Create/resize and position the label and button if necessary
	
	CGSize sizeForText = [text sizeWithFont:kAppCommonLabelFont];
	
	if (self.unitLabel == nil || self.unitButton == nil) {
		
		// create new label and button
		
		CGFloat yAnchor = 325.0f;
		CGFloat xAnchor = 160.0f;
		
		CGFloat labelWidth = sizeForText.width;
		CGFloat labelHeight = sizeForText.height;
		
		CGFloat buttonWidth = 30.0f; // (same size as buttonImage.png)
		CGFloat buttonHeight = 30.0f;
		
		CGFloat labelXPosition = xAnchor - (labelWidth/2);
		CGFloat labelYPosition = yAnchor - (labelHeight/2);
		
		CGFloat buttonXPosition = labelXPosition + labelWidth + kAppSpacing;
		CGFloat buttonYPosition = yAnchor - (buttonHeight/2);
		
		UILabel *newUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelXPosition, labelYPosition, labelWidth, labelHeight)];
		newUnitLabel.backgroundColor = [UIColor clearColor];
		newUnitLabel.textAlignment = UITextAlignmentCenter;
		newUnitLabel.font = kAppCommonLabelFont;
		
		self.unitLabel = newUnitLabel;
		[self.view addSubview:newUnitLabel];
		
		[newUnitLabel release];
		
		UIButton *newUnitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[newUnitButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
		
		newUnitButton.frame = CGRectMake(buttonXPosition, buttonYPosition, buttonWidth, buttonHeight);
		
		[newUnitButton addTarget:self action:@selector(loadUnitSelectionViewController) forControlEvents:UIControlEventTouchUpInside];
		
		self.unitButton = newUnitButton;
		[self.view addSubview:newUnitButton];
		
	} else {
		
		// resize label
		
		CGPoint center = self.unitLabel.center;
		
		CGRect oldFrame = self.unitLabel.frame;
		
		CGFloat newXPos = center.x - (sizeForText.width/2);		// using this calculation instead of simply setting new center to the old one
		CGFloat newYPos = center.y - (sizeForText.height/2);	// because that would for some reason be 7 points off every second try... /Anders
		
		CGRect newFrame = CGRectMake(newXPos, newYPos, sizeForText.width, sizeForText.height);
		
		self.unitLabel.frame = newFrame;
		
		// move edit button
		
		oldFrame = self.unitButton.frame;
		newXPos = self.unitLabel.frame.origin.x + self.unitLabel.frame.size.width + kAppSpacing;
		self.unitButton.frame = CGRectMake(newXPos, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);	
	}
	
	self.unitLabel.text = text;
}

-(void)setPickerRows {

	NSNumber *decimalNumber = self.entry.decimal;
	
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
}

-(void)setEntryProperties {
	
	// for localisation purposes, we need to get the decimal separator
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	NSString *decimalSeparator = [formatter decimalSeparator];
	
	NSString *decimalAsString = [[NSString alloc] initWithFormat:@"%d%@%d", [self.pickerView selectedRowInComponent:0], decimalSeparator, [self.pickerView selectedRowInComponent:1]];
	NSNumber *newDecimal = [[NSNumber alloc] initWithDouble:[decimalAsString doubleValue]];
	self.entry.decimal = newDecimal;
	
	[decimalAsString release];
	[newDecimal release];
	[formatter release];
}

#pragma mark Notifications

-(void)onEntryCreatedNotification {
	
	// save attachments
	// OBS! ugly tmp solution, a special case due to owner entry needing to be
	// saved first, which conflicts with this solution for resetting the glucose
	// reading when it is saved
	
	NSMutableArray *attachments = [self.entry.attachments copy];
	FCEntry *dummy = [[FCEntry alloc] init];
	dummy.eid = self.entry.eid;
	
	for (FCEntry *attachment in attachments) {
	
		if (attachment.eid == nil) {
		
			attachment.owner = dummy;
			[attachment save];
		}
	}
	
	[attachments release];
	[dummy release];
	
	// reset the entry
	[self.entry makeNew];
	
	// update the visible entry information
	[self updateTimestampLabel];
	[self updateUnitLabel];
	
	// stop listening to notifications about entry creations
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationEntryCreated object:nil];
}

-(void)onCategoryUpdatedNotification {
		
	[self.entry convertToNewUnit:self.entry.category.unit];
	
	[self updateUnitLabel];
	
	[self setEntryProperties];
	[self.pickerView reloadAllComponents];
	[self setPickerRows];
}

-(void)startTimer {
	
	if (_timer == nil)
		_timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(updateTimestampLabel) userInfo:nil repeats:YES];
}

-(void)stopTimer {
	
	if (_timer != nil) {
		
		[_timer invalidate];
		_timer = nil;
	}
}

@end
