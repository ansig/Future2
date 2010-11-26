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

	NSString *string;
	
	if (mode == FCGraphModeTimePlotHorizontal)
		string = @"Horizontal time plot";
	
	else if (mode == FCGraphModeDescendantTimePlotHorizontal)
		string = @"Horizontal descendant time plot";
	
	else if (mode == FCGraphModeTwinTimePlotHorizontal)
		string = @"Horizontal twin time plot";
	
	else if (mode == FCGraphModeDayComparisonHorizontal)
		string = @"Horizontal day comparison";
	
	else
		string = nil;
	
	return string;
}

NSString * FCUnitSystemAsString(FCUnitSystem system) {

	NSString *string;
	
	if (system == FCUnitSystemMetric)
		string = @"Metric";
		
	else if (system == FCUnitSystemImperial)
		string = @"Imperial";
		
	else if (system == FCUnitSystemCustomary)
		string = @"Customary";
		
	else
		string =nil;
	
	return string;
}

NSString *FCUnitQuantityAsString(FCUnitQuantity quantity) {
	
	NSString *string;
	
	if (quantity == FCUnitQuantityWeight)
		string = @"Weight";
	
	else if (quantity == FCUnitQuantityLength)
		string = @"Length";
	
	else if (quantity == FCUnitQuantityVolume)
		string = @"Volume";
	
	else if (quantity == FCUnitQuantityTime)
		string = @"Time";
	
	else if (quantity == FCUnitQuantityGlucose)
		string = @"Glucose";
	
	else if (quantity == FCUnitQuantityInsulin)
		string = @"Insulin";
	
	else if (quantity == FCUnitQuantityNutrition)
		string = @"Nutrition";
	
	else if (quantity == FCUnitQuantityOther)
		string = @"Other";
	
	else
		string = nil;
	
	return string;
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

	NSString *string;
	
	if (display == FCDateDisplayDate)
		string = @"Date";
	
	else if (display == FCDateDisplayYears)
		string = @"Years";
	
	else
		string = nil;
	
	return string;
}

NSString * FCTabAsString(FCTab tab) {

	NSString *string;
	
	if (tab == FCTabProfile)
		string = @"Profile";
	
	else if (tab == FCTabGlucose)
		string = @"Glucose";

	else if (tab == FCTabTags)
		string = @"Tags";
	
	else if (tab == FCTabRecording)
		string = @"Record";
	
	else if (tab == FCTabLog)
		string = @"Log";
	
	else
		string = nil;
	
	return string;
}