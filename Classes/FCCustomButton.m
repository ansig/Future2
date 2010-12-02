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
//  FCCustomButton.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/12/2010.
//

#import "FCCustomButton.h"


@implementation FCCustomButton

-(void)addBorder {

	[self.layer setBorderWidth:1.0];
	[self.layer setCornerRadius:5.0];
	[self.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];	
	
	[self setNeedsDisplay];
}

-(void)removeBorder {
	
	[self.layer setBorderWidth:0.0];	
	
	[self setNeedsDisplay];
}

-(void)addBackgroundColorBorder {

	[self.layer setBorderWidth:1.0];
	
	[self.layer setBorderColor:[self.backgroundColor CGColor]];
	
	UIColor *oldBackground = self.backgroundColor;
	self.backgroundColor = [oldBackground colorWithAlphaComponent:0.5f];
}

@end
