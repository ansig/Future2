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
//  FCGraphView.m
//  GraphExperiment2
//
//  Created by Anders Sigfridsson on 13/07/2010.
//

#import "FCGraphView.h"


@implementation FCGraphView

@synthesize drawXScale, drawYScale;
@synthesize drawXAxis, drawYAxis;
@synthesize drawCurves, drawLines;
@synthesize drawAverage, drawMedian, drawIQR, drawReferenceRanges;
@synthesize drawText;

@synthesize xScaleRef, yScaleRef;
@synthesize dataSetsRef;

@synthesize topColor, bottomColor;

#pragma mark Instance

-(id)initWithFrame:(CGRect)theFrame xScale:(FCGraphScale *)theXScale yScale:(FCGraphScale *)theYScale {
	
	if (self = [super initWithFrame:theFrame]) {
		
		xScaleRef = [theXScale retain];
		yScaleRef = [theYScale retain];
	}
	
	return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[xScaleRef release];
	[yScaleRef release];
	
	[dataSetsRef release];
	
	[topColor release];
	[bottomColor release];
	
	[super dealloc];
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
   
	// Get the graphics context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Clear the context
	CGContextClearRect(context, rect);
	
	// Call actual draw method
	[self drawInContext:context];
}

-(void)drawInContext:(CGContextRef)context {
	
	// * Draw a gradient background
	
	CGColorRef topColorRef = self.topColor != nil ? [self.topColor CGColor] : [[UIColor grayColor] CGColor];
	CGColorRef bottomColorRef = self.bottomColor != nil ? [self.bottomColor CGColor] : [[UIColor whiteColor] CGColor];
	NSArray *colors = [NSArray arrayWithObjects: (id)topColorRef, (id)bottomColorRef, nil];
	CGFloat locations[] = {0, 1};
	
	CGGradientRef gradient = CGGradientCreateWithColors(CGColorGetColorSpace(topColorRef), (CFArrayRef)colors, locations);

	CGRect bounds = self.bounds;
	CGPoint top = CGPointMake(CGRectGetMidX(bounds), bounds.origin.y);
	CGPoint bottom = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
	
	CGContextDrawLinearGradient(context, gradient, top, bottom, 0);
	
	CGGradientRelease(gradient);
	
	// * Draw content according to preferences
	
	if (self.drawXAxis)
		[self drawXAxisInContext:context];
	
	if (self.drawYAxis)
		[self drawYAxisInContext:context];
	
	if (self.drawXScale)
		[self drawXScaleInContext:context];
	
	if (self.drawYScale)
		[self drawYScaleInContext:context];
	
	if (self.drawIQR)
		[self drawInterquartileRangeForYInContext:context];
	
	if (self.drawReferenceRanges)
		[self drawReferenceRangesForYInContext:context];
	
	if (self.drawCurves)
		[self drawCurvesInContext:context];
	
	if (self.drawLines)
		[self drawLinesInContext:context];
	
	if (self.drawAverage)
		[self drawAverageForYValuesInContext:context];
	
	if (self.drawMedian)
		[self drawMedianForYValuesInContext:context];
}

-(void)drawXScaleInContext:(CGContextRef)context {
/*	Draws vertical lines for the primary units of the x scale. */
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	CGContextSetRGBStrokeColor(context, 0, 0, 0, kGraphGridAlpha); // COLOR
	CGContextSetLineWidth(context, 1); // WIDTH
	
	CGFloat padding = self.xScaleRef.padding;
	CGFloat totalPadding = padding * 2;
	
	CGFloat step;
	
	if (self.xScaleRef.mode == FCGraphScaleModeData) {
		
		NSInteger range = self.xScaleRef.integerDataRange;
		step = (width-totalPadding) / range;
		
	} else if (xScaleRef.mode == FCGraphScaleModeDates) {
		
		// OBS! The use of dateUnits is assuming that the scales date range is dividable
		// into a whole number of hours, days, months, or years.
		
		NSInteger dateUnits = xScaleRef.dateRangeInUnits;
		step = (width-totalPadding) / dateUnits;
	}
	
	int units = self.xScaleRef.units;
	
	CGFloat xPos;
	
	for (int i = 0; i < units; i++) {
		
		xPos = (step*i)+padding;
		CGContextMoveToPoint(context, xPos, 0.0f);
		CGContextAddLineToPoint(context, xPos, height);
	}
	
	CGContextStrokePath(context);
}

