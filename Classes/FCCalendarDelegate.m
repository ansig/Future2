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
//  FCCalendarDelegate.m
//  Future2
//
//  Created by Anders Sigfridsson on 05/01/2011.
//


#import "FCCalendarDelegate.h"


@implementation FCCalendarDelegate

@synthesize calendarMonthView;
@synthesize lastSelectedDate, lastSetWasStartDate;
@synthesize intervalInDays;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		[self loadIntervalInDays];
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {

	[super dealloc];
}

#pragma mark TKCalendarMonthViewDelegate

-(void)calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d {
	
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
		
		if (differenceToEndDate > self.intervalInDays) {
			
			TKDateInformation newStartDateInfo = [newLogStartDate dateInformation];
			newStartDateInfo.day += self.intervalInDays;
			
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
		
		if (differenceToStartDate > self.intervalInDays) {
			
			TKDateInformation newEndDateInfo = [newLogEndDate dateInformation];
			newEndDateInfo.day -= self.intervalInDays;
			
			newLogStartDate = [NSDate dateFromDateInformation:newEndDateInfo];
			
		} else {
			
			newLogStartDate = logStartDate;
		}
		
		// flag that the last set date was start date
		
		self.lastSetWasStartDate = NO;
	}
	
	// update the user defaults
	
	NSDictionary *newLogDates = [[NSDictionary alloc] initWithObjectsAndKeys:newLogStartDate, @"StartDate", newLogEndDate, @"EndDate", nil];
	
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

-(void)loadIntervalInDays {
	
	FCGraphScaleDateLevel level = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
	if (level == FCGraphScaleDateLevelHours)
		self.intervalInDays = 6;
	
	else
		self.intervalInDays = 29;
	
	if (self.calendarMonthView != nil) {
		
		// simulating the selection of a new end date to make sure only the
		// correct interval is selected
		
		self.lastSetWasStartDate = YES;
		
		NSDate *endDate = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultLogDates] objectForKey:@"EndDate"];
		[self calendarMonthView:self.calendarMonthView didSelectDate:endDate];
		
		[self.calendarMonthView reload];
	}
}

@end
