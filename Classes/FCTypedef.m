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
//  FCTypedef.m
//  Future2
//
//  Created by Anders Sigfridsson on 21/07/2010.
//

/* STRUCT INITIALIZERS */

FCDataRange FCDataRangeMake(double minimum, double maximum) {
	
	FCDataRange range;
	
	range.maximum = maximum;
	range.minimum = minimum;
	
	// True range between minimum and maximum
	range.range = maximum - minimum;
	
	return range;
}

FCDateRange FCDateRangeMake(NSTimeInterval startDateTimeIntervalSinceReferenceDate, NSTimeInterval endDateTimeIntervalSinceReferenceDate) {
	
	FCDateRange range;
	
	range.startDateTimeIntervalSinceReferenceDate = startDateTimeIntervalSinceReferenceDate;
	range.endDateTimeIntervalSinceReferenceDate = endDateTimeIntervalSinceReferenceDate;
	
	range.interval = endDateTimeIntervalSinceReferenceDate - startDateTimeIntervalSinceReferenceDate;
	
	return range;
}

FCBoxPlot FCBoxPlotMake(double median, double lowerQuartile, double upperQuartile, double sampleMinimum, double sampleMaximum) {

	FCBoxPlot boxPlot;
	
	boxPlot.median = median;
	boxPlot.lowerQuartile = lowerQuartile;
	boxPlot.upperQuartile = upperQuartile;
	boxPlot.sampleMinimum = sampleMinimum;
	boxPlot.sampleMaximum = sampleMaximum;
	
	boxPlot.iqrRange = upperQuartile - lowerQuartile; // interquartile range
	
	boxPlot.lowerExtremeValueLimit = lowerQuartile - 1.5 * boxPlot.iqrRange; // lower extreme value limit
	
	boxPlot.upperExtremeValueLimit = upperQuartile + 1.5 * boxPlot.iqrRange; // upper extreme value limit
	
	return boxPlot;
}

/* ENUM DESCRIPTIONS */

NSString * FCGraphModeAsString(FCGraphMode mode) {

	if (mode == FCGraphModeTimePlotHorizontal)
		return @"Horizontal time plot";
	
	else if (mode == FCGraphModeDescendantTimePlotHorizontal)
		return @"Horizontal descendant time plot";
	
	else if (mode == FCGraphModeTwinTimePlotHorizontal)
		return @"Horizontal twin time plot";
	
	else if (mode == FCGraphModeTimeBandHorizontal)
		return @"Horizontal time band";
	
	else if (mode == FCGraphModeDescendantTimeBandHorizontal)
		return @"Horizontal descendant time band";
	
	return nil;
}

NSString * FCUnitSystemAsString(FCUnitSystem system) {

	if (system == FCUnitSystemMetric)
		return @"Metric";
		
	else if (system == FCUnitSystemImperial)
		return @"Imperial";
		
	else if (system == FCUnitSystemCustomary)
		return @"Customary";
	
	return nil;
}

NSString * FCSortByAsString(FCSortBy sortBy) {

	if (sortBy == FCSortByDate)
		return @"Date";
	
	else if (sortBy == FCSortByCategory)
		return @"Category";
	
	else if (sortBy == FCSortByAttachment)
		return @"Attachment";
	
	return nil;
}

NSInteger FCSortByCount() {
	
	NSInteger count = 0;
	NSString *name = FCSortByAsString(count);
	while (name != nil) {
		
		count++;
		name = FCSortByAsString(count);
	}
	
	return count;
}

NSString *FCUnitQuantityAsString(FCUnitQuantity quantity) {
	
	if (quantity == FCUnitQuantityWeight)
		return @"Weight";
	
	else if (quantity == FCUnitQuantityLength)
		return @"Length";
	
	else if (quantity == FCUnitQuantityVolume)
		return @"Volume";
	
	else if (quantity == FCUnitQuantityTime)
		return @"Time";
	
	else if (quantity == FCUnitQuantityGlucose)
		return @"Glucose";
	
	else if (quantity == FCUnitQuantityInsulin)
		return @"Insulin";
	
	else if (quantity == FCUnitQuantityNutrition)
		return @"Nutrition";
	
	else if (quantity == FCUnitQuantityOther)
		return @"Other";
	
	return nil;
}

NSInteger FCUnitQuantityCount() {

	NSInteger count = 0;
	NSString *name = FCUnitQuantityAsString(count);
	while (name != nil) {
	
		count++;
		name = FCUnitQuantityAsString(count);
	}
	
	return count;
}

NSString * FCDateDisplayAsString(FCDateDisplay display) {

	if (display == FCDateDisplayDate)
		return @"Date";
	
	else if (display == FCDateDisplayYears)
		return @"Years";
	
	return nil;
}

NSString * FCTabAsString(FCTab tab) {

	if (tab == FCTabProfile)
		return @"Profile";
	
	else if (tab == FCTabGlucose)
		return @"Glucose";

	else if (tab == FCTabTags)
		return @"Tags";
	
	else if (tab == FCTabRecording)
		return @"Record";
	
	else if (tab == FCTabLog)
		return @"Log";
	
	return nil;
}