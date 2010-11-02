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
//  FCUnitConverter.m
//  Future2
//
//  Created by Anders Sigfridsson on 14/09/2010.
//

#import "FCUnitConverter.h"


@implementation FCUnitConverter

@synthesize target;

#pragma mark Init

-(id)initWithTarget:(FCUnit *)theTarget {

	if (self = [self init]) {
		
		self.target = theTarget;
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
	
	[target release];
	
	[super dealloc];
}

#pragma mark Custom

-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit {

	return [self convertNumber:aNumber withUnit:aUnit roundedToScale:-1]; // scale -1 means number will be returned as is
}

-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit roundedToScale:(NSInteger)scale {
	
	return [self convertNumber:aNumber withUnit:aUnit roundedToScale:scale withMode:NSRoundPlain]; // default rounding mode = plain
}

-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit roundedToScale:(NSInteger)scale withMode:(NSRoundingMode)mode {
	
	// if origin unit and target unit are the same, return original number
	if ([aUnit.uid isEqualToString:self.target.uid])
		return aNumber;
	
	// determine if origin unit and target unit are comparable
	if (aUnit.quantity != self.target.quantity)
		return nil;
	
	// if so, convert the number...
	
	// get bases
	double originBase;
	double targetBase;
	if (aUnit.metre != nil) {
		
		originBase = [aUnit.metre doubleValue];
		targetBase = [self.target.metre doubleValue];
		
	} else if (aUnit.kilogram != nil) {
		
		originBase = [aUnit.kilogram doubleValue];
		targetBase = [self.target.kilogram doubleValue];
		
	} else if (aUnit.second != nil) {
		
		originBase = [aUnit.second doubleValue];
		targetBase = [self.target.second doubleValue];
		
	} else if (aUnit.quantity == FCUnitQuantityGlucose) {
		
		// special case for glucose
		
		if ([aUnit.uid isEqualToString:FCKeyUIDGlucoseMillimolesPerLitre]) { // mmol/L -> mg/dl
			
			originBase = 1;
			targetBase = 0.0555555555555556; // since 1 / 0.0555555555555556 = 18
			
		} else if ([aUnit.uid isEqualToString:FCKeyUIDGlucoseMilligramsPerDecilitre]) { // mg/dl -> mmol/L
			
			originBase = 0.0555555555555556;
			targetBase = 1;
		}
	}
	
	// find conversion rate
	double rate = originBase / targetBase;
	
	// convert the value
	double convertedValue = [aNumber doubleValue] * rate;
	
	// create new number object and return it
	
	NSNumber *convertedNumber = [[NSNumber alloc] initWithDouble:convertedValue];
	
	if (scale > -1) {
		
		// round to given scale
		
		NSDecimal decimalValue = [convertedNumber decimalValue];
		NSDecimal roundedDecimalValue;
		NSDecimalRound(&roundedDecimalValue, &decimalValue, scale, mode);
		NSDecimalNumber *roundedDecimalNumber = [[NSDecimalNumber alloc] initWithDecimal:roundedDecimalValue];
		
		NSNumber *roundedConvertedNumber = [[NSNumber alloc] initWithDouble:[roundedDecimalNumber doubleValue]]; 
		
		[roundedDecimalNumber release];
		
		// return rounded converted number
		
		[convertedNumber release];
		[roundedConvertedNumber autorelease];
		
		return roundedConvertedNumber;
	}
	
	// return converted number as is
	
	[convertedNumber autorelease];
	
	return convertedNumber;
}

@end
