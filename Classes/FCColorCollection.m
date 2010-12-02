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
//  FCColorCollection.m
//  Future2
//
//  Created by Anders Sigfridsson on 25/11/2010.
//

#import "FCColorCollection.h"


@implementation FCColorCollection

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		_systemColors = nil;
		[self loadSystemColors];
		
		_freeColors = nil;
		[self loadFreeColors];
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {
	
	[_systemColors release];
	[_freeColors release];
	
	[super dealloc];
}

#pragma mark Custom

-(void)loadSystemColors {

	if (_systemColors != nil)
		[_systemColors release], _freeColors = nil;
	
	NSMutableArray *mutableNewSystemColors = [[NSMutableArray alloc] init];
	
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.99609375 green:0.26953125 blue:0 alpha:1.0f]]; // Orange red
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.51953125 green:0.51953125 blue:0.7734375 alpha:1.0f]]; // Slate blue
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.5546875 green:0.21875 blue:0.554675 alpha:1.0f]]; // Beet
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.99609375 green:0.38671875 blue:0.27734375 alpha:1.0f]]; // Tomato
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.99000005 green:0.83984375 blue:0 alpha:1.0f]]; // Gold
	[mutableNewSystemColors addObject:[UIColor colorWithRed:0.57421875 green:0.4375 blue:0.85546875 alpha:1.0f]]; // Medium purple
	
	NSRange range = NSMakeRange(0, [mutableNewSystemColors count]);
	NSArray *newSystemColors = [[NSMutableArray alloc] initWithArray:[mutableNewSystemColors subarrayWithRange:range]];
	[mutableNewSystemColors release];
	
	_systemColors = newSystemColors;
}

-(void)loadFreeColors {
	
	if (_freeColors != nil)
		[_freeColors release], _freeColors = nil;
	
	NSMutableArray *mutableNewFreeColors = [[NSMutableArray alloc] init];
	
	[mutableNewFreeColors addObject:[UIColor colorWithRed:0.77734375 green:0.08203125 blue:0.51953125 alpha:1.0f]]; // Medium violet red
	[mutableNewFreeColors addObject:[UIColor colorWithRed:0.99609375 green:0.64453125 blue:0 alpha:1.0f]]; // Orange
	[mutableNewFreeColors addObject:[UIColor colorWithRed:0.6015625 green:0.80078125 blue:0.1953125 alpha:1.0f]]; // Olive
	[mutableNewFreeColors addObject:[UIColor colorWithRed:0.125 green:0.6953125 blue:0.6640625 alpha:1.0f]]; // Light sea green
	
	NSRange range = NSMakeRange(0, [mutableNewFreeColors count]);
	NSArray *newFreeColors = [[NSMutableArray alloc] initWithArray:[mutableNewFreeColors subarrayWithRange:range]];
	[mutableNewFreeColors release];
	
	_freeColors = newFreeColors;
}

-(UIColor *)colorForCID:(NSString *)cid {

	if (_systemColors == nil)
		return nil;
	
	if ([cid isEqualToString:FCKeyCIDGlucose]) {
	
		return [_systemColors objectAtIndex:0];
	
	} else if ([cid isEqualToString:FCKeyCIDRapidInsulin]) {
		
		return [_systemColors objectAtIndex:1];
		
	} else if ([cid isEqualToString:FCKeyCIDBasalInsulin]) {
		
		return [_systemColors objectAtIndex:2];
		
	} else if ([cid isEqualToString:FCKeyCIDNote]) {
		
		return [_systemColors objectAtIndex:3];
		
	} else if ([cid isEqualToString:FCKeyCIDPhoto]) {
		
		return [_systemColors objectAtIndex:4];
		
	} else if ([cid isEqualToString:FCKeyCIDWeight]) {
		
		return [_systemColors objectAtIndex:5];
		
	}
	
	return nil;
}

-(UIColor *)colorForIndex:(NSInteger)index {
	
	if (_freeColors == nil)
		return nil;

	if (index > [_freeColors count])
		return nil;
	
	return [_freeColors objectAtIndex:index];
}

-(NSArray *)allSystemColors{

	return _systemColors;
}

-(NSArray *)allFreeColors {
	
	return _freeColors;
}

@end
