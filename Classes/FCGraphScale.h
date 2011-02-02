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
//  FCGraphScale.h
//  GraphExperiment2
//
//  Created by Anders Sigfridsson on 13/07/2010.
//

#import <UIKit/UIKit.h>


@interface FCGraphScale : NSObject {

	FCGraphScaleMode mode;
	
	FCDataRange dataRange;
	FCDateRange dateRange;
	
	FCGraphScaleDateLevel level;
	
	CGFloat padding;
	CGFloat spacing;
	
	NSArray *labels;
	NSArray *specialLabels;
}

@property (nonatomic) FCGraphScaleMode mode;

@property (nonatomic) FCDataRange dataRange;
@property (nonatomic) FCDateRange dateRange;

@property (nonatomic) FCGraphScaleDateLevel level;

@property (nonatomic) CGFloat padding;
@property (nonatomic) CGFloat spacing;

@property (nonatomic, retain) NSArray *labels;
@property (nonatomic, retain) NSArray *specialLabels;

// Initialization

-(id)initWithDataRange:(FCDataRange)theRange padding:(CGFloat)thePadding;
-(id)initWithDataRange:(FCDataRange)theRange;

-(id)initWithDateRange:(FCDateRange)theRange level:(FCGraphScaleDateLevel)theLevel padding:(CGFloat)thePadding spacing:(CGFloat)theSpacing;
-(id)initWithDateRange:(FCDateRange)theRange padding:(CGFloat)thePadding spacing:(CGFloat)theSpacing;
-(id)initWithDateRange:(FCDateRange)theRange;

// Calculations

-(NSInteger)dateRangeUnits;
-(NSInteger)dateRangeUnitsDivisor;
-(NSInteger)wrappedUnits;
-(double)range;
-(NSInteger)integerRange;
-(NSInteger)integerDataRangeDivisor;
-(CGFloat)requiredLength;

// Custom

-(NSArray *)createLabelsArray;
-(NSArray *)createSpecialLabelsArray;

@end
