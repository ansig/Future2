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
//  FCEntry.h
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//


#import "FCDatabaseHandler.h"
#import "FCUnitConverter.h"

#import "FCCategory.h"
#import "FCUnit.h"

@interface FCEntry : NSObject {

	NSString *eid;
	
	NSString *title;
	
	NSString *string;
	NSNumber *integer;
	NSNumber *decimal;
	
	NSDate *timestamp;
	NSDate *created;
	
	NSString *cid;
	NSString *uid;
}

@property (nonatomic, retain) NSString *eid;

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) NSNumber *integer;
@property (nonatomic, retain) NSNumber *decimal;

@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain) NSDate *created;

@property (nonatomic, retain) NSString *cid;
@property (nonatomic, retain) NSString *uid;

// Class
+(FCEntry *)lastEntryWithCID:(NSString *)theCID;
+(FCEntry *)newEntryWithCID:(NSString *)theCID;
+(FCEntry *)entryWithEID:(NSString *)theEID;

// Init
-(id)initWithDictionary:(NSDictionary *)theDictionary;

// Get
-(FCCategory *)category;
-(FCUnit *)unit;

// Custom

-(void)save;
-(void)makeNew;
-(void)copyEntry:(FCEntry *)anotherEntry; 
-(void)convertToNewUnit:(FCUnit *)newUnit;

-(NSString *)fullDescription;
-(NSString *)convertedFullDescription;
-(NSString *)shortDescription;
-(NSString *)convertedShortDescription;
-(NSString *)descriptionWithExtensions:(BOOL)addExtensions converted:(BOOL)doConvert;

-(NSString *)timestampDescription;
-(NSString *)dateDescription;
-(NSString *)timeDescription;

@end