-(void)drawYScaleInContext:(CGContextRef)context {
/*	Draws horizontal lines for the primary units in the y scale. */
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	CGContextSetRGBStrokeColor(context, 0, 0, 0, kGraphGridAlpha); // COLOR
	CGContextSetLineWidth(context, 1); // WIDTH
	
	CGFloat padding = self.yScaleRef.padding;
	CGFloat totalPadding = padding * 2;
	
	CGFloat step;
	
	if (self.yScaleRef.mode == FCGraphScaleModeData) {
		
		NSInteger range = self.yScaleRef.integerDataRange;
		step = (height-totalPadding) / range;
		
	} else if (yScaleRef.mode == FCGraphScaleModeDates) {
		
		NSInteger dateUnits = yScaleRef.dateRangeInUnits;
		step = (height-totalPadding) / dateUnits;
	}
	
	int units = self.yScaleRef.units;
	
	CGFloat yPos;
	
	for (int i = 0; i < units; i++) {
		
		yPos = (step*i)+padding;
		CGContextMoveToPoint(context, 0.0f, yPos);
		CGContextAddLineToPoint(context, width, yPos);
	}
	
	CGContextStrokePath(context);
}

-(void)drawXAxisInContext:(CGContextRef)context {
/*	Draws a lines showing the x axis. */
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	CGFloat padding = self.xScaleRef.padding;
	
	CGContextSetRGBStrokeColor(context, 0, 0, 0, kGraphAxisAlpha); // COLOR
	CGContextSetLineWidth(context, 2); // WIDTH
	
	CGContextMoveToPoint(context, 0.0f + padding, height - padding);
	CGContextAddLineToPoint(context, width - padding, height - padding);
	
	CGContextStrokePath(context);
}

-(void)drawYAxisInContext:(CGContextRef)context {
/*	Draws a line showing the y axis. */
	
	CGFloat height = self.frame.size.height;
	
	CGFloat padding = self.yScaleRef.padding;
	
	CGContextSetRGBStrokeColor(context, 0, 0, 0, kGraphAxisAlpha); // COLOR
	CGContextSetLineWidth(context, 2); // WIDTH
	
	CGContextMoveToPoint(context, 0.0f + padding, 0.0f + padding);
	CGContextAddLineToPoint(context, 0.0f + padding, height - padding);
	
	CGContextStrokePath(context);
}

-(void)drawCurvesInContext:(CGContextRef)context {
/*	Draws colored curves crossing through all the datum in each data set. */
	
}

-(void)drawLinesInContext:(CGContextRef)context {
/*	Draws colored, straight lines between each datum in all data sets. */
	
	if (self.dataSetsRef != nil) {
		
		CGContextSetLineWidth(context, kGraphLinesWidth); // WIDTH
		
		for (NSArray *dataSet in self.dataSetsRef) {
			
			if ([dataSet count] > 1) {
			
				// color
				UIColor *color = [[[dataSet lastObject] color] colorWithAlphaComponent:kGraphLinesAlpha]; // COLOR
				CGContextSetStrokeColorWithColor(context, color.CGColor);
				
				// start point
				FCGraphEntryView *firstDatum = [dataSet objectAtIndex:0];
				CGContextMoveToPoint(context, firstDatum.anchor.x, firstDatum.anchor.y);
				
				NSRange range = NSMakeRange(1, [dataSet count]-1); // excludes first datum
				NSArray *subDataSet = [[NSArray alloc] initWithArray:[dataSet subarrayWithRange:range]];
				for (FCGraphEntryView *datum in subDataSet) {
					
					// lines
					CGContextAddLineToPoint(context, datum.anchor.x, datum.anchor.y);
				}
				
				[subDataSet release];
				
				// draw path
				CGContextStrokePath(context);
			}
		}
	}
}

-(void)drawAverageForYValuesInContext:(CGContextRef)context {
/*	Draws a colored line along the average Y value. */
	
	if (self.dataSetsRef != nil) {
		
		CGContextSetLineWidth(context, kGraphAverageWidth); // WIDTH
		
		for (FCGraphDataSet *dataSet in self.dataSetsRef) {
			
			if ([dataSet count] > 1) {
			
				// get average
				double average = [dataSet averageY];
				
				// start and end points
				FCGraphEntryView *firstDatum = [dataSet objectAtIndex:0];
				CGPoint startPoint = [self positionForX:[firstDatum.xValue doubleValue] y:average];
				
				FCGraphEntryView *lastDatum = [dataSet lastObject];
				CGPoint endPoint = [self positionForX:[lastDatum.xValue doubleValue] y:average];
				
				// color
				UIColor *color = [[lastDatum color] colorWithAlphaComponent:kGraphAverageAlpha]; // COLOR
				CGContextSetStrokeColorWithColor(context, color.CGColor);
				
				// draw lines
				CGContextMoveToPoint(context, startPoint.x, startPoint.y);
				CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
				
				CGContextStrokePath(context);
				
				if (self.drawText) {
					
					// add descriptive text along the line
					
					const char * text = [[NSString stringWithFormat:@"Average: %f", average] UTF8String];
					
					CGContextSelectFont(context, "Courier", 8.0f, kCGEncodingMacRoman); // FONT
					CGContextSetTextDrawingMode(context, kCGTextFill);
					CGContextSetRGBFillColor(context, 255, 255, 255, 1.0f); // COLOR
					
					// flip vertical
					CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);;
					CGContextSetTextMatrix(context, textTransform);
					
					CGFloat length = endPoint.x - startPoint.x;
					for (int x = startPoint.x; x < startPoint.x + length; x += kGraphLabelSpacing)
						CGContextShowTextAtPoint(context, x, startPoint.y, text, strlen(text));
				}
			}
		}
	}
}

