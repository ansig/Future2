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
//  FCUnit.m
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//

#import "FCUnit.h"


@implementation FCUnit

@synthesize uid;
@synthesize name, abbreviation;
@synthesize metre, kilogram, second, exponent;
@synthesize system;

#pragma mark Class

+(FCUnit *)unitWithUID:(NSString *)theUID {

	if (theUID != nil) {
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *columns = @"name, abbreviation, metre, kilogram, second, exponent, system";
		NSString *table = @"units";
		NSString *filter = [NSString stringWithFormat:@"uid = '%@'", theUID];
		
		NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filter];
		
		[dbh release];
		
		// if there was no unit with the UID, return nil
		if (result == nil)
			return nil;
		
		// initialize the unit with the data
		FCUnit *unit = [[FCUnit alloc] initWithDictionary:[result objectAtIndex:0]];
		
		unit.uid = theUID;
		
		[unit autorelease];
		
		return unit;
	}
	
	return nil;
}

#pragma mark Init

-(id)initWithDictionary:(NSDictionary *)theDictionary {

	if (self = [self init]) {
		
		NSArray *keys = [theDictionary allKeys];
		for (NSString *key in keys) {
		
			if ([key isEqualToString:@"name"]) {
			
				self.name = [theDictionary objectForKey:key];
				
			} else if ([key isEqualToString:@"abbreviation"]) {
			
				self.abbreviation = [theDictionary objectForKey:key];
			
			} else if ([key isEqualToString:@"metre"]) {
				
				self.metre = [theDictionary objectForKey:key];
			
			} else if ([key isEqualToString:@"kilogram"]) {
				
				self.kilogram = [theDictionary objectForKey:key];
			
			} else if ([key isEqualToString:@"second"]) {
				
				self.second = [theDictionary objectForKey:key];
				
			} else if ([key isEqualToString:@"exponent"]) {
				
				self.exponent = [theDictionary objectForKey:key];
				
			} else if ([key isEqualToString:@"system"]) {
				
				NSNumber *number = [theDictionary objectForKey:key];
				self.system = [number integerValue];
			}
		}
	}
	
	return self;
}

-(id)init {
	
	if (self = [super init]) {
		
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {
	
	[uid release];
	
	[name release];
	[abbreviation release];
	
	[metre release];
	[kilogram release];
	[second release];
	[exponent release];
	
	[super dealloc];
}

#pragma mark Get

-(FCUnitQuantity)quantity {
	
	// time
	if (self.second != nil)
		return FCUnitQuantityTime;
	
	// length
	else if (self.metre != nil && [self.exponent intValue] == 1)
		return FCUnitQuantityLength;
	
	// volume
	else if (self.metre != nil && [self.exponent intValue] == 3)
		return FCUnitQuantityVolume;
	
	// * special cases
	
	else {
		
		// glucose
		if ([self.uid isEqualToString:FCKeyUIDGlucoseMillimolesPerLitre] || [self.uid isEqualToString:FCKeyUIDGlucoseMilligramsPerDecilitre])
			return FCUnitQuantityGlucose;
		
		// insulin
		else if ([self.abbreviation isEqualToString:FCKeyUidInsulinUnits])
			return FCUnitQuantityInsulin;
	}
	
	// * default			 
	
	// mass
	return FCUnitQuantityMass;
}

@end
