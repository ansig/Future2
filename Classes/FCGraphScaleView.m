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

@synthesize scaleRef, labels;

#pragma mark Init

-(id)initWithFrame:(CGRect)theFrame scale:(FCGraphScale *)theScale orientation:(FCGraphScaleViewOrientation)theOrientation {
	
	if (self = [super initWithFrame:theFrame]) {
		
		scaleRef = [theScale retain];
		
		labels = [[scaleRef createLabelsArray] retain];
		
		orientation = theOrientation;
	}
	
	return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[labels release];
	
	[scaleRef release];
	
    [super dealloc];
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
 
	// Get the graphics context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Clear the context
	CGContextClearRect(context, rect);
	
	// Background
	UIColor *backgroundColor = [UIColor grayColor];
	CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
	CGContextFillRect(context, rect);
	
	// Call actual draw method
	[self drawInContext:context];
}

-(void)drawInContext:(CGContextRef)context {
	
	// Text color
	CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	
	// Text setup
	const char* text;
	CGContextSelectFont(context, "Courier", 14.0f, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	
	// Transform the context so that the text is shown right way up
	// alt 1: flip text vertically
	//CGAffineTransform textTransform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
	//CGContextSetTextMatrix(context, textTransform);
	
	// alt 2: change context coordinates
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1, -1);
	
	// Variables for positioning
	
	CGFloat length = orientation == FCGraphScaleViewOrientationHorizontal ? self.frame.size.width : self.frame.size.height;
	
	CGFloat padding = self.scaleRef.padding;
	CGFloat totalPadding = padding * 2;
	
	CGFloat step;
	
	if (self.scaleRef.mode == FCGraphScaleModeDates) {
		
		// OBS! The use of dateUnits is assuming that the scales date range is dividable
		// into a whole number of hours, days, months, or years.
		
		NSInteger dateUnits = self.scaleRef.dateRangeInUnits;
		step = (length-totalPadding)/dateUnits;
	
	} else if (self.scaleRef.mode == FCGraphScaleModeData) {
		
		NSInteger range = self.scaleRef.integerDataRange;
		step = (length-totalPadding)/range;
	}
	
	UIFont *font = [UIFont fontWithName:@"Courier" size:14.0f];		// For determining the length of the text and centering its position
	CGSize textSize;												// OBS! Make sure font here is the same as is set in the context above!
	
	CGFloat xPos;
	CGFloat yPos;
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
		
	// Draw text
	
	NSInteger units = self.scaleRef.units;
	int j = 0; // Label counter
	BOOL display = YES; // Display flag
	for (int i = 0; i < units; i++) {
		
		if (self.scaleRef.mode == FCGraphScaleModeData) {
		
			if (i % self.scaleRef.integerDataRangeDivisor == 0)
				display = YES;
			
			else
				display = NO;
		}
		
		if (display) {
			
			textSize = [[labels objectAtIndex:j] sizeWithFont:font];
			textSize.height -= 10;	// OBS! This manual adjustment is necessary because
									// textSize.height consistently is to large!
			
			text = [[labels objectAtIndex:j] UTF8String];
			
			if (orientation == FCGraphScaleViewOrientationHorizontal) {
				
				// Special cases to ensure full text is shown.
				// first
				if (i == 0)
					xPos = ((step*i)+padding);
				
				// last
				else if (i == units-1)
					xPos = ((step*i)+padding) - textSize.width;
				
				// normal
				else
					xPos = ((step*i)+padding) - (textSize.width/2);
				
				yPos = (height/2) - (textSize.height/2);
				
			} else {
				
				xPos = (width/2) - (textSize.width/2);
				yPos = ((step*i)+padding) - (textSize.height/2);
			}
			
			CGContextShowTextAtPoint(context, xPos, yPos, text, strlen(text));
			
			j++;
		}
	}
}

#pragma mark Get

-(FCGraphScaleViewOrientation)orientation {
	
	return orientation;
}

@end
