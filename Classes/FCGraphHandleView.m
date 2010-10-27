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
//  FCGraphHandleView.m
//  Future2
//
//  Created by Anders Sigfridsson on 06/10/2010.
//

#import "FCGraphHandleView.h"


#import <QuartzCore/QuartzCore.h>

@implementation FCGraphHandleView

@synthesize delegate;
@synthesize mode;
@synthesize range, offset;
@synthesize lowerThreshold, upperThreshold;
@synthesize cornerRadius;
@synthesize color, label;

#pragma mark Init

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {

		// default background is transparent
		self.backgroundColor = [UIColor clearColor];
		
		// default corner radius
		self.cornerRadius = 10.0f;
    }
	
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[color release];
	[label release];
 
	[super dealloc];
}

#pragma mark Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    // Get the graphics context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// DRAW A RECT WITH ROUNDED CORNERS
	
	// color
	
	CGContextSetFillColorWithColor(context, self.color.CGColor);
	
	// variables
	
	CGFloat width = rect.size.width;
	CGFloat height = rect.size.height;
	
	CGFloat radius = self.cornerRadius;
	
	NSInteger count = 13;
	CGPoint points[13] = {	
			
			CGPointMake(radius, radius),
			CGPointMake(radius, 0.0f),
			CGPointMake(width - radius, 0.0f),
			CGPointMake(width - radius, radius),
			CGPointMake(width, radius),
			CGPointMake(width, height - radius),
			CGPointMake(width - radius, height - radius),
			CGPointMake(width - radius, height),
			CGPointMake(radius, height),
			CGPointMake(radius, height - radius),
			CGPointMake(0.0f, height - radius),
			CGPointMake(0.0f, radius),
			CGPointMake(radius, radius) };
	
	// paths
	
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, points[0].x, points[0].y);
	
	for (int i = 1; i < count; i++) {
		
		CGContextAddLineToPoint(context, points[i].x, points[i].y);
	}
	
	CGContextFillPath(context);
	
	CGContextBeginPath(context);
	
	CGContextAddArc(context, radius, radius, radius, degreesToRadian(180), degreesToRadian(270), NO); // upper left corner
	CGContextAddArc(context, radius, height - radius, radius, degreesToRadian(90), degreesToRadian(180), NO); // lower left corner
	
	CGContextAddArc(context, width - radius, height - radius, radius, degreesToRadian(0), degreesToRadian(90), NO); // lower right corner
	CGContextAddArc(context, width - radius, radius, radius, degreesToRadian(270), degreesToRadian(90), NO); // upper right corner
	
	CGContextFillPath(context);
}

#pragma mark Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// get the touch
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	
	// count taps
	NSInteger taps = touch.tapCount;
	
	// if we have 2 or more taps, scroll to either end of range and inform delegate
	if (taps >= 2) {
	
		if (self.offset > 0) {
		
			// scroll to bottom
			
			[self addOffset:-self.range withAnimation:YES];
			
			// inform delegate after delay allowing for the animation to complete
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleDidTapScrollToBottom)])
				[(UIResponder *)self.delegate performSelector:@selector(handleDidTapScrollToBottom) withObject:nil afterDelay:kLockDuration];
			
		} else {
			
			// scroll to top
			[self addOffset:self.range withAnimation:YES];
			
			// inform delegate after delay allowing for the animation to complete
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleDidTapScrollToTop)])
				[(UIResponder *)self.delegate performSelector:@selector(handleDidTapScrollToTop) withObject:nil afterDelay:kLockDuration];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// get the touch
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	
	// calculate offset
	CGPoint oldPoint = [touch previousLocationInView:self.superview];
	CGPoint newPoint = [touch locationInView:self.superview];
	
	CGFloat addend;
	if (self.mode == FCGraphHandleModeLeftToRight)
		addend = newPoint.x - oldPoint.x;
	
	else if (self.mode == FCGraphHandleModeRightToLeft)
		addend = oldPoint.x - newPoint.x;
	
	else if (self.mode == FCGraphHandleModeTopDown)
		addend = newPoint.y - oldPoint.y;
	
	else if (self.mode == FCGraphHandleModeBottomUp)
		addend = oldPoint.y - newPoint.y;
	
	// move with the touch
	[self addOffset:addend withAnimation:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// get the touch
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	
	// count taps
	NSInteger taps = touch.tapCount;
	
	// only react if the tap count is 0 (since taps are handled by -touchedBegan:withEvent:)
	if (taps < 1) {
	
		// check to see if the current offset exceeds any of the thresholds
		// and act accordingly if it is
		
		BOOL crossed;
		CGFloat addend;
		
		// lower
		if ([self isBelowLowerThreshold]) {
			
			addend = -self.offset;
			crossed = YES;
			
			// notify delegate
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleReleasedBelowLowerThreshold)])
				[self.delegate handleReleasedBelowLowerThreshold];
			
		} else {
			
			// notify delegate
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleReleasedAboveLowerThreshold)])
				[self.delegate handleReleasedAboveLowerThreshold];
		}
		
		// upper
		if ([self isAboveUpperThreshold]) {
			
			addend = self.range - self.offset;
			crossed = YES;
			
			// notify delegate
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleReleasedAboveUpperThreshold)])
				[self.delegate handleReleasedAboveUpperThreshold];
			
		} else {
			
			// notify delegate
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleReleasedBelowUpperThreshold)])
				[self.delegate handleReleasedBelowUpperThreshold];
		}
		
		if (crossed)
			[self addOffset:addend withAnimation:YES];
		
	}
}

