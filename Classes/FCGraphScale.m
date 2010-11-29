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
//  FCGraphScale.m
//  GraphExperiment2
//
//  Created by Anders Sigfridsson on 13/07/2010.
//

#import "FCGraphScale.h"

#pragma mark C helpers

int gcd(int a, int b) {
/*	Returns greatest common divisor between a and b derived with the Euclidean algoritm. */
	
	int t;
	while (b != 0) {
		
		t = b;
		b = a % b;
		a = t;
	}
	
	return a;
}

@implementation FCGraphScale

@synthesize mode, dataRange, dateRange, level;
@synthesize padding, spacing;

#pragma mark Instance

-(id)initWithDataRange:(FCDataRange)theRange padding:(CGFloat)thePadding {
	
	if (self = [self initWithDataRange:theRange]) {
		
		padding = thePadding;
	}
	
	return self;
}

-(id)initWithDataRange:(FCDataRange)theRange {
	
	if (self = [self init]) {
		
		mode = FCGraphScaleModeData;
		dataRange = theRange;
	}
	
	return self;	
}

-(id)initWithDateRange:(FCDateRange)theRange level:(FCGraphScaleDateLevel)theLevel padding:(CGFloat)thePadding spacing:(CGFloat)theSpacing {
	
	if (self = [self initWithDateRange:theRange padding:thePadding spacing:theSpacing]) {
		
		level = theLevel;
	}
	
	return self;
}

-(id)initWithDateRange:(FCDateRange)theRange padding:(CGFloat)thePadding spacing:(CGFloat)theSpacing {
	
	if (self = [self initWithDateRange:theRange]) {
		
		padding = thePadding;
		spacing = theSpacing;
	}
	
	return self;
}

-(id)initWithDateRange:(FCDateRange)theRange {
	
	if (self = [self init]) {
		
		mode = FCGraphScaleModeDates;
		dateRange = theRange;
	}
	
	return self;	
}

-(id)init {
	
    if (self = [super init]) {

    }
	
    return self;
}

-(void)dealloc {
	
    [super dealloc];
}

#pragma mark Get

-(NSInteger)dateRangeInUnits {
/*	Returns the date range in number of significant datetime units for current level (hours, days, months or years). */
	
	if (self.mode == FCGraphScaleModeDates) {
		
		// use the correct unit flags
		NSUInteger unitFlag;
		if (level == FCGraphScaleDateLevelHours)
			unitFlag = NSHourCalendarUnit;
		
		else if (level == FCGraphScaleDateLevelDays)
			unitFlag = NSDayCalendarUnit;
		
		else if (level == FCGraphScaleDateLevelMonths)
			unitFlag = NSMonthCalendarUnit;
		
		else if (level == FCGraphScaleDateLevelYears)
			unitFlag = NSYearCalendarUnit;
		
		else {
			
			NSLog(@"FCGraphScale -(int)dateUnits || Warning, date level was not among listed! Returning 0.");
			return 0;
		}
		
		// exctract the interval in components
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
		NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:self.dateRange.startDateTimeIntervalSinceReferenceDate];
		NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:self.dateRange.endDateTimeIntervalSinceReferenceDate];
		
		NSDateComponents *intervalInComponents = [gregorian components:unitFlag fromDate:startDate toDate:endDate options:0];
		
		[startDate release];
		[endDate release];
		
		[gregorian release];
		
		// get the number of units
		NSInteger units;
		if (level == FCGraphScaleDateLevelHours)
			units = intervalInComponents.hour;
		
		else if (level == FCGraphScaleDateLevelDays)
			units = intervalInComponents.day;
		
		else if (level == FCGraphScaleDateLevelMonths)
			units = intervalInComponents.month;
		
		else if (level == FCGraphScaleDateLevelYears)
			units = intervalInComponents.year;
		
		// make sure units is always at least 1, since
		// we need to display at least 1 in the graph
		if (units < 1)
			units = 1;
		
		// return units
		return units;
	}
	
	NSLog(@"FCGraphScale -(double)dateUnits || Warning, dateUnits called on scale NOT in date mode! Returning 0.");
	
	return 0;
}

