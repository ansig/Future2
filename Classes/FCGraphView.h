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
//  FCGraphView.h
//  GraphExperiment2
//
//  Created by Anders Sigfridsson on 13/07/2010.
//

#import <UIKit/UIKit.h>


#import <QuartzCore/QuartzCore.h>
#import "FCGraphEntryView.h"
#import "FCGraphScale.h"
#import "FCGraphDataSet.h"
#import "FCGraphReferenceRange.h"

@interface FCGraphView : UIView {
	
	BOOL drawXScale;
	BOOL drawYScale;
	BOOL drawXAxis;
	BOOL drawYAxis;
	BOOL drawCurves;
	BOOL drawLines;
	BOOL drawAverage;
	BOOL drawMedian;
	BOOL drawIQR;
	BOOL drawReferenceRanges;
	BOOL drawText;

	FCGraphScale *xScaleRef;
	FCGraphScale *yScaleRef;
	
	NSMutableArray *dataSetsRef;
	
	UIColor *topColor;
	UIColor *bottomColor;
}

@property (nonatomic) BOOL drawXScale;
@property (nonatomic) BOOL drawYScale;
@property (nonatomic) BOOL drawXAxis;
@property (nonatomic) BOOL drawYAxis;
@property (nonatomic) BOOL drawCurves;
@property (nonatomic) BOOL drawLines;
@property (nonatomic) BOOL drawAverage;
@property (nonatomic) BOOL drawMedian;
@property (nonatomic) BOOL drawIQR;
@property (nonatomic) BOOL drawReferenceRanges;
@property (nonatomic) BOOL drawText;

@property (nonatomic, retain) FCGraphScale *xScaleRef;
@property (nonatomic, retain) FCGraphScale *yScaleRef;
@property (nonatomic, retain) NSMutableArray *dataSetsRef;

@property (nonatomic, retain) UIColor *topColor;
@property (nonatomic, retain) UIColor *bottomColor;

// Init

-(id)initWithFrame:(CGRect)theFrame xScale:(FCGraphScale *)theXScale yScale:(FCGraphScale *)theYScale;

// Drawing

-(void)drawInContext:(CGContextRef)context;

-(void)drawXScaleInContext:(CGContextRef)context;
-(void)drawYScaleInContext:(CGContextRef)context;

-(void)drawXAxisInContext:(CGContextRef)context;
-(void)drawYAxisInContext:(CGContextRef)context;

-(void)drawCurvesInContext:(CGContextRef)context;
-(void)drawLinesInContext:(CGContextRef)context;

-(void)drawAverageForYValuesInContext:(CGContextRef)context;

-(void)drawMedianForYValuesInContext:(CGContextRef)context;
-(void)drawInterquartileRangeForYInContext:(CGContextRef)context;
-(void)drawReferenceRangesForYInContext:(CGContextRef)context;


// Custom

-(void)drawGrid:(BOOL)flag;
-(void)drawAxes:(BOOL)flag;

-(CGPoint)positionForX:(double)x y:(double)y;
-(CGSize)sizeForPosition:(CGPoint)thePosition;

@end
