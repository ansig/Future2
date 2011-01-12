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
//  FCGraphDataSet.m
//  Future2
//
//  Created by Anders Sigfridsson on 20/10/2010.
//

#import "FCGraphDataSet.h"


@implementation FCGraphDataSet

@synthesize data;
@synthesize xReferenceRanges, yReferenceRanges;
@synthesize xSerie, ySerie;
@synthesize xBoxPlot, yBoxPlot;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		data = [[NSMutableArray alloc] init];

		xSerie = [[NSMutableArray alloc] init];
		ySerie = [[NSMutableArray alloc] init];
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {
	
	[data release];
	
	[xReferenceRanges release];
	[yReferenceRanges release];
	
	[xSerie release];
	[ySerie release];
	
	[super dealloc];
}

#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone {
/*	Implements DEEP copying (i.e. duplicates instance variables).
	(see http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmImplementCopy.html )
	 
	Data references do not get copied, since they are set when the data set is added to
	a graph view controller. */
	 
	FCGraphDataSet *copy = [[[self class] allocWithZone:zone] init];
	
	NSMutableArray *dataCopy = [[NSMutableArray alloc] initWithArray:self.data copyItems:YES];
	copy.data = dataCopy;
	[dataCopy release];
	
	NSMutableArray *xSerieCopy = [[NSMutableArray alloc] initWithArray:self.xSerie copyItems:YES];
	copy.xSerie = xSerieCopy;
	[xSerieCopy release];
	
	NSMutableArray *ySerieCopy = [[NSMutableArray alloc] initWithArray:self.ySerie copyItems:YES];
	copy.ySerie = ySerieCopy;
	[ySerieCopy release];
	
	copy.xBoxPlot = self.xBoxPlot;
	copy.yBoxPlot = self.yBoxPlot;
	
	return (copy);
}

