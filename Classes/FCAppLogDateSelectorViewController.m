//
//  FCAppLogDateSelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 21/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	
		if (differenceToStartDate <= 0)
			setNewStartDate = YES;
		
	} else if (self.lastSetWasStartDate) {
		
		if (differenceToStartDate <= 0)
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

-(void)presentContent {

	// right button
	
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// show navigation bar
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// create calendar month view
	
	TKCalendarMonthView *newCalendarMonthView = [[TKCalendarMonthView alloc] init];
	newCalendarMonthView.delegate = self;
	newCalendarMonthView.dataSource = self;
	
	newCalendarMonthView.frame = CGRectMake(0.0f, 460.0f, newCalendarMonthView.frame.size.width, newCalendarMonthView.frame.size.height); // in preparation for appearance animation below
	
	self.calendarMonthView = newCalendarMonthView;
	[self.view addSubview:newCalendarMonthView];
	
	[newCalendarMonthView release];
	
	// get the current end date (assumes that logDates exists, since it should be created on startup, see FCRootViewController -loadApplication:)
	// and select it in calendar to ensure the correct month is shown
	
	NSDate *endDate = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultLogDates] objectForKey:@"EndDate"];
	[self.calendarMonthView selectDate:endDate];
	
	// reload calendar month view to highlight selected
	[newCalendarMonthView reload];
	
	// animate calendar month view onto screen
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^{ self.calendarMonthView.frame = CGRectMake(0.0f, 0.0f, self.calendarMonthView.frame.size.width, self.calendarMonthView.frame.size.height); } 
					 completion:^(BOOL finished) { } ];
}

-(void)dismiss {
	
	// post notification
	if (self.lastSelectedDate != nil)
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationLogDateChanged object:self];
	
	// super dismiss
	[super dismiss];
}

-(void)dismissUIElements {

	// animate calendar month view off screen
	
	[UIView animateWithDuration:kDisappearDuration 
					 animations:^{ self.calendarMonthView.frame = CGRectMake(0.0f, 460.0f, self.calendarMonthView.frame.size.width, self.calendarMonthView.frame.size.height); } 
					 completion:^(BOOL finished) { } ];
}


@end
