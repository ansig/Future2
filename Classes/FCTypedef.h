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
//  FCTypedef.h
//  Future2
//
//  Created by Anders Sigfridsson on 01/06/2010.
//

/* STRUCT */

typedef struct {
	
	double minimum;
	double maximum;
	double range;
	
} FCDataRange;

FCDataRange FCDataRangeMake(double minimum, double maximum);

typedef struct {
	
	NSTimeInterval startDateTimeIntervalSinceReferenceDate;
	NSTimeInterval endDateTimeIntervalSinceReferenceDate;
	NSTimeInterval interval;
	
} FCDateRange;

FCDateRange FCDateRangeMake(NSTimeInterval startDateTimeIntervalSinceReferenceDate, NSTimeInterval endDateTimeIntervalSinceReferenceDate);

typedef struct {
	
	double median;
	double lowerQuartile;
	double upperQuartile;
	double iqrRange;
	double sampleMinimum;
	double sampleMaximum;
	double lowerExtremeValueLimit;
	double upperExtremeValueLimit;

} FCBoxPlot;

FCBoxPlot FCBoxPlotMake(double median, double lowerQuartile, double upperQuartile, double sampleMinimum, double sampleMaximum);

/* ENUM */

// * GRAPH MODES

typedef enum {
	
	FCGraphModeTimePlotHorizontal, // default
	FCGraphModeDescendantTimePlotHorizontal,
	FCGraphModeTwinTimePlotHorizontal,
	FCGraphModeTimeBandHorizontal,
	FCGraphModeDescendantTimeBandHorizontal
	
} FCGraphMode;

NSString * FCGraphModeAsString(FCGraphMode mode);

typedef enum {

	FCGraphScaleModeData, // default
	FCGraphScaleModeDates
	
} FCGraphScaleMode;

typedef enum {

	FCGraphScaleDateLevelHours, // default
	FCGraphScaleDateLevelDays,
	FCGraphScaleDateLevelMonths,
	FCGraphScaleDateLevelYears
	
} FCGraphScaleDateLevel;

typedef enum {

	FCGraphScaleViewOrientationHorizontal, // default
	FCGraphScaleViewOrientationVertical
	
} FCGraphScaleViewOrientation;

typedef enum {
	
	FCGraphEntryViewModeCircle, // default
	FCGraphEntryViewModeBarVertical,
	FCGraphEntryViewModeNone,
	FCGraphEntryViewModeBarHorizontal,
	FCGraphEntryViewModeIcon
	
} FCGraphEntryViewMode;

typedef enum {
	
	FCGraphHandleModeLeftToRight,
	FCGraphHandleModeRightToLeft,
	FCGraphHandleModeTopDown,
	FCGraphHandleModeBottomUp
	
} FCGraphHandleMode;

typedef enum {
	
	FCGraphHandleThresholdNone, // default
	FCGraphHandleThresholdOpposite,
	FCGraphHandleThresholdHalf = 2,
	FCGraphHandleThresholdThird = 3,
	FCGraphHandleThresholdQuarter = 4,
	FCGraphHandleThresholdFifth = 5,
	FCGraphHandleThresholdSixth = 6
	
} FCGraphHandleThreshold;

typedef enum {
	
	FCGraphMenuModeNormal,
	FCGraphMenuModeSelect,
	FCGraphMenuModeGraphOptions,
	FCGraphMenuModeGeneralOptions,
	FCGraphMenuModeReorder
	
} FCGraphMenuMode;

// * APP MODES

typedef enum {
	
	FCDateDisplayDate, // default
	FCDateDisplayYears
	
} FCDateDisplay;

NSString * FCDateDisplayAsString(FCDateDisplay display);

typedef enum {
	
	FCPropertyDateTime,
	FCPropertyUnit,
	FCPropertyUnitQuantity,
	FCPropertyUnitSystem,
	FCPropertyIcon,
	FCPropertyColor
	
} FCProperty;

typedef enum {
	
	FCSortByDate, // default
	FCSortByCategory,
	FCSortByAttachment
	
} FCSortBy;

NSString * FCSortByAsString(FCSortBy sortBy);
NSInteger FCSortByCount();

// * SYSTEM STRUCTURES

typedef enum {

	FCUnitSystemMetric, // default
	FCUnitSystemImperial,
	FCUnitSystemCustomary
	
} FCUnitSystem;

NSString * FCUnitSystemAsString(FCUnitSystem system);

typedef enum {
	
	FCUnitQuantityGlucose,
	FCUnitQuantityInsulin,
	FCUnitQuantityLength,
	FCUnitQuantityNutrition,
	FCUnitQuantityTime,
	FCUnitQuantityVolume,
	FCUnitQuantityWeight
	
} FCUnitQuantity;

NSString *FCUnitQuantityAsString(FCUnitQuantity quantity);
NSInteger FCUnitQuantityCount();

typedef enum {
	
	FCTabProfile,
	FCTabGlucose,
	FCTabTags,
	FCTabRecording,
	FCTabLog
	
} FCTab;

NSString * FCTabAsString(FCTab tab);