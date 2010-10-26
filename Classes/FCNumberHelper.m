//
//  FCNumberHelper.m
//  Future2
//
//  Created by Anders Sigfridsson on 11/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
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