#pragma mark Override

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {

	// * only accepts objects of FCGraphEntryView class that has both x and y values set
	
	BOOL isMember = [anObject isMemberOfClass:[FCGraphEntryView class]];
	NSAssert1(isMember, @"FCGraphDataSet -insertObject:atIndex: || %@", @"Failed to insert at index since object was not of class FCGraphEntryView!");
	
	BOOL hasXValue = (FCGraphEntryView *)[anObject xValue] != nil ? YES : NO;
	NSAssert1(hasXValue, @"FCGraphDataSet -insertObject:atIndex: || %@", @"Failed to insert at index since FCGraphEntryView object did not have an X value!");

	BOOL hasYValue = (FCGraphEntryView *)[anObject yValue] != nil ? YES : NO;
	NSAssert1(hasYValue, @"FCGraphDataSet -insertObject:atIndex: || %@", @"Failed to insert at index since FCGraphEntryView object did not have a Y value!");
	 
	// * maintain sorted arrays of x and y values
	
	NSNumber *xValue = [anObject xValue];
	NSNumber *yValue = [anObject yValue];
	
	if ([self count] == 0) {
		
		// if this is the first inserted object, simply
		// insert the values in corresponding array
		
		[self.xSerie addObject:xValue];
		[self.ySerie addObject:yValue];
		
	} else {
		
		// try to place each value in their right position in the array assuming the following:
		// 1) the present values in each array are already in ascending order
		// 2 a) the two arrays always contain the same number of values
		//   b) the number of values in each array is always equal to the number of objects in this data set
		
		NSInteger potentialIndex = 0;
		
		BOOL foundXIndex = NO;
		BOOL foundYIndex = NO;
		
		while (!foundXIndex || !foundYIndex) {
			
			if (!foundXIndex) {
				
				// while we haven't found an index for the x value, compare
				// the new value to one at the current index
				
				NSNumber *existingXValue = [self.xSerie objectAtIndex:potentialIndex];
				
				if ([xValue compare:existingXValue] != NSOrderedDescending) {
					
					// if the new value is lower or equal to the existing value,
					// insert it at this index (shifts the array by one)
					
					[self.xSerie insertObject:xValue atIndex:potentialIndex];
					foundXIndex = YES;
				}
			}
			
			if (!foundYIndex) {
				
				NSNumber *existingYValue = [self.ySerie objectAtIndex:potentialIndex];
				
				if ([yValue compare:existingYValue] != NSOrderedDescending) {
					
					[self.ySerie insertObject:yValue atIndex:potentialIndex];
					foundYIndex = YES;
				}
			}
			
			potentialIndex++;
			
			if (potentialIndex == [self count]) {
				
				// if we reached the end of the array,
				// simply add the values if they still
				// haven't been added
				
				if (!foundXIndex) {
					
					[self.xSerie addObject:xValue];
					foundXIndex = YES;
				}
				
				if (!foundYIndex) {
					
					[self.ySerie addObject:yValue];
					foundYIndex = YES;
				}
			}
		}
	}
	
	// * insert object in super
	
	[self.data insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
	
	// remove corresponding values from y and x value arrays
	
	FCGraphEntryView *theObject = [self.data objectAtIndex:index];
	
	NSInteger indexOfYValue = [self.ySerie indexOfObject:theObject.yValue];
	[self.ySerie removeObjectAtIndex:indexOfYValue];
	
	NSInteger indexOfXValue = [self.xSerie indexOfObject:theObject.xValue];
	[self.xSerie removeObjectAtIndex:indexOfXValue];
	
	// remove from data
	
	[self.data removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {

	[self insertObject:anObject atIndex:[self count]];
}

- (void)removeLastObject {

	[self.data removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {

	[self.data replaceObjectAtIndex:index withObject:anObject];
}

- (NSUInteger)count {

	return [self.data count];
}

- (id)objectAtIndex:(NSUInteger)index {

	return [self.data objectAtIndex:index];
}

#pragma mark Get

-(FCBoxPlot)xBoxPlot {

	// makes sure an updated box plot structure is returned
	self.xBoxPlot = [self boxPlotForRankedSerie:self.xSerie];
	
	return xBoxPlot;
}

-(FCBoxPlot)yBoxPlot {
	
	// makes sure an updated box plot structure is returned
	self.yBoxPlot = [self boxPlotForRankedSerie:self.ySerie];
	
	return yBoxPlot;
}

#pragma mark Custom

-(double)averageY {
/*	Returns average value for y serie. */
	
	// find average
	double total = 0;
	for (NSNumber *number in self.ySerie)
		total = total + [number doubleValue];
	
	double average = total / [self.ySerie count];
	
	return average;
}

-(void)calculateBoxPlots {
/*	Sets box plot structures for current x and y series. */
	
	self.xBoxPlot = [self boxPlotForRankedSerie:self.xSerie];
	self.yBoxPlot = [self boxPlotForRankedSerie:self.ySerie];
}

-(FCBoxPlot)boxPlotForRankedSerie:(NSArray *)theSerie {
/*	Calculates median and upper/lower quartiles, gets miniumum and maximum values, and returns a box plot structure. */
	
	NSInteger count = [theSerie count];
	if (count > 1) {
		
		// * 2 or more values
		
		// median
		
		double median = [self medianForRankedSerie:theSerie];
		
		// lower and upper quartile
		
		double remainder = count % 2;
		double dividend = count / 2;
		NSInteger dividendAsInteger = (NSInteger)dividend;
		
		NSRange lowerRange;
		NSRange upperRange;
		
		if (remainder == 0) {
			
			// even (divides in half)
			lowerRange = NSMakeRange(0, dividendAsInteger);
			upperRange = NSMakeRange(dividendAsInteger, count-dividendAsInteger);
			
		} else {
			
			// odd (includes middle observation in both halfs)
			lowerRange = NSMakeRange(0, dividendAsInteger+1);
			upperRange = NSMakeRange(dividendAsInteger, count-(dividendAsInteger+1));
		}
		
		NSArray *lowerHalf = [theSerie subarrayWithRange:lowerRange];
		NSArray *upperHalf = [theSerie subarrayWithRange:upperRange];
		
		double lowerQuartile = [self medianForRankedSerie:lowerHalf];
		double upperQuartile = [self medianForRankedSerie:upperHalf];
		
		// sample minimum and maximum
		
		double minimum = [[theSerie objectAtIndex:0] doubleValue];
		double maximum = [[theSerie objectAtIndex:count-1] doubleValue];
		
		// compose and set box plot
		
		return FCBoxPlotMake(median, lowerQuartile, upperQuartile, minimum, maximum);
		
	} else if (count == 1) {
		
		// * One value
		
		double singleValue = [[self.xSerie objectAtIndex:0] doubleValue];
		return FCBoxPlotMake(singleValue, singleValue, singleValue, singleValue, singleValue);
	}
	
	// * No values
	return FCBoxPlotMake(0, 0, 0, 0, 0);
}

-(double)medianForRankedSerie:(NSArray *)theSerie {
/*	Returns the median value within the given serie. */
	
	// get the index range and exctract the middle observations
	
	NSRange indexRange = [self medianIndexRangeInRankedSerie:theSerie];
	NSArray *middleObservations = [theSerie subarrayWithRange:indexRange];
	
	// calculate median
	
	double sum = 0;
	for (NSNumber *number in middleObservations)
		sum = sum + [number doubleValue];
	
	double median = sum / [middleObservations count];
	
	return median;
}

-(NSRange)medianIndexRangeInRankedSerie:(NSArray *)theSerie {
/*	Returns an index range which cover the middle observations in the serie. */
	
	// variables
	
	NSInteger count = [theSerie count];
	double remainder = count % 2;
	double dividend = count / 2;
	
	// indexes
	
	NSInteger lower = remainder == 0 ? (NSInteger)dividend-1 : (NSInteger)dividend;
	NSInteger upper = (NSInteger) dividend;
	
	// result
	
	NSInteger location = lower;
	NSInteger length = (upper-lower) + 1; // add one to always include at least one index
	
	return NSMakeRange(location, length);
}

-(void)addXReferenceRange:(FCGraphReferenceRange *)newReferenceRange {
/*	Adds the given reference range to the x reference ranges array. */
	
	if (self.xReferenceRanges == nil) {
		
		NSMutableArray *newReferenceRanges = [[NSMutableArray alloc] init];
		self.xReferenceRanges = newReferenceRanges;
		[newReferenceRange release];
	}
	
	[self.xReferenceRanges addObject:newReferenceRange];
}
-(void)addYReferenceRange:(FCGraphReferenceRange *)newReferenceRange {
/*	Adds the given reference range to the y reference ranges array. */
	
	if (self.yReferenceRanges == nil) {
		
		NSMutableArray *newReferenceRanges = [[NSMutableArray alloc] init];
		self.yReferenceRanges = newReferenceRanges;
		[newReferenceRanges release];
	}
	
	[self.yReferenceRanges addObject:newReferenceRange];
}

@end
