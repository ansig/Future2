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
//  FCGraphReferenceRange.m
//  Future2
//
//  Created by Anders Sigfridsson on 25/10/2010.
//

#import "FCGraphReferenceRange.h"


@implementation FCGraphReferenceRange

@synthesize name;
@synthesize upperLimit, lowerLimit;

#pragma mark Init

-(id)initWithName:(NSString *)theName upperLimit:(NSNumber *)theUpperLimit lowerLimit:(NSNumber *)theLowerLimit {
	
	if (self = [super init]) {
		
		name = [theName retain];
		
		upperLimit = [theUpperLimit retain];
		lowerLimit = [theLowerLimit retain];
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {

	[name release];
	
	[upperLimit release];
	[lowerLimit release];
	
	[super dealloc];
}

@end