-(void)drawMedianForYValuesInContext:(CGContextRef)context {
/*	Draws a colored line along the median of y values. */
	
	if (self.dataSetsRef != nil) {
		
		CGContextSetLineWidth(context, kGraphMedianWidth); // WIDTH
		
		for (FCGraphDataSet *dataSet in self.dataSetsRef) {
			
			if ([dataSet count] > 2) {
				
				// get median
				double median = dataSet.yBoxPlot.median;
				
				// start and end points
				FCGraphEntryView *firstDatum = [dataSet objectAtIndex:0];
				CGPoint startPoint = [self positionForX:[firstDatum.xValue doubleValue] y:median];
				
				FCGraphEntryView *lastDatum = [dataSet lastObject];
				CGPoint endPoint = [self positionForX:[lastDatum.xValue doubleValue] y:median];
				
				// color
				UIColor *color = [[lastDatum color] colorWithAlphaComponent:kGraphMedianAlpha];
				CGContextSetStrokeColorWithColor(context, color.CGColor);
				
				// draw lines
				CGContextMoveToPoint(context, startPoint.x, startPoint.y);
				CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
				
				CGContextStrokePath(context);
				
				if (self.drawText) {
					
					// add descriptive text along the line
					
					const char * text = [[NSString stringWithFormat:@"Median: %f", median] UTF8String];
					
					CGContextSelectFont(context, "Courier", 8.0f, kCGEncodingMacRoman); // FONT
					CGContextSetTextDrawingMode(context, kCGTextFill);
					CGContextSetRGBFillColor(context, 255, 255, 255, 1.0f); // COLOR
					
					// flip vertical
					CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);;
					CGContextSetTextMatrix(context, textTransform);
					
					CGFloat length = endPoint.x - startPoint.x;
					for (int x = startPoint.x; x < startPoint.x + length; x += kGraphLabelSpacing)
						CGContextShowTextAtPoint(context, x, startPoint.y, text, strlen(text));
				}
			}
		}
	}
}

-(void)drawInterquartileRangeForYInContext:(CGContextRef)context {
/*	Draws a colored box covering the interquartile range for y values. */
	
	if (self.dataSetsRef != nil) {
		
		for (FCGraphDataSet *dataSet in self.dataSetsRef) {
			
			if ([dataSet count] > 2) {
				
				// get upper and lower quartiles
				double lowerQuartile = dataSet.yBoxPlot.lowerQuartile;
				double upperQuartile = dataSet.yBoxPlot.upperQuartile;
				
				// first and last datum
				FCGraphEntryView *firstDatum = [dataSet objectAtIndex:0];
				FCGraphEntryView *lastDatum = [dataSet lastObject];
				
				// rect size
				CGPoint upperLeftCorner = [self positionForX:[firstDatum.xValue doubleValue] y:upperQuartile];
				CGPoint lowerRightCorner = [self positionForX:[lastDatum.xValue doubleValue] y:lowerQuartile];
				
				CGFloat width = lowerRightCorner.x - upperLeftCorner.x;
				CGFloat height = lowerRightCorner.y - upperLeftCorner.y;
				
				CGRect rect = CGRectMake(upperLeftCorner.x, upperLeftCorner.y, width, height);
				
				// color
				UIColor *color = [[lastDatum color] colorWithAlphaComponent:kGraphZoneAlpha]; // COLOR
				CGContextSetFillColorWithColor(context, color.CGColor);
				
				// fill rect
				CGContextFillRect(context, rect);
				
				if (self.drawText) {
					
					// add descriptive text along the line
					
					const char * text1 = [[NSString stringWithFormat:@"Upper quartile %f", upperQuartile] UTF8String];
					const char * text2 = [[NSString stringWithFormat:@"Lower quartile: %f", lowerQuartile] UTF8String];
					
					CGContextSelectFont(context, "Courier", 8.0f, kCGEncodingMacRoman); // FONT
					CGContextSetTextDrawingMode(context, kCGTextFill);
					
					UIColor *color = [[lastDatum color] colorWithAlphaComponent:1.0f]; // COLOR
					CGContextSetFillColorWithColor(context, color.CGColor);
					
					// flip vertical
					CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);;
					CGContextSetTextMatrix(context, textTransform);
					
					CGFloat length = lowerRightCorner.x - upperLeftCorner.x;
					for (int x = upperLeftCorner.x; x < upperLeftCorner.x + length; x += kGraphLabelSpacing) {
						
						CGContextShowTextAtPoint(context, x, upperLeftCorner.y, text1, strlen(text1));
						CGContextShowTextAtPoint(context, x, lowerRightCorner.y, text2, strlen(text2));
					}
				}
			}
		}
	}
}

