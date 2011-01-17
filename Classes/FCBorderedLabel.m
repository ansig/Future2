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
//  FCBorderedLabel.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/12/2010.
//

#import "FCBorderedLabel.h"


@implementation FCBorderedLabel

@synthesize spacing, imageView;

-(id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		[self.layer setBorderWidth:2.0f];
		[self.layer setCornerRadius:5.0f];
		[self.layer setBorderColor:[[UIColor blackColor] CGColor]];
	}
	
	return self;
}

-(void)dealloc {
	
	[imageView release];
	
	[super dealloc];
}

- (void)drawTextInRect:(CGRect)rect {

	if (self.imageView != nil) {
	
		CGFloat xPos = self.imageView.frame.origin.x + self.imageView.frame.size.width + spacing;
		CGFloat width = rect.size.width - xPos;
	
		CGRect newRect = CGRectMake(xPos, rect.origin.y, width, rect.size.height);
		
		[super drawTextInRect:newRect];
		
	} else {
	
		[super drawTextInRect:rect];
	}
}

-(void)setBackgroundColor:(UIColor *)color {
	
	[self.layer setBorderColor:[color CGColor]];
	
	[super setBackgroundColor:[color colorWithAlphaComponent:0.5f]];
}

#pragma mark Custom

-(void)loadImageView {
	
	spacing = 2.0f;
	
	CGFloat height = self.frame.size.height - (spacing*2);
	CGFloat width = height;
	
	CGFloat xPos = spacing;
	CGFloat yPos = (self.frame.size.height/2) - (height/2);
	
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
	imageView.backgroundColor = [UIColor clearColor];
	
	[self addSubview:imageView];
}

@end
