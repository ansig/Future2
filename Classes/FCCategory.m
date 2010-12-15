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
//  FCCategory.m
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//

#import "FCCategory.h"

#import "FCEntry.h"

@implementation FCCategory

@synthesize cid;
@synthesize name;
@synthesize minimum, maximum, decimals;
@synthesize created, modified;
@synthesize datatypeName, colorIndex;
@synthesize lid, uid, oid, did, iid;
@synthesize unit;

#pragma mark Class

+(FCCategory *)categoryWithCID:(NSString *)theCID {

	if (theCID != nil) {
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *columns = @"categories.name, minimum, maximum, decimals, color, lid, uid, categories.did, datatypes.name as datatype, iid, oid";
		NSString *table = @"categories";
		NSString *filters = [NSString stringWithFormat:@"cid = '%@'", theCID];
		NSString *joints = @"LEFT JOIN datatypes ON datatypes.did = categories.did";
		
		NSArray *result = [dbh getColumns:columns fromTable:table withJoints:joints filters:filters];
		
		[dbh release];
		
		if (result == nil)
			return nil;
		
		FCCategory *category = [[FCCategory alloc] initWithDictionary:[result objectAtIndex:0]];
		
		category.cid = theCID;
		
		[category autorelease];
		
		return category;
	}
	
	// if theCID was nil
	return nil;
}

+(FCCategory *)lastCategory {
/*	Loads and returns the last created category. */
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *columns = @"cid, categories.name, minimum, maximum, decimals, color, lid, uid, categories.did, datatypes.name as datatype, iid, oid, max(categories.created)";
	NSString *table = @"categories";
	NSString *joints = @"LEFT JOIN datatypes ON datatypes.did = categories.did";
	
	NSArray *result = [dbh getColumns:columns fromTable:table withJoints:joints];
	
	[dbh release];
	
	if (result == nil)
		return nil;
	
	FCCategory *category = [[FCCategory alloc] initWithDictionary:[result objectAtIndex:0]];
	
	[category autorelease];
	
	return category;
}

+(NSArray *)allCategories {

	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *columns = @"categories.cid as cid, categories.name as name, minimum, maximum, decimals, color, lid, uid, categories.did as did, datatypes.name as datatype, iid, oid";
	NSString *table = @"categories";
	NSString *joints = @"LEFT JOIN datatypes ON datatypes.did = categories.did";
	NSString *options = @"ORDER BY name";
	
	NSArray *result = [dbh getColumns:columns fromTable:table withJoints:joints options:options];
	
	[dbh release];
	
	if (result == nil)
		return nil;
	
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in result) {
	
		FCCategory *aCategory = [[FCCategory alloc] initWithDictionary:dict];
		[mutableArray addObject:aCategory];
		[aCategory release];
	}
	
	NSRange range = NSMakeRange(0, [mutableArray count]);
	NSArray *allCategories = [[NSArray alloc] initWithArray:[mutableArray subarrayWithRange:range]];
	
	[mutableArray release];
	
	[allCategories autorelease];
	
	return allCategories;
}

+(NSArray *)allCategoriesWithOwner:(NSString *)theOwnersCID {
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *columns = @"categories.cid as cid, categories.name as name, minimum, maximum, decimals, color, lid, uid, categories.did as did, datatypes.name as datatype, iid, oid";
	NSString *table = @"categories";
	NSString *joints = @"LEFT JOIN datatypes ON datatypes.did = categories.did";
	NSString *filters = [[NSString alloc] initWithFormat:@"categories.oid = '%@'", theOwnersCID];
	NSString *options = @"ORDER BY name";
	
	NSArray *result = [dbh getColumns:columns fromTable:table withJoints:joints filters:filters options:options];
	
	[filters release];
	
	[dbh release];
	
	if (result == nil)
		return nil;
	
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	for (NSDictionary *dict in result) {
		
		FCCategory *aCategory = [[FCCategory alloc] initWithDictionary:dict];
		[mutableArray addObject:aCategory];
		[aCategory release];
	}
	
	NSRange range = NSMakeRange(0, [mutableArray count]);
	NSArray *allCategoriesWithOwner = [[NSArray alloc] initWithArray:[mutableArray subarrayWithRange:range]];
	
	[mutableArray release];
	
	[allCategoriesWithOwner autorelease];
	
	return allCategoriesWithOwner;
}

#pragma mark Init

