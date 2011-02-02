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
//  FCUnit.h
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//


#import "FCDatabaseHandler.h"

@interface FCUnit : NSObject {

	NSString *uid;
	
	NSString *name;
	NSString *abbreviation;
	
	NSNumber *metre;
	NSNumber *kilogram;
	NSNumber *second;
	NSNumber *exponent;
	
	FCUnitSystem system;
	FCUnitQuantity quantity;
}

@property (nonatomic, retain) NSString *uid;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *abbreviation;

@property (nonatomic, retain) NSNumber *metre;
@property (nonatomic, retain) NSNumber *kilogram;
@property (nonatomic, retain) NSNumber *second;
@property (nonatomic, retain) NSNumber *exponent;

@property (nonatomic) FCUnitSystem system;
@property (nonatomic) FCUnitQuantity quantity;

// Class

+(FCUnit *)unitWithUID:(NSString *)theUID;

// Init

-(id)initWithDictionary:(NSDictionary *)theDictionary;

// Custom

-(BOOL)isConvertibleWith:(FCUnit *)anotherUnit;

@end
