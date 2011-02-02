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
@synthesize labels, specialLabels;

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
	
	[labels release];
	[specialLabels release];
	
    [super dealloc];
}

#pragma mark Get

-(NSArray *)labels {

	if (labels == nil) {
		
		self.labels = [self createLabelsArray];
	}
	
	return labels;
}

-(NSArray *)specialLabels {
	
	if (specialLabels == nil) {
		
		self.specialLabels = [self createSpecialLabelsArray];
	}
	
	return specialLabels;
}

-(NSInteger)dateRangeUnits {
/*	Returns the date range in number of significant datetime units for current level (hours, days, months or years). */
	
	if (self.mode == FCGraphScaleModeDates) {
		
		// use the correct unit flags
		NSUInteger unitFlag;
		switch (self.level) {
			
			case FCGraphScaleDateLevelHours:
				unitFlag = NSHourCalendarUnit;
				break;
			
			case FCGraphScaleDateLevelDays:
				unitFlag = NSDayCalendarUnit;
				break;

			case FCGraphScaleDateLevelMonths:
				unitFlag = NSMonthCalendarUnit;
				break;

			case FCGraphScaleDateLevelYears:
				unitFlag = NSYearCalendarUnit;
				break;
				
			default:
				NSAssert1(0, @"FCGraphScale -dateRangeUnits || %@", @"Scale not among listed!");
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
		switch (self.level) {
				
			case FCGraphScaleDateLevelHours:
				units = intervalInComponents.hour;
				break;
				
			case FCGraphScaleDateLevelDays:
				units = intervalInComponents.day;
				break;
				
			case FCGraphScaleDateLevelMonths:
				units = intervalInComponents.month;
				break;
				
			case FCGraphScaleDateLevelYears:
				units = intervalInComponents.year;
				break;
				
			default:
				NSAssert1(0, @"FCGraphScale -dateRangeUnits || %@", @"Scale not among listed!");
		}
		
		// make sure units is always at least 1, since
		// we need to display at least 1 in the graph
		if (units < 1)
			units = 1;
		
		// return units
		return units;
	}
	
	NSLog(@"FCGraphScale -dateUnits || Warning, dateUnits called on scale NOT in date mode! Returning 0.");
	
	return 0;
}

-(NSInteger)dateRangeUnitsDivisor {
/*	Returns a divisor for stepping through the date range units in a certain number of steps. */
	
	return 6;
}

-(NSInteger)wrappedUnits {
/*	Returns the number of primary units covered by the scales range (wraps around to include first and last units).
	For date mode: every significant datetime in date range for current level (hours, days, months or years).
	For data mode: every integer in the data range. */
	
	if (mode == FCGraphScaleModeDates) {
		
		return self.dateRangeUnits + 1; // +1 to include first unit
	
	} else if (mode == FCGraphScaleModeData) {
	
		return self.integerRange + 1; // +1 to include first integer
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

-(NSInteger)integerRange {
/*	Returns the range as an integer which can contain the true range. */
	
	if (self.mode == FCGraphScaleModeData) {
		
		NSInteger range = (NSInteger)self.dataRange.range;
		if (range < self.dataRange.range)
			range += 1;
		
		return range;
	
	} else if (self.mode == FCGraphScaleModeDates) {
		
		NSInteger range = (NSInteger)self.dateRange.interval;
		if (range < self.dateRange.interval)
			range += 1;
		
		return range;
	}
	
	NSLog(@"FCGraphScale -integerRange || Warning, did not recognize graph scale mode! Returning 0.");
	
	return 0;
}

-(NSInteger)integerDataRangeDivisor {
/*	A divisor for stepping through the integer data range in either 4, 3, or 2 steps (including the first integer) */
	
	NSInteger range = self.integerRange;
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

-(CGFloat)requiredLength {
/*	The length required to display the entire date range */
	
	if (mode == FCGraphScaleModeDates) {
		
		CGFloat length = (self.dateRangeUnits * self.spacing) + (self.padding * 2);
		return length;
	}
	
	NSLog(@"FCGraphScale -requiredLength || Warning, required length called on scale in data mode! Returning 0.0f.");
	
	return 0.0f;
}

#pragma mark Custom

-(NSArray *)createLabelsArray {
/*	Creates and returns an array with strings describing each significant primary unit covered by the scale. */
	
	NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
	
	// * Date mode
	if (self.mode == FCGraphScaleModeDates) {
		
		NSDateFormatter *formatter = [NSDateFormatter fc_dateFormatterLocal];
		
		switch (self.level) {
			
			case FCGraphScaleDateLevelHours:
				formatter.dateFormat = @"HH:00";
				break;
				
			case FCGraphScaleDateLevelDays:
				formatter.dateFormat = @"d/M";
				break;
				
			case FCGraphScaleDateLevelMonths:
				formatter.dateFormat = @"d MMM";
				break;
				
			case FCGraphScaleDateLevelYears:
				formatter.dateFormat = @"MMM yyyy";
				break;
				
			default:
				formatter.dateFormat = FCFormatTimestamp;
				NSLog(@"FCGraphScale -createLabelsArray: || Warning, date level not among listed! Setting date format to full timestamp.");
				break;
		}
		
		NSTimeInterval currentInterval;
		NSDate *currentDate;
		
		for (int i = 0; i < self.wrappedUnits; i++) {
			
			currentInterval = (self.dateRange.interval/self.dateRangeUnits)*i;
			currentDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:self.dateRange.startDateTimeIntervalSinceReferenceDate+currentInterval];
			
			NSString *label = [[NSString alloc] initWithString:[formatter stringFromDate:currentDate]];
			[mutableLabels addObject:label];
			[label release];
		
			[currentDate release];
		}
		
	// * Data mode
	} else if (self.mode == FCGraphScaleModeData) {
		
		NSInteger divisor = self.integerDataRangeDivisor;		
		for (int i = 0; i < self.wrappedUnits; i++) {
			
			if (i % divisor == 0) {
				
				NSString *label = [[NSString alloc] initWithFormat:@"%d", i+(int)self.dataRange.minimum];
				[mutableLabels addObject:label];
				[label release];
			}
		}
	}

	NSRange range = NSMakeRange(0, [mutableLabels count]);
	NSArray *newLabels = [mutableLabels subarrayWithRange:range];
	
	[mutableLabels release];
	
	return newLabels;
}

-(NSArray *)createSpecialLabelsArray {
/*	Creates and returns an array with strings describing each special (eg separating) primary unit covered by the scale.
	For date mode: every sixth.
	For data mode: every 10th.*/
	
	NSMutableArray *mutableLabels = [[NSMutableArray alloc] init];
	
	// * Date mode
	if (self.mode == FCGraphScaleModeDates) {
		
		NSDateFormatter *formatter = [NSDateFormatter fc_dateFormatterLocal];
		
		switch (self.level) {
				
			case FCGraphScaleDateLevelHours:
				formatter.dateFormat = @"d MMM";
				break;
				
			case FCGraphScaleDateLevelDays:
				formatter.dateFormat = @"MMM yyyy";
				break;
				
			case FCGraphScaleDateLevelMonths:
				formatter.dateFormat = @"yyyy";
				break;
				
			case FCGraphScaleDateLevelYears:
				formatter.dateFormat = @"d MMM yyyy";
				break;
				
			default:
				formatter.dateFormat = FCFormatTimestamp;
				NSLog(@"FCGraphScale -createLabelsArray: || Warning, date level not among listed! Setting date format to full timestamp.");
				break;
		}
		
		NSTimeInterval currentInterval;
		NSDate *currentDate;
		
		NSInteger divisor = self.dateRangeUnitsDivisor;
		
		for (int i = 0; i < self.wrappedUnits; i++) {
			
			if (i % divisor == 0) {
			
				currentInterval = (self.dateRange.interval/self.dateRangeUnits)*i;
				currentDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:self.dateRange.startDateTimeIntervalSinceReferenceDate+currentInterval];
			
				NSString *label = [[NSString alloc] initWithString:[formatter stringFromDate:currentDate]];
				[mutableLabels addObject:label];
				[label release];
			
				[currentDate release];
			}
		}
		
	// * Data mode
	} else if (self.mode == FCGraphScaleModeData) {
		
		NSInteger divisor = 10;		
		for (int i = 0; i < self.wrappedUnits; i++) {
			
			if (i % divisor == 0) {
				
				NSString *label = [[NSString alloc] initWithFormat:@"%d", i+(int)self.dataRange.minimum];
				[mutableLabels addObject:label];
				[label release];
			}
		}
	}
	
	NSRange range = NSMakeRange(0, [mutableLabels count]);
	NSArray *newLabels = [mutableLabels subarrayWithRange:range];
	
	[mutableLabels release];
	
	return newLabels;
}

@end
