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
//  FCAppLogDateSelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 21/09/2010.
//

#import "FCAppLogDateSelectorViewController.h"


@implementation FCAppLogDateSelectorViewController

@synthesize calendarMonthView;
@synthesize calendarDelegate;
@synthesize segmentedControl, label;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {

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
	
	[calendarMonthView release];
	[calendarDelegate release];
	
	[segmentedControl release];
	[label release];
	
    [super dealloc];
}

#pragma mark View

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Orientation

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark Events

-(void)onSegmentedControlValueChange {
	
	[[NSUserDefaults standardUserDefaults] setInteger:self.segmentedControl.selectedSegmentIndex forKey:FCDefaultGraphSettingDateLevel];
	
	[self.calendarDelegate loadIntervalInDays];
}

#pragma mark Custom

-(void)createUIContent {
	
	// right button
	
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// calendar month view
	
	FCCalendarDelegate *newCalendarDelegate = [[FCCalendarDelegate alloc] init];
	self.calendarDelegate = newCalendarDelegate;
	[newCalendarDelegate release];
	
	TKCalendarMonthView *newCalendarMonthView = [[TKCalendarMonthView alloc] init];
	newCalendarMonthView.delegate = self.calendarDelegate;
	newCalendarMonthView.dataSource = self.calendarDelegate;
	self.calendarDelegate.calendarMonthView = newCalendarMonthView;
	
	newCalendarMonthView.frame = CGRectMake(0.0f, 0.0f, newCalendarMonthView.frame.size.width, newCalendarMonthView.frame.size.height); // in preparation for appearance animation below
	
	self.calendarMonthView = newCalendarMonthView;
	[newCalendarMonthView release];
	
	// label and segmented control
	
	NSString *text = @"View in graph:";
	CGSize sizeForText = [text sizeWithFont:kAppBoldCommonLabelFont];
	
	CGFloat yPos = 309 + kAppAdjacentSpacing;
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yPos, 320.0f, sizeForText.height)];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.font = kAppBoldCommonLabelFont;
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.textColor = [UIColor whiteColor];
	newLabel.text = text;
	
	self.label = newLabel;
	
	[newLabel release];
	
	yPos = self.label.frame.origin.y + self.label.frame.size.height + kAppAdjacentSpacing;
	
	UISegmentedControl *newSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Hours", @"Days", @"Months", nil]];
	newSegmentedControl.frame = CGRectMake(50.0f, yPos, 220.0f, 27.0f);
	newSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
	
	[newSegmentedControl addTarget:self action:@selector(onSegmentedControlValueChange) forControlEvents:UIControlEventValueChanged];
	
	self.segmentedControl = newSegmentedControl;
	
	[newSegmentedControl release];
}

-(void)presentUIContent {

	// show navigation bar
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// get the current end date (assumes that logDates exists, since it should be created on startup, see FCRootViewController -loadApplication:)
	// and select it in calendar to ensure the correct month is shown
	
	NSDate *endDate = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultLogDates] objectForKey:@"EndDate"];
	[self.calendarMonthView selectDate:endDate];
	
	// reload calendar month view to highlight selected
	[self.calendarMonthView reload];
	
	// animate calendar month view, label and segmented control onto screen
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	self.calendarMonthView.transform = translation;
	self.segmentedControl.transform = translation;
	self.label.transform = translation;
	
	[self.view addSubview:self.calendarMonthView];
	[self.view addSubview:self.segmentedControl];
	[self.view addSubview:self.label];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.calendarMonthView.transform = CGAffineTransformIdentity; self.segmentedControl.transform = CGAffineTransformIdentity; self.label.transform = CGAffineTransformIdentity; } 
					 completion:^ (BOOL finished) { } ];
}

-(void)dismissUIContent {
	
	// animate calendar month view off screen and remove from superview
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	
	[UIView animateWithDuration:kDisappearDuration 
					 animations:^{ self.calendarMonthView.transform = translation; self.segmentedControl.transform = translation; self.label.transform = translation; } 
					 completion:^(BOOL finished) { [self.calendarMonthView removeFromSuperview]; [self.segmentedControl removeFromSuperview]; [self.label removeFromSuperview]; } ];
}

-(void)dismiss {
	
	// post notification
	if (self.calendarDelegate.lastSelectedDate != nil)
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationLogDateChanged object:self];
	
	// super dismiss
	[super dismiss];
}

@end