#pragma mark Animation

-(void)animateToNewFrame:(CGRect)newFrame {
	
	[UIView	animateWithDuration:kLockDuration 
						  delay:0.0f 
						options:UIViewAnimationCurveEaseOut 
					 animations:^ { self.frame = newFrame; } 
					 completion:^ (BOOL finished) { } ];
}

#pragma mark Custom

-(void)addOffset:(CGFloat)addend withAnimation:(BOOL)animated {
/*	Tries to add the given addend to the offset and moves self accordingly either instantly or by animation. */
	
	// check if adding the offset exceeds the range and adjust the addend
	CGFloat potentialOffset = self.offset + addend;
	
	if (potentialOffset > self.range)
		addend = self.range - self.offset;
		
	else if (potentialOffset < 0.0f)
		addend = -self.offset;
	
	// notify delegate
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleWillAddOffset:withAnimation:)])
		[self.delegate handleWillAddOffset:addend withAnimation:animated];
	
	// add offset
	self.offset += addend;
	
	// create new frame
	CGFloat newX = self.frame.origin.x;
	CGFloat newY = self.frame.origin.y;
	
	if (self.mode == FCGraphHandleModeLeftToRight)
		newX += addend;
	
	else if (self.mode == FCGraphHandleModeRightToLeft)
		newX -= addend;
	
	else if (self.mode == FCGraphHandleModeTopDown)
		newY += addend;
	
	else if (self.mode == FCGraphHandleModeBottomUp)
		newY -= addend;
	
	CGRect newFrame = CGRectMake(newX, newY, self.frame.size.width, self.frame.size.height);
	
	// apply new frame
	if (animated)
		[self animateToNewFrame:newFrame];
	else
		self.frame = newFrame;
	
	// notify delegate
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(handleDidAddOffset:withAnimation:)])
		[self.delegate handleDidAddOffset:addend withAnimation:animated];
}

-(BOOL)isBelowLowerThreshold {

	if (self.lowerThreshold == FCGraphHandleThresholdOpposite) {
		
		// if the option is set to opposite, test if current offset
		// is below the upper threshold
		CGFloat threshold = self.range - (self.range / self.upperThreshold);
		if (self.offset < threshold)
			return YES;
	
	} else if (self.lowerThreshold != FCGraphHandleThresholdNone) {
		
		// if the option is not none or opposite, test if current offset is
		// below the lower threshold
		CGFloat threshold = self.range / self.lowerThreshold;
		if (self.offset < threshold) 
			return YES;
	}
	
	return NO;
}

-(BOOL)isAboveUpperThreshold {
	
	if (self.upperThreshold == FCGraphHandleThresholdOpposite) {
	
		// if the option is set to opposite, test if current offset
		// is above the lower threshold
		CGFloat threshold = self.range / self.lowerThreshold;
		if (self.offset > threshold) 
			return YES;
		
	} else if (self.upperThreshold != FCGraphHandleThresholdNone) {
		
		// if the option is not none or opposite, test if current offset is
		// above the upper threshold
		CGFloat threshold = self.range - (self.range / self.upperThreshold);
		if (self.offset > threshold)
			return YES;
	}
	
	return NO;
}

-(void)createNewLabelWithText:(NSString *)text {
/*	Creates a new label, rotates it according to mode, and sets it's text to given text */
	
	// remove old label
	if (self.label != nil)
		[self.label removeFromSuperview], self.label = nil;
	
	// create a new label
	UILabel *newLabel = [[UILabel alloc] initWithFrame:self.bounds];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.textColor = [UIColor whiteColor];
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.font = [UIFont systemFontOfSize:16.0f];
	newLabel.text = text;
	
	// rotate if necessary
	if (self.mode == FCGraphHandleModeLeftToRight) {
	
		// flip width/height
		newLabel.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.height, self.bounds.size.width);
		
		// rotate anti-clockwise
		newLabel.transform = CGAffineTransformRotate(newLabel.transform, degreesToRadian(-90));
	
	} else if (self.mode == FCGraphHandleModeRightToLeft) {
		
		// flip width/height
		newLabel.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.height, self.bounds.size.width);
		
		// rotate clockwise
		newLabel.transform = CGAffineTransformRotate(newLabel.transform, degreesToRadian(90));
	}
	
	// add and release
	self.label = newLabel;
	[self addSubview:newLabel];
	
	[newLabel release];
}

@end