-(void)drawReferenceRangesForYInContext:(CGContextRef)context {
/*	Draws a colored box covering each reference range for y values. */
	
	if (self.dataSetsRef != nil) {
	
		for (FCGraphDataSet *dataSet in self.dataSetsRef) {
		
			// Y reference ranges
			if (dataSet.yReferenceRanges != nil) {
				
				for (FCGraphReferenceRange *range in dataSet.yReferenceRanges) {
				
					// get upper and lower limits
					double lowerLimit = [range.lowerLimit doubleValue];
					double upperLimit = [range.upperLimit doubleValue];
					
					// last datum (for getting color)
					FCGraphEntryView *lastDatum = [dataSet lastObject];
					
					// rect size
					CGPoint upperLeftCorner = [self positionForX:0.0 y:upperLimit];
					CGPoint lowerRightCorner = [self positionForX:(double)self.frame.size.width y:lowerLimit];
					
					CGFloat width = self.frame.size.width;
					CGFloat height = lowerRightCorner.y - upperLeftCorner.y;
					
					CGRect rect = CGRectMake(0.0f, upperLeftCorner.y, width, height);
					
					// color
					UIColor *color = [[lastDatum color] colorWithAlphaComponent:kGraphZoneAlpha]; // COLOR
					CGContextSetFillColorWithColor(context, color.CGColor);
					
					// fill rect
					CGContextFillRect(context, rect);
					
					if (self.drawText) {
						
						// add descriptive text along the line
						
						const char * text1 = [[NSString stringWithFormat:@"%@ < %f", range.name, upperLimit] UTF8String];
						const char * text2 = [[NSString stringWithFormat:@"%@ > %f", range.name, lowerLimit] UTF8String];
											
						CGContextSelectFont(context, "Courier", 8.0f, kCGEncodingMacRoman); // FONT
						CGContextSetTextDrawingMode(context, kCGTextFill);
						
						UIColor *color = [[lastDatum color] colorWithAlphaComponent:1.0f]; // COLOR
						CGContextSetFillColorWithColor(context, color.CGColor);
						
						// flip vertical
						CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);;
						CGContextSetTextMatrix(context, textTransform);
					
						for (int x = upperLeftCorner.x; x <  width; x += kGraphLabelSpacing) {
							
							CGContextShowTextAtPoint(context, x, upperLeftCorner.y, text1, strlen(text1));
							CGContextShowTextAtPoint(context, x, lowerRightCorner.y, text2, strlen(text2));
						}
					}
				}
			}
		}
	}
}

#pragma mark Custom

-(void)drawGrid:(BOOL)flag {

	self.drawXScale = flag;
	self.drawYScale = flag;
}

-(void)drawAxes:(BOOL)flag {

	self.drawXAxis = flag;
	self.drawYAxis = flag;
}

-(CGPoint)positionForX:(double)x y:(double)y {
/*	Returns the exact CGPoint for the given x and y values. */
	
	double range = self.xScaleRef.range;
	CGFloat space = self.frame.size.width - (kGraphPadding*2);
	
	CGFloat xPosition = kGraphPadding + ((space/range)*x);
	
	range = self.yScaleRef.range;
	space = self.frame.size.height - (kGraphPadding*2);
	
	CGFloat yPosition = self.frame.size.height - (kGraphPadding + ((space/range)*y));
	
	return CGPointMake(xPosition, yPosition);
}

-(CGSize)sizeForPosition:(CGPoint)thePosition {
/*	Returns the distances from the position to the x and y scale as height and width respectively. */
	
	CGFloat width = self.frame.size.width - thePosition.x;
	CGFloat height = self.frame.size.height - thePosition.y;
	
	return CGSizeMake(width, height);
}
	
@end