-(id)initWithDictionary:(NSDictionary *)theDictionary {

	if (self = [self init]) {
		
		NSArray *keys = [theDictionary allKeys];
		for (NSString *key in keys) {
		
			// cid
			if ([key isEqualToString:@"cid"]) {
			
				self.cid = [theDictionary objectForKey:key];
				
			// name
			} else if ([key isEqualToString:@"name"]) {
			
				self.name = [theDictionary objectForKey:key];
				
			// minimum
			} else if ([key isEqualToString:@"minimum"]) {
				
				self.minimum = [theDictionary objectForKey:key];
			
			// maximum
			} else if ([key isEqualToString:@"maximum"]) {
				
				self.maximum = [theDictionary objectForKey:key];
				
			// decimals
			} else if ([key isEqualToString:@"decimals"]) {
				
				self.decimals = [theDictionary objectForKey:key];
				
			// created
			} else if ([key isEqualToString:@"created"]) {
				
				self.created = [theDictionary objectForKey:key];
			
			// modified
			} else if ([key isEqualToString:@"modified"]) {
				
				self.modified = [theDictionary objectForKey:key];
				
			// datatype
			} else if ([key isEqualToString:@"datatype"]) {
				
				self.datatypeName = [theDictionary objectForKey:key];
				
			// color
			} else if ([key isEqualToString:@"color"]) {
				
				self.colorIndex = [theDictionary objectForKey:key];
				
			// lid
			} else if ([key isEqualToString:@"lid"]) {
				
				self.lid = [theDictionary objectForKey:key];
				
			// oid
			} else if ([key isEqualToString:@"oid"]) {
				
				self.oid = [theDictionary objectForKey:key];
				
			// uid
			} else if ([key isEqualToString:@"uid"]) {
				
				self.uid = [theDictionary objectForKey:key];
			
			// did
			} else if ([key isEqualToString:@"did"]) {
				
				self.did = [theDictionary objectForKey:key];
			
			// iid
			} else if ([key isEqualToString:@"iid"]) {
				
				self.iid = [theDictionary objectForKey:key];
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

#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone {
	
	// implements SHALLOW copying (i.e. shares pointer ivars with copy)
	// (see http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmImplementCopy.html )
	
	FCCategory *copy = [[[self class] allocWithZone:zone] init];
	
	copy.cid = self.cid;
	
	copy.name = self.name;
	
	copy.minimum = self.minimum;
	copy.maximum = self.maximum;
	copy.decimals = self.decimals;
	
	copy.created = self.created;
	copy.modified = self.modified;
	
	copy.datatypeName = self.datatypeName;
	copy.colorIndex = self.colorIndex;
	
	copy.lid = self.lid;
	copy.oid = self.oid;
	copy.uid = self.uid;
	copy.did = self.did;
	copy.iid = self.iid;
	
	return (copy);
}

#pragma mark Dealloc

-(void)dealloc {
	
	[cid release];
	
	[name release];
	
	[minimum release];
	[maximum release];
	[decimals release];
	
	[created release];
	[modified release];
	
	[datatypeName release];
	[colorIndex release];
	
	[lid release];
	[oid release];
	[uid release];
	[did release];
	[iid release];
	
	[unit release];
	
	[super dealloc];
}

#pragma mark Get

-(FCUnit *)unit {
	
	if (unit == nil)
		self.unit = [FCUnit unitWithUID:self.uid]; // will be nil if there is no unit
		
	return unit;
}

#pragma mark MemoryMgmt

-(void)didReceiveMemoryWarning {
	
	self.unit = nil;
}

#pragma mark Custom

-(void)save {
	
	// * Compose an array with the column-value pairs that are to be set or updated
	NSMutableArray *sets = [[NSMutableArray alloc] init];
	
	// add strings...
	
	if (self.name != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.name];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"name", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.lid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.lid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"lid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.oid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.oid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"oid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.uid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.uid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"uid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.did != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.did];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"did", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.iid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.iid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"iid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	// add numbers
	
	if (self.minimum != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.minimum intValue]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"minimum", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.maximum != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.maximum intValue]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"maximum", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.decimals != nil) {
	
		NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.decimals intValue]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"decimals", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.colorIndex != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.colorIndex intValue]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"color", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	// OBS! created and modified are system variables and can never be independently 
	// changed by user. Instead, they are set int FCDatabaseHandler -insertSets:intoTables:
	// and FCDatabaseHandler -updateTable:withSets:filters: respectively.
	
	// * rest of components for database update
	
	NSString *table = @"categories";

	if (self.cid == nil) {
	
		// * SAVE
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSRange range = NSMakeRange(0, [sets count]);
		[dbh insertSets:[sets subarrayWithRange:range] intoTable:table];
		
		[dbh release];
		
		// log
		NSLog(@"FCCategory -save || SAVED new category.");
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryCreated object:self];
		
	} else {
		
		// * UPDATE
		
		NSString *filter = [NSString stringWithFormat:@"cid ='%@'", self.cid];
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSRange range = NSMakeRange(0, [sets count]);
		[dbh updateTable:table withSets:[sets subarrayWithRange:range] filters:filter];
		
		[dbh release];
		
		// log
		NSLog(@"FCCategory -save || UPDATED category.");
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryUpdated object:self];
	}
	
	[sets release];
}

