//
//  FCNumberHelper.h
//  Future2
//
//  Created by Anders Sigfridsson on 11/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber (FCNumberHelper)

-(int)countIntegralDigits;
-(int)countDecimalPlacesOfDecimalValue;

@end
