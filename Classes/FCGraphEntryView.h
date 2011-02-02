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
//  FCGraphEntryView.h
//  Future2
//
//  Created by Anders Sigfridsson on 27/09/2010.
//

#import <UIKit/UIKit.h>


@interface FCGraphEntryView : UIView {

	id <FCGraphEntryViewDelegate> delegate;
	
	FCGraphEntryViewMode mode;
	
	NSNumber *xValue;
	NSNumber *yValue;
	NSString *key;
	
	CGPoint anchor;
	
	UIColor *color;
	
	UILabel *label;
	UIImageView *icon;
}

@property (assign) id <FCGraphEntryViewDelegate> delegate;

@property (nonatomic) FCGraphEntryViewMode mode;

@property (nonatomic, retain) NSNumber *xValue;
@property (nonatomic, retain) NSNumber *yValue;
@property (nonatomic, retain) NSString *key;

@property (nonatomic) CGPoint anchor;

@property (nonatomic, retain) UIColor *color;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *icon;

// Init

-(id)initWithXValue:(NSNumber *)theXValue yValue:(NSNumber *)theYValue key:(NSString *)theKey;

// Drawing

-(void)drawInContext:(CGContextRef)context;

// Animation

-(void)animateDoublePulse;
-(void)animatePulse;
-(void)animateGrowth;
-(void)animateShrink;

// Set

-(void)setAnchor:(CGPoint)newAnchor;

// Custom

-(void)position;
-(void)showLabelForYValueUsingNumberFormatter:(NSNumberFormatter *)theFormatter;

@end
