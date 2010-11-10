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
//  FCAppLogDateSelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 21/09/2010.
//

#import "FCAppLogDateSelectorViewController.h"


@implementation FCAppLogDateSelectorViewController

@synthesize calendarMonthView;
@synthesize lastSelectedDate, lastSetWasStartDate;

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
	
	[calendarMonthView release];
	[lastSelectedDate release];
	
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

#pragma mark TKCalendarMonthViewDelegate

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d {
	
	// get current log dates
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	NSDate *logStartDate = [logDates objectForKey:@"StartDate"];
	NSDate *logEndDate = [logDates objectForKey:@"EndDate"];
	
	// determine whether to set a new start or end date
	
	BOOL setNewStartDate = NO;
	
	int differenceToStartDate = [logStartDate differenceInDaysTo:d];
	
	if (self.lastSelectedDate == nil) {
	
		if (differenceToStartDate < 0)
			setNewStartDate = YES;
		
	} else if (self.lastSetWasStartDate) {
		
		if (differenceToStartDate < 0)
			setNewStartDate = YES;
		
	} else {
		
		int differenceToEndDate = [logEndDate differenceInDaysTo:d];
		
		if (differenceToEndDate <= 0)
			setNewStartDate = YES;
	}
	
	// set new start or end date
	NSDate *newLogStartDate, *newLogEndDate;
	if (setNewStartDate) {
		
		newLogStartDate = d;
		
		// adjust end date so that difference to the new start date is within the allowed range
		
		int differenceToEndDate = [newLogStartDate differenceInDaysTo:logEndDate];
		
		if (differenceToEndDate > 6) {
		
			TKDateInformation newStartDateInfo = [newLogStartDate dateInformation];
			newStartDateInfo.day += 6;
			
			newLogEndDate = [NSDate dateFromDateInformation:newStartDateInfo];
		
		} else {
		
			newLogEndDate = logEndDate;
		}
		
		// flag that the last set date was start date
		
		self.lastSetWasStartDate = YES;
		
	} else {
		
		newLogEndDate = d;
		
		// adjust end date so that difference to the new start date is within the allowed range
		
		int differenceToStartDate = [logStartDate differenceInDaysTo:newLogEndDate];
		
		if (differenceToStartDate > 6) {
			
			TKDateInformation newEndDateInfo = [newLogEndDate dateInformation];
			newEndDateInfo.day -= 6;
			
			newLogStartDate = [NSDate dateFromDateInformation:newEndDateInfo];
			
		} else {
			
			newLogStartDate = logStartDate;
		}
		
		// flag that the last set date was start date
		
		self.lastSetWasStartDate = NO;
	}
	
	NSDictionary *newLogDates = [[NSDictionary alloc] initWithObjectsAndKeys:newLogStartDate, @"StartDate", newLogEndDate, @"EndDate", nil];
	
	// update the user defaults
	
	[defaults setObject:newLogDates forKey:FCDefaultLogDates];
	
	[newLogDates release];
	
	// remember this selection and reload the calendar month view
	
	self.lastSelectedDate = d;
	[self.calendarMonthView reload];
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView monthDidChange:(NSDate*)d {
	
	// reload to ensure visible marked days are marked
	[self.calendarMonthView reload];
}

#pragma mark TKCalendarMonthViewDataSource

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate {
	
	// * Mark all dates between current log start date and end date in user defaults
	
	// get current log dates
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	NSDate *logStartDate = [logDates objectForKey:@"StartDate"];
	NSDate *logEndDate = [logDates objectForKey:@"EndDate"];
	
	// loop through all dates currently visible in calendar view
	
	NSMutableArray *selectedDates = [[NSMutableArray alloc] init];
	
	NSDate *currentDate = startDate;
	
	int difference = [startDate differenceInDaysTo:lastDate];
	for (int i = 0; i <= difference; i++) {
	
		// get info about current date
		TKDateInformation currentDateInfo = [currentDate dateInformation];
		
		// find dates between the log start and end dates
		NSNumber *marker;
		
		int differenceToLogStartDate = [currentDate differenceInDaysTo:logStartDate];
		int differenceToLogEndDate = [currentDate differenceInDaysTo:logEndDate];
		
		if (differenceToLogStartDate <= 0 && differenceToLogEndDate >= 0)
			marker = [[NSNumber alloc] initWithBool:YES];
		
		else
			marker = [[NSNumber alloc] initWithBool:NO];
			
		// add marker
		[selectedDates addObject:marker];
		
		[marker release];
		
		// get the next date
		currentDateInfo.day++;
		currentDate = [NSDate dateFromDateInformation:currentDateInfo];
	}
	
	// autorelease and return
	
	[selectedDates autorelease];
	
	return selectedDates;
}

#pragma mark Custom

-(void)createUIContent {
	
	// right button
	
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// calendar month view
	
	TKCalendarMonthView *newCalendarMonthView = [[TKCalendarMonthView alloc] init];
	newCalendarMonthView.delegate = self;
	newCalendarMonthView.dataSource = self;
	
	newCalendarMonthView.frame = CGRectMake(0.0f, 0.0f, newCalendarMonthView.frame.size.width, newCalendarMonthView.frame.size.height); // in preparation for appearance animation below
	
	self.calendarMonthView = newCalendarMonthView;
	[newCalendarMonthView release];
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
	
	// animate calendar month view onto screen
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	self.calendarMonthView.transform = translation;
	
	[self.view addSubview:self.calendarMonthView];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.calendarMonthView.transform = CGAffineTransformIdentity; } 
					 completion:^ (BOOL finished) { } ];
}

-(void)dismissUIContent {
	
	// animate calendar month view off screen and remove from superview
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	
	[UIView animateWithDuration:kDisappearDuration 
					 animations:^{ self.calendarMonthView.transform = translation; } 
					 completion:^(BOOL finished) { [self.calendarMonthView removeFromSuperview]; } ];
}

-(void)dismiss {
	
	// post notification
	if (self.lastSelectedDate != nil)
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationLogDateChanged object:self];
	
	// super dismiss
	[super dismiss];
}


@end
