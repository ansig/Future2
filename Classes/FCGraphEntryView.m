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
//  FCGraphEntryView.m
//  Future2
//
//  Created by Anders Sigfridsson on 27/09/2010.
//

#import "FCGraphEntryView.h"


@implementation FCGraphEntryView

@synthesize delegate;
@synthesize mode;
@synthesize xValue, yValue, key;
@synthesize anchor;
@synthesize color;
@synthesize label, icon;

#pragma mark Init

-(id)initWithXValue:(NSNumber *)theXValue yValue:(NSNumber *)theYValue key:(NSString *)theKey {

	if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kGraphEntryViewDiameter, kGraphEntryViewDiameter)]) {
		
		self.backgroundColor = [UIColor clearColor];
		
		xValue = [theXValue retain];
		yValue = [theYValue retain];
		key = [theKey retain];
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {
	
	[xValue release];
	[yValue release];
	[key  release];
	
	[color release];
	
	[label release];
	[icon release];
	
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
/*	Draws a colored shape reaching top-bottom and left-right of the entire view. */
	
	// Setup the fill color
	CGColorRef cgColor = self.color.CGColor;
	const CGFloat *components = CGColorGetComponents(cgColor);
	CGContextSetFillColor(context, components);
	
	// DRAW
	
	// circle mode (default)
	if (self.mode == FCGraphEntryViewModeCircle)
		CGContextFillEllipseInRect(context, CGRectMake(1.0f, 1.0f, self.frame.size.width-2, self.frame.size.height-2)); // one less on each side to avoid clipping
	
	// bar mode
	else if (self.mode == FCGraphEntryViewModeBarVertical || self.mode == FCGraphEntryViewModeBarHorizontal)
		CGContextFillRect(context, CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height));
	
	// icon mode
	else if (self.mode == FCGraphEntryViewModeIcon && 
			 self.delegate != nil && 
			 [self.delegate conformsToProtocol:@protocol(FCGraphEntryViewDelegate)]) {
		
		// request the image
		UIImage *anIcon = [self.delegate iconForEntryViewWithKey:self.key];
		if (anIcon != nil) {
			
			CALayer *caLayer = self.layer;
			
			[caLayer setBorderWidth:2.0];
			[caLayer setCornerRadius:5.0];
			[caLayer setBorderColor:[self.color CGColor]];
			
			[caLayer setBackgroundColor:[[self.color colorWithAlphaComponent:0.5f] CGColor]];
			
			// draw it
			
			CGSize iconSize = anIcon.size;
			CGSize viewSize = self.bounds.size;
			
			CGFloat width = viewSize.width < iconSize.width ? viewSize.width : iconSize.width; // whichever one is smaller
			CGFloat height = viewSize.height < iconSize.height ? viewSize.height : iconSize.height; // whichever on is smaller
			CGFloat xPos = (viewSize.width/2) - (width/2);
			CGFloat yPos = (viewSize.height/2) - (height/2);
			
			[anIcon drawInRect:CGRectMake(xPos, yPos, width, height)];		
		}
	}
}

#pragma mark Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// inform delegate
	if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(FCGraphEntryViewDelegate)])
		[self.delegate touchOnEntryWithAnchorPoint:self.anchor superview:self.superview key:self.key];
	
	// pulse
	[self animateDoublePulse];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

#pragma mark Animation

-(void)animateDoublePulse {

	// does two pulses in a row
	[self animatePulse];
	[self performSelector:@selector(animatePulse) withObject:nil afterDelay:kGrowthDuration+kShrinkDuration];
}

-(void)animatePulse {
	
	// grows to define scale and shrinks back to original size
	[UIView	animateWithDuration:kGrowthDuration 
			animations:^{ self.transform = CGAffineTransformMakeScale(kGraphEntryViewGrowthScale, kGraphEntryViewGrowthScale); }
			completion: ^(BOOL finished) { [self animateShrink]; } ];
}

-(void)animateGrowth {

	// grow to defined scale on touch
	[UIView	animateWithDuration:kGrowthDuration 
					 animations:^{ self.transform = CGAffineTransformMakeScale(kGraphEntryViewGrowthScale, kGraphEntryViewGrowthScale); } ];
}

-(void)animateShrink {
	
	// shrink back to original size
	[UIView	animateWithDuration:kShrinkDuration 
					 animations:^{ self.transform = CGAffineTransformIdentity; } ];
}

#pragma mark Set

-(void)setAnchor:(CGPoint)newAnchor {
/*	Sets the new anchor point and also re-positions accordingly. */

	anchor = newAnchor;
	
	[self position];
}

#pragma mark Custom

-(void)position {
/*	Puts the view on its right position and resizes if necessary, all according to current anchor point and mode.*/
	
	if (self.mode == FCGraphEntryViewModeBarVertical || self.mode == FCGraphEntryViewModeBarHorizontal) {
		
		// for bars, level their top with the anchor and also resize them to
		// extend all the way to the correct edge
		
		CGFloat width;
		CGFloat height;
		CGFloat xPos;
		CGFloat yPos;
		
		if (self.delegate != nil && [self.delegate conformsToProtocol:@protocol(FCGraphEntryViewDelegate)]) {
			
			CGSize sizeForPosition = [self.delegate sizeForEntryViewWithAnchor:self.anchor];
			if (self.mode == FCGraphEntryViewModeBarVertical) {
				
				width = self.frame.size.width;
				height = sizeForPosition.height;
				xPos = self.anchor.x - (self.frame.size.width/2);
				yPos = self.anchor.y;
				
			} else if (self.mode == FCGraphEntryViewModeBarHorizontal) {
				
				width = sizeForPosition.width;
				height = self.frame.size.height;
				xPos = self.anchor.x;
				yPos = self.anchor.y - (self.frame.size.height/2);
			}
			
			self.frame = CGRectMake(xPos, yPos, width, height);
		}
		
	} else {
		
		// resize if necessary (happens when mode has been changed from bar to circle/icon)
		CGFloat diameter = self.label != nil ? self.label.frame.size.width : kGraphEntryViewDiameter;
		if (self.frame.size.width > diameter || self.frame.size.height > diameter)
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, diameter, diameter);
		
		// center on correct position
		self.center = self.anchor;
	}
}

-(void)showLabelForYValueUsingNumberFormatter:(NSNumberFormatter *)theFormatter {
	
	// get the formatted text
	NSString *text = [theFormatter stringFromNumber:yValue];
	
	// required size
	UIFont *font = [UIFont systemFontOfSize:12.0f];
	CGSize size = [text sizeWithFont:font];
	CGFloat diameter = size.width > kGraphEntryViewDiameter ? size.width : kGraphEntryViewDiameter;
															   
	// if necessary, resize the view to fit the text
	if (diameter > kGraphEntryViewDiameter) {
		
		self.frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
		[self setNeedsDisplay];
	}
	
	// create the label
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, diameter, diameter)];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.font = font;
	newLabel.textColor = [UIColor whiteColor];
	newLabel.textAlignment = UITextAlignmentCenter;
	
	newLabel.text = text;
	
	// add to self and release
	self.label = newLabel;
	[self addSubview:newLabel];
	
	[newLabel release];
}

@end
