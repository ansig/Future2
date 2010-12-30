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
//  FCGraphScaleView.m
//  GraphExperiment2
//
//  Created by Anders Sigfridsson on 13/07/2010.
//

#import "FCGraphScaleView.h"

@implementation FCGraphScaleView

@synthesize scaleRef;
@synthesize orientation;

#pragma mark Init

-(id)initWithFrame:(CGRect)theFrame scale:(FCGraphScale *)theScale orientation:(FCGraphScaleViewOrientation)theOrientation {
	
	if (self = [super initWithFrame:theFrame]) {
		
		scaleRef = [theScale retain];
		
		orientation = theOrientation;
	}
	
	return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[scaleRef release];
	
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
	
	// Background
	
	if (self.scaleRef.mode == FCGraphScaleModeDates) {
		
		// gradient
	
		CGColorRef topColorRef = [[UIColor lightGrayColor] CGColor];
		CGColorRef bottomColorRef = [[UIColor darkGrayColor] CGColor];
		NSArray *colors = [NSArray arrayWithObjects: (id)topColorRef, (id)bottomColorRef, nil];
		CGFloat locations[] = {0, 1};
		
		CGGradientRef gradient = CGGradientCreateWithColors(CGColorGetColorSpace(topColorRef), (CFArrayRef)colors, locations);
		
		CGRect bounds = self.bounds;
		CGPoint top = CGPointMake(0.0f, CGRectGetMidY(bounds));
		CGPoint bottom = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
		
		CGContextDrawLinearGradient(context, gradient, top, bottom, 0);
		
		CGGradientRelease(gradient);
	
	} else {
		
		// solid
		
		UIColor *backgroundColor = [UIColor grayColor];
		CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
		CGContextFillRect(context, self.bounds);
	}
	
	[self drawLabelsInContext:context];
}

-(void)drawLabelsInContext:(CGContextRef)context {
	
	// Color
	
	const CGFloat components [] = {1.0f, 1.0f, 1.0f};
	CGContextSetStrokeColor(context, components);
	CGContextSetFillColor(context, components);
	
	// Shared variables
	
	CGFloat length = orientation == FCGraphScaleViewOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
	
	CGFloat padding = self.scaleRef.padding;
	CGFloat totalPadding = padding * 2;
	
	NSInteger divisor;
	CGFloat step;
	
	if (self.scaleRef.mode == FCGraphScaleModeData) {
	
		divisor = self.scaleRef.integerDataRangeDivisor;
		step = (length-totalPadding) / self.scaleRef.integerRange;
		
	} else {
		
		divisor = 1;
		step = (length-totalPadding) / self.scaleRef.dateRangeInUnits;
	}
	
	NSInteger units = self.scaleRef.wrappedUnits;
	
	// Mark variables
	
	CGFloat markHeight = 4.0f;
	
	// Text variables
	
	NSArray *labels = [self.scaleRef createLabelsArray];
	
	NSString *text;
	
	CGFloat textWidth;
	CGFloat textHeight;
	
	UITextAlignment alignment;
	
	UIFont *font = [UIFont systemFontOfSize:12.0f];
	UIFont *actualFont;
	
	CGRect textRect;
	
	// Drawing
	
	CGFloat xPos;
	CGFloat yPos;
	
	NSInteger nextLabelIndex = [labels count] - 1;
	
	switch (self.orientation) {
		
		case FCGraphScaleViewOrientationHorizontal:
				
			yPos = 0.0f;
			
			textWidth = step;
			textHeight = self.bounds.size.height - markHeight;
			alignment = UITextAlignmentLeft;
			
			for (int i = 0; i < units; i++) {
				
				if (i % divisor == 0) {
			
					xPos = (i * step) + padding;
				
					CGContextMoveToPoint(context, xPos, 0.0f);
					CGContextAddLineToPoint(context, xPos, markHeight);
		
					textRect = CGRectMake(xPos, markHeight, textWidth, textHeight);
					
					text = [labels objectAtIndex:nextLabelIndex];
					
					[text drawInRect:textRect 
							withFont:font 
					   lineBreakMode:UILineBreakModeTailTruncation
						   alignment:alignment];
					
					nextLabelIndex--;
				}
			}
			
			CGContextStrokePath(context);
			
			break;
		
		default: // FCGraphScaleViewOrientationVertical
			
			xPos = self.bounds.size.width;
			
			textWidth = self.bounds.size.width - markHeight;
			textHeight = step;
			alignment = UITextAlignmentCenter;
			
			for (int i = 0; i < units; i++) {
				
				if (i % divisor == 0) {
				
					yPos = (i * step) + padding;
				
					CGContextMoveToPoint(context, xPos, yPos);
					CGContextAddLineToPoint(context, xPos-markHeight, yPos);
					
					text = [labels objectAtIndex:nextLabelIndex];
					
					actualFont = [text fontToFitWidth:textWidth
									usingOriginalFont:font];
					
					textRect = CGRectMake(0.0f, yPos-(actualFont.lineHeight/2), textWidth, textHeight);
					
					[text drawInRect:textRect 
							withFont:actualFont
					   lineBreakMode:UILineBreakModeTailTruncation
						   alignment:alignment];
					
					nextLabelIndex--;
				}
			}
			
			CGContextStrokePath(context);
			
			break;
	}
}

@end
