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
//  FCNumberHelper.m
//  Future2
//
//  Created by Anders Sigfridsson on 11/09/2010.
//

#import "FCNumberHelper.h"


@implementation NSNumber (FCNumberHelper)

-(int)countIntegralDigits {
	
	int n = [self intValue];
	
	if (n < 0)
		n = -n;
	
	int i = 1;
	
	n /= 10;
	
	while (n >= 1) {
		
		i++;
		n /= 10;
	}
	
	return i;
}

-(int)countDecimalPlacesOfDecimalValue {
	
	NSDecimal decimal = [self decimalValue];
	int exponent = decimal._exponent;
	
	if (exponent < 0)
		exponent = -exponent;
	
	return exponent;
}

@end