-(NSInteger)integerDataRange {
/*	Returns the data range as an integer which can contain the whole of the true range. */
	
	if (self.mode == FCGraphScaleModeData) {
	
		NSInteger range = (NSInteger)self.dataRange.range;
		if (range < self.dataRange.range)
			range += 1;
		
		return range;
	}
	
	NSLog(@"FCGraphScale -(int)intDataRange || Warning, intDataRange called on scale NOT in data mode! Returning 0.");
	
	return 0;
}

-(NSInteger)integerDataRangeDivisor {
/*	A divisor for stepping through the intDataRange in either 4, 3, or 2 steps (including the first integer) */
	
	NSInteger range = self.integerDataRange;
	NSInteger divisor;
	
	// Try for 4
	if (range % 3 == 0) {
		
		divisor = range / 3;
		
	// Try for 3
	} else if (range % 2 == 0) {
		
		divisor = range / 2;
		
	// Find for 2
	} else {
		
		divisor = (NSInteger)gcd(0, range);
	}
	
	return divisor;
}

-(NSInteger)units {
/*	Returns the number of primary units covered by the scales range.
	For date mode: every significant datetime in date range for current level (hours, days, months or years).
	For data mode: every integer in the data range. 
	Wraps around to include first and last units. */
	
	if (mode == FCGraphScaleModeDates) {
		
		return self.dateRangeInUnits + 1; // +1 to include first unit
	
	} else if (mode == FCGraphScaleModeData) {
	
		return self.integerDataRange + 1; // +1 to include first integer
	
	} 
	
	NSLog(@"FCGraphScale -units || Warning, graph mode is not set! Returning 0.");
	return 0;
}

-(double)range {
/*	Returns the true range which the scale covers. */
	
	if (self.mode == FCGraphScaleModeData)
		return self.dataRange.range;
	
	return self.dateRange.interval;
}

-(CGFloat)requiredLength {
/*	The length required to display the entire date range */
	
	if (mode == FCGraphScaleModeDates) {
		
		CGFloat length = (self.dateRangeInUnits * self.spacing) + (self.padding * 2);
		return length;
	}
	
	NSLog(@"FCGraphScale -(CFloat)requiredLength || Warning, required length called on scale in data mode! Returning 0.0f.");
	
	return 0.0f;
}

#pragma mark Custom

-(NSMutableArray *)createLabelsArray {
/*	Creates and returns an array with strings describing each significant primary unit covered by the scale. */
	
	NSMutableArray *labels = [[NSMutableArray alloc] init];
	
	// * Date mode
	if (self.mode == FCGraphScaleModeDates) {
		
		NSDateFormatter *formatter = [NSDateFormatter fc_dateFormatterLocal];
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit;
		
		NSDate *currentDate;
		NSDate *previousDate = nil;
		
		for (int i = 0; i < self.units; i++) {
			
			NSTimeInterval currentInterval = (self.dateRange.interval/self.dateRangeInUnits)*i;
			currentDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:dateRange.startDateTimeIntervalSinceReferenceDate+currentInterval];
			
			if (previousDate == nil)
				previousDate = [currentDate retain];
			
			NSDateComponents *currentDateComponents = [gregorian components:unitFlags fromDate:currentDate];
			NSDateComponents *previousDateComponents = [gregorian components:unitFlags fromDate:previousDate];
			
			[previousDate release];
			
			if (currentDateComponents.year != previousDateComponents.year)
				formatter.dateFormat = @"MMM yyyy";
			
			else if (currentDateComponents.month != previousDateComponents.month)
				formatter.dateFormat = @"d MMM";
			
			else if (currentDateComponents.day != previousDateComponents.day)
				formatter.dateFormat = @"d/M";
			
			else if (currentDateComponents.hour != previousDateComponents.hour)
				formatter.dateFormat = @"HH:00";

			else
				formatter.dateFormat = @"d/M";
			
			NSString *label = [[NSString alloc] initWithString:[formatter stringFromDate:currentDate]];
			[labels addObject:label];
			[label release];
			
			previousDate = currentDate;
		}
		
		[previousDate release];
		[gregorian release];
		
	// * Data mode
	} else if (self.mode == FCGraphScaleModeData) {
		
		NSInteger divisor = self.integerDataRangeDivisor;		
		for (int i = 0; i < self.units; i++) {
			
			if (i % divisor == 0) {
				
				NSString *label = [[NSString alloc] initWithFormat:@"%d", i+(int)self.dataRange.minimum];
				[labels addObject:label];
				[label release];
			}
		}
	}

	[labels autorelease];
	
	return labels;
}

@end