-(void)saveNewUnit:(FCUnit *)newUnit andConvert:(BOOL)doConvert {

	// for now, do not try to convert either 
	// from or to NO unit.
	if (self.uid == nil || newUnit == nil)
		return;
	
	if (![self.uid isEqualToString:newUnit.uid]) {
	
		// the sets to be passed to the database handler
		NSMutableArray *sets = [[NSMutableArray alloc] init];
		NSDictionary *set;
		
		if (doConvert) {
			
			// convert minimum and maximum
			
			FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:newUnit];
			FCUnit *origin = self.unit;
			
			NSNumber *convertedMaximum = [converter convertNumber:self.maximum withUnit:origin roundedToScale:0];
			self.maximum = convertedMaximum;
			
			NSNumber *convertedMinimum = [converter convertNumber:self.minimum withUnit:origin roundedToScale:0];
			self.minimum = convertedMinimum;		
			
			[converter release];
			
			// make sure maximum is always at least 1
			NSInteger max = [convertedMaximum integerValue];
			if (max < 1)
				self.maximum = [NSNumber numberWithInteger:1];
			
			// add them to the sets to be updated
			
			NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.maximum intValue]];
			set = [[NSDictionary alloc] initWithObjectsAndKeys:@"maximum", @"Column", value, @"Value", nil];
			[sets addObject:set];
			
			[set release];
			[value release];
			
			value = [[NSString alloc] initWithFormat:@"%d", [self.minimum intValue]];
			set = [[NSDictionary alloc] initWithObjectsAndKeys:@"minimum", @"Column", value, @"Value", nil];
			[sets addObject:set];
			
			[set release];
			[value release];
		}
		
		// change the unit id
		self.uid = newUnit.uid;
		
		// add it to the sets to be updated
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.uid];
		set = [[NSDictionary alloc] initWithObjectsAndKeys:@"uid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
		
		// update the database
		
		NSString *table = @"categories";
		NSString *filter = [NSString stringWithFormat:@"cid ='%@'", self.cid];
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSRange range = NSMakeRange(0, [sets count]);
		[dbh updateTable:table withSets:[sets subarrayWithRange:range] filters:filter];
		
		[dbh release];
		
		[sets release];
		
		// log
		NSLog(@"FCCategory -saveNewUnit:andConvert: || UPDATED category.");
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryUpdated object:self];
		
	}
}

-(void)delete {
/*	Deletes the category from database. Also attempts to delete any entries of this category. */
	
	if (self.cid != nil) {
	
		// remove entries
		
		NSArray *entries = [FCEntry allEntriesWithCID:self.cid];
		for (FCEntry *entry in entries)
			[entry delete];
		
		// delete self
		
		NSString *table = @"categories";
		NSString *criterion = [NSString stringWithFormat:@"cid = '%@'", self.cid];
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		[dbh deleteRowInTable:table withCriterion:criterion];
		
		[dbh release];
		
		// log
		
		NSLog(@"FCCategory -delete || DELETED category.");
		
		// notification
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryDeleted object:self];
	}
}

-(NSDictionary *)generateDefaultGraphSet {
/*	Composes a dictinary object with all the necessary information for creating a graph for this category. */
	
	NSNumber *drawGrid = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawAxes = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawXScale = [[NSNumber alloc] initWithBool:YES];
	NSNumber *drawLines = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawAverage = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawMedian = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawIQR = [[NSNumber alloc] initWithBool:NO];
	NSNumber *drawReferences = [[NSNumber alloc] initWithBool:NO];
	
	// different entry view modes depending on data type and preferences
	
	NSNumber *entryViewMode;
	
	if ([self.cid isEqualToString:FCKeyCIDRapidInsulin] || [self.cid isEqualToString:FCKeyCIDBasalInsulin])
		entryViewMode = [[NSNumber alloc] initWithInteger:FCGraphEntryViewModeBarVertical];
	
	else if ([self.datatypeName isEqualToString:@"integer"] || [self.datatypeName isEqualToString:@"decimal"])
		entryViewMode = [[NSNumber alloc] initWithInteger:FCGraphEntryViewModeCircle];
	
	else
		entryViewMode = [[NSNumber alloc] initWithInteger:FCGraphEntryViewModeIcon];
	
	// other special cases
	
	if ([self.cid isEqualToString:FCKeyCIDGlucose]) {
		
		NSNumber *oldDrawLines = drawLines;
		drawLines = [[NSNumber alloc] initWithBool:YES];
		[oldDrawLines release];
	}
	
	NSArray *keys = [[NSArray alloc] initWithObjects:
					 @"Key", 
					 @"DrawGrid",
					 @"DrawAxes", 
					 @"DrawXScale", 
					 @"DrawLines", 
					 @"DrawAverage",
					 @"DrawMedian",
					 @"DrawIQR",
					 @"DrawReferences",
					 @"EntryViewMode",
					 nil];
	
	NSArray *objects = [[NSArray alloc] initWithObjects:
						self.cid,
						drawGrid,
						drawAxes,
						drawXScale,
						drawLines,
						drawAverage,
						drawMedian,
						drawIQR,
						drawReferences,
						entryViewMode,
						nil];

	[drawGrid release];
	[drawAxes release];
	[drawXScale release];
	[drawLines release];
	[drawAverage release];
	[drawMedian release];
	[drawIQR release];
	[drawReferences release];
	[entryViewMode release];
	
	NSDictionary *graphSet = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	
	[keys release];
	
	[objects release];
	
	[graphSet autorelease];
	
	return graphSet;
}

-(UIImage *)icon {
	
	return [[FCIconCollection sharedIconCollection] iconForIID:self.iid];
}

@end
