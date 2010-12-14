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
//  FCCategory.h
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//


#import "FCDatabaseHandler.h"
#import "FCUnitConverter.h"

#import "FCUnit.h"

@interface FCCategory : NSObject {

	NSString *cid;
	
	NSString *name;
	
	NSNumber *minimum;
	NSNumber *maximum;
	NSNumber *decimals;
	
	NSDate *created;
	NSDate *modified;
	
	NSString *datatypeName;
	NSString *iconName;
	NSNumber *colorIndex;
	
	NSString *lid;
	NSString *oid;
	NSString *uid;
	NSString *did;
	NSString *iid;
	
	FCUnit *unit;
}

@property (nonatomic, retain) NSString *cid;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSNumber *minimum;
@property (nonatomic, retain) NSNumber *maximum;
@property (nonatomic, retain) NSNumber *decimals;

@property (nonatomic, retain) NSDate *created;
@property (nonatomic, retain) NSDate *modified;

@property (nonatomic, retain) NSString *datatypeName;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSNumber *colorIndex;

@property (nonatomic, retain) NSString *lid;
@property (nonatomic, retain) NSString *oid;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *did;
@property (nonatomic, retain) NSString *iid;

@property (nonatomic, retain) FCUnit *unit;

// Class
+(FCCategory *)categoryWithCID:(NSString *)theCID;
+(FCCategory *)lastCategory;
+(NSArray *)allCategories;
+(NSArray *)allCategoriesWithOwner:(NSString *)theOwnersCID;

// Init
-(id)initWithDictionary:(NSDictionary *)theDictionary;

// Custom
-(void)save;
-(void)saveNewUnit:(FCUnit *)newUnit andConvert:(BOOL)convert;
-(void)delete;

-(NSDictionary *)generateDefaultGraphSet;

@end
