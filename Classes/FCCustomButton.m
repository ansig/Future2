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
//  FCCustomButton.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/12/2010.
//

#import "FCCustomButton.h"


#define kBackgroundColorAlpha			0.25f
#define kHighlightBackgroundcolorAlpha	0.5f

@implementation FCCustomButton

#pragma mark Override

+(UIButton *)buttonWithType:(UIButtonType)buttonType {

	UIButton *button = [super buttonWithType:buttonType];
	
	[button.layer setCornerRadius:5.0f];
	
	return button;
}

-(void)setBackgroundColor:(UIColor *)color {
	
	[self.layer setBorderColor:[color CGColor]];
	
	[super setBackgroundColor:[color colorWithAlphaComponent:kBackgroundColorAlpha]];
}

#pragma mark Custom

-(void)showBorder {

	[self.layer setBorderWidth:2.0];
	
	[super setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:kHighlightBackgroundcolorAlpha]];
	
	[self setNeedsDisplay];
}

-(void)hideBorder {
	
	[self.layer setBorderWidth:0.0];	
	
	[super setBackgroundColor:[self.backgroundColor colorWithAlphaComponent:kBackgroundColorAlpha]];
	
	[self setNeedsDisplay];
}

@end
