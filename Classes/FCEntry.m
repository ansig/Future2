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
//  FCEntry.m
//  Future2
//
//  Created by Anders Sigfridsson on 10/09/2010.
//

#import "FCEntry.h"


@implementation FCEntry

@synthesize owner;
@synthesize eid;
@synthesize title;
@synthesize string, integer, decimal;
@synthesize timestamp, created;
@synthesize cid, uid;
@synthesize attachments;

#pragma mark Class

+(FCEntry *)lastEntryWithCID:(NSString *)theCID {
	
	if (theCID != nil) {
		
		// get the entry data from the database
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *columns = @"eid, title, string, integer, decimal, timestamp, max(created) as created, uid, lid";
		NSString *table = @"entries";
		NSString *filters = [NSString stringWithFormat:@"cid = '%@'", theCID];
		
		NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filters];
		
		[dbh release];
		
		// if there was no entry with the CID return nil
		if (result == nil)
			return nil;
		
		// otherwise we setup and return a new entry object
		FCEntry *entry = [[FCEntry alloc] initWithDictionary:[result objectAtIndex:0]];
		
		entry.cid = theCID;
		
		[entry autorelease];
		
		return entry;
	}
	
	// if theCID was nil
	return nil;
}

+(FCEntry *)newEntryWithCID:(NSString *)theCID {

	if (theCID != nil) {
		
		// creates an entry object that is empty except for a CID
		
		FCEntry *entry = [[FCEntry alloc] init];
		
		entry.cid = theCID;
		
		[entry autorelease];
		
		return entry;
	}
	
	// if theCID was nil
	return nil;
}

+(FCEntry *)entryWithEID:(NSString *)theEID {

	if (theEID != nil) {
		
		// get the entry data from the database
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *columns = @"*";
		NSString *table = @"entries";
		NSString *filters = [NSString stringWithFormat:@"eid = '%@'", theEID];
		
		NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filters];
		
		[dbh release];
		
		// if there was no entry with the CID return nil
		if (result == nil)
			return nil;
		
		// otherwise we setup and return a new entry object
		FCEntry *entry = [[FCEntry alloc] initWithDictionary:[result objectAtIndex:0]];
		
		[entry autorelease];
		
		return entry;
	}
	
	return nil;
}

#pragma mark Init

-(id)initWithDictionary:(NSDictionary *)theDictionary {
/*	Initializes the entry with given data.
	Data should correspond to a row from the correct database table.
	Sets only recognised values. */

	if (self = [self init]) {
		
		NSArray *keys = [theDictionary allKeys];
		for (NSString *key in keys) {
		
			// eid
			if ([key isEqualToString:@"eid"]) {
			
				self.eid = [theDictionary objectForKey:key];
			
			// title
			} else if ([key isEqualToString:@"title"]) {
				
				self.title = [theDictionary objectForKey:key];
			
			// string
			} else if ([key isEqualToString:@"string"]) {
				
				self.string = [theDictionary objectForKey:key];
			
			// integer
			} else if ([key isEqualToString:@"integer"]) {
				
				self.integer = [theDictionary objectForKey:key];
			
			// decimal
			} else if ([key isEqualToString:@"decimal"]) {
				
				self.decimal = [theDictionary objectForKey:key];
			
			// timestamp
			} else if ([key isEqualToString:@"timestamp"]) {
				
				self.timestamp = [theDictionary objectForKey:key];
			
			// created
			} else if ([key isEqualToString:@"created"]) {
				
				self.created = [theDictionary objectForKey:key];
			
			// cid
			} else if ([key isEqualToString:@"cid"]) {
				
				self.cid = [theDictionary objectForKey:key];
			
			// uid
			} else if ([key isEqualToString:@"uid"]) {
				
				self.uid = [theDictionary objectForKey:key];
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
	
	[eid release];
	
	[title release];
	
	[string release];
	[integer release];
	[decimal release];
	
	[timestamp release];
	[created release];
	
	[cid release];
	[uid release];
	
	[attachments release];
	
	[super dealloc];
}

#pragma mark Get

-(FCCategory *)category {
/*	Returns the entry's corresponding category as a new FCCategory object */
	
	FCCategory *category = [FCCategory categoryWithCID:self.cid];
	
	return category;
}

-(FCUnit *)unit {
/*	Returns the entry's unit or the corresponding category's unit if no unit has been set. 
	Nil if there is no unit. */
	
	if (self.uid == nil)
		return [FCUnit unitWithUID:self.category.uid];
		
	return [FCUnit unitWithUID:self.uid];
}

#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone {

	// implements SHALLOW copying (i.e. shares pointer ivars with copy)
	// (see http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmImplementCopy.html )
	
	FCEntry *copy = [[[self class] allocWithZone:zone] init];
	
	copy.owner = self.owner;
	
	copy.eid = self.eid;
	
	copy.title = self.title;
	
	copy.string = self.string;
	copy.integer = self.integer;
	copy.decimal = self.decimal;
	
	copy.timestamp = self.timestamp;
	copy.created = self.created;
	
	copy.cid = self.cid;
	copy.uid = self.uid;
	
	copy.attachments = self.attachments;
	
	return (copy);
}

#pragma mark Custom

#pragma mark Read/write

-(void)save {
/*	Saves the current entry to the database, either by a new INSERT if it is not already saved (ie has no eid) or by an UPDATE if it does.
	Gets all currently set properties and inserts/updates the corresponding columns in the database. 
	Also creates an attachment link if there is an owning entry. */
	
	// * Compose an array with the column-value pairs that are to be set or updated
	NSMutableArray *sets = [[NSMutableArray alloc] init];
	
	// add strings...
	
	if (self.title != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.title];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"title", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	if (self.cid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.cid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"cid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	// make sure there is always a UID set on save
	if (self.uid == nil)
		self.uid = self.category.unit.uid;
	
	if (self.uid != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.uid];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"uid", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	// add data values
	
	if (self.string != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", self.string];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"string", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	
	} else if (self.integer != nil) {
		
		NSString *value = [[NSString alloc] initWithFormat:@"%d", [self.integer intValue]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"integer", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
		
	} else if (self.decimal != nil) {
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		FCCategory *category = self.category;
		[formatter setMinimumFractionDigits:[category.decimals intValue]];
		[formatter setMaximumFractionDigits:[category.decimals intValue]];
		[formatter setDecimalSeparator:@"."]; // makes sure the decimal separator is always a dot regardless of location, or there will be an SQl error on insert
		
		NSString *value = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromNumber:self.decimal]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"decimal", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
		
		[formatter release];
	}
	
	// add dates...
	
	if (self.timestamp != nil) {
	
		NSDateFormatter *formatter = [NSDateFormatter fc_dateFormatterGMT];
		formatter.dateFormat = FCFormatTimestamp;
		
		NSString *value = [[NSString alloc] initWithFormat:@"'%@'", [formatter stringFromDate:self.timestamp]];
		NSDictionary *set = [[NSDictionary alloc] initWithObjectsAndKeys:@"timestamp", @"Column", value, @"Value", nil];
		[sets addObject:set];
		
		[value release];
		[set release];
	}
	
	// OBS! created and modified are system variables and can never be independently 
	// changed by user. Instead, they are set int FCDatabaseHandler -insertSets:intoTables:
	// and FCDatabaseHandler -updateTable:withSets:filters: respectively.
	
	// * rest of components for database update
	
	NSString *table = @"entries";
	
	if (self.eid == nil) {
		
		// * SAVE
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSRange range = NSMakeRange(0, [sets count]);
		[dbh insertSets:[sets subarrayWithRange:range] intoTable:table];
		
		// * load EID and CREATED
		
		NSString *columns = @"eid, max(created) as created";
		NSString *filters = [NSString stringWithFormat:@"cid = '%@'", self.cid];
		
		NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filters];
		
		NSDictionary *row = [result objectAtIndex:0];
		
		self.eid = [row objectForKey:@"eid"];
		self.created = [row objectForKey:@"created"];
		
		[dbh release];
		
		// log
		
		if (self.owner == nil)
			NSLog(@"FCEntry -save: || SAVED entry.");
		
		else
			NSLog(@"FCEntry -save: || SAVED attached entry");
		
		// * make link to OWNER
		
		if (self.owner != nil)
			[self createLinkToOwner];
		
		// * post notification
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryCreated object:self];
		
	} else {
		
		// * UPDATE
		
		NSString *filter = [NSString stringWithFormat:@"eid ='%@'", self.eid];
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSRange range = NSMakeRange(0, [sets count]);
		[dbh updateTable:table withSets:[sets subarrayWithRange:range] filters:filter];
		
		[dbh release];
		
		// post notification
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryUpdated object:self];
		
		// log
		
		if (self.owner == nil)
			NSLog(@"FCEntry -save: || UPDATED entry.");
		
		else
			NSLog(@"FCEntry -save: || UPDATED attached entry");
	}
	
	[sets release];
}

-(void)delete {
/*	Deletes self from database.
	Also removes attached entries, links to owner, and associated files and locations. */
	
	if (self.eid != nil) {
		
		// delete all attachments
		
		[self loadAttachments];
		
		for (FCEntry *attachment in self.attachments)
			[attachment delete];
		
		// remove link to owner
		
		if (self.owner != nil)
			[self removeLinkToOwner];
		
		// delete associated files
		
		[self deleteAssocitedFiles];
	
		// delete self from database
		
		NSString *table = @"entries";
		NSString *criterion = [NSString stringWithFormat:@"eid = '%@'", self.eid];
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		[dbh deleteRowInTable:table withCriterion:criterion];
		
		[dbh release];
	
		// notify and log
		
		if (self.owner == nil) {
			
			NSLog(@"FCEntry -delete || DELETED entry.");
			[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryDeleted object:self];
		
		} else {
		
			NSLog(@"FCEntry -delete || DELETED attached entry");
		}
	}
}

-(void)loadAttachments {
/*	Loads all attachments to this entry from database and
	adds them to the attachments array. */
	
	// create a new attachments array if there is none
	
	if (self.attachments == nil) {
	
		NSMutableArray *newAttachments = [[NSMutableArray alloc] init];
		self.attachments = newAttachments;
		[newAttachments release];
	}
	
	// remove any already loaded attachments
	
	[self.attachments removeAllObjects];
	
	// retrieve all attached entries from db
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *table = @"entries";
	NSString *columns = @"*";
	NSString *joints = @"LEFT JOIN attachments ON attachments.attachment_eid = entries.eid";
	NSString *filters = [NSString stringWithFormat:@"attachments.owner_eid = '%@'", self.eid];
	
	NSArray *result = [dbh getColumns:columns 
							fromTable:table 
						   withJoints:joints 
							  filters:filters];
	
	[dbh release];
	
	// add each attached entry to attachments array
	
	for (NSDictionary *row in result) {
	
		FCEntry *attachment = [[FCEntry alloc] initWithDictionary:row];
		attachment.owner = self;
		[self.attachments addObject:attachment];
		[attachment release];
	}
}

-(void)createLinkToOwner {
/*	Creates a link in the database with self as attachment to owner. */
	
	if (self.eid != nil && self.owner.eid != nil) {
	
		// add link in database
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *table = @"attachments";
		
		NSString *value = [NSString stringWithFormat:@"'%@'", self.owner.eid];
		NSDictionary *ownerSet = [[NSDictionary alloc] initWithObjectsAndKeys:@"owner_eid", @"Column", value, @"Value", nil];
		
		value = [NSString stringWithFormat:@"'%@'", self.eid];
		NSDictionary *attachmentSet = [[NSDictionary alloc] initWithObjectsAndKeys:@"attachment_eid", @"Column", value, @"Value", nil];
		
		NSArray *sets = [[NSArray alloc] initWithObjects:ownerSet, attachmentSet, nil];
		
		[ownerSet release];
		[attachmentSet release];
		
		[dbh insertSets:sets intoTable:table];
		
		[sets release];
		[dbh release];
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationAttachmentAdded object:self];
		
		// log
		NSLog(@"FCEntry -createLinkToOwner: || CREATED attachments link");
	}
}

-(void)removeLinkToOwner {
/*	Removes the link in the database which attaches self to owner. */
	
	if (self.eid != nil && self.owner.eid != nil) {
		
		// remove link in database
		
		FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
		
		NSString *table = @"attachments";
		NSString *criterion = [NSString stringWithFormat:@"owner_eid = '%@' AND attachment_eid = '%@'", self.owner.eid, self.eid];
		
		[dbh deleteRowInTable:table withCriterion:criterion];
		
		[dbh release];
		
		// notify
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationAttachmentRemoved object:self];
		
		// log
		NSLog(@"FCEntry -removeLinkToOwner: || REMOVED attachments link");
	}
}

#pragma mark Files

-(NSString *)filePath {
/*	Returns a path if the entry had a file associated with it.
	Nil if no file. */
	
	NSString *documentsFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	
	NSString *filePath = [documentsFolder stringByAppendingPathComponent:self.string];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
		return filePath;
	
	return nil;
}

-(void)deleteAssocitedFiles {
/*	Removes any files associated with the entry. */
	
	if ([self.category.datatype isEqualToString:@"photo"] || 
		[self.category.datatype isEqualToString:@"audio"]) {
		
		if (self.string != nil) {
			
			// get path
			NSString *path = self.filePath;
			
			if (path != nil) {
				
				// remove files
				[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
				
				// log
				NSLog(@"FCEntry -deleteAssociatedFiles: || Removed file at path: %@", path);
			}
		}
	}
}

#pragma mark Attachments

-(void)addAttachment:(FCEntry *)attachment {
/*	Adds the given attachment to attachments array. */
	
	// make sure attachments are loaded
		
	if (self.attachments == nil)
		[self loadAttachments];
	
	// set self to owner and add to attachments array
	
	attachment.owner = self;
	
	[self.attachments addObject:attachment];
	
	// post notification
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationAttachmentAdded object:self];
}

-(void)unloadAttachments {
/*	Removes all attachments from attachments array without
	also deleting them from database. */
	
	if (self.attachments != nil) {
	
		for (FCEntry *attachment in self.attachments)
			[self removeAttachment:attachment andDelete:NO];
	}
}

-(void)removeAttachment:(FCEntry *)attachment andDelete:(BOOL)doDelete {
/*	Removes given attachment from attachments array and
	also deletes it from database if flagged. */
	
	if (self.attachments != nil) {
	
		if (doDelete) {
			
			[attachment delete];
		
		} else {
			
			attachment.owner = nil;
		}
		
		[self.attachments removeObject:attachment];
	}
}

#pragma mark Setup

-(void)makeNew {
/*	This removes any specific information about the entry, leaving only its data and
	category information, so that the object can be used as a template for a new entry. */
	
	self.owner = nil;
	
	self.eid = nil;
	
	self.title = nil;
	
	self.timestamp = nil;
	self.created = nil;
	
	self.uid = nil;
	
	self.attachments = nil;
}

-(void)copyEntry:(FCEntry *)anotherEntry {
/*	Implements shallow copying, i.e. shares pointer ivars with original. */
	
	self.owner = anotherEntry.owner;
	
	self.eid = anotherEntry.eid;
	
	self.title = anotherEntry.title;
	
	self.string = anotherEntry.string;
	self.integer = anotherEntry.integer;
	self.decimal = anotherEntry.decimal;
	
	self.timestamp = anotherEntry.timestamp;
	self.created = anotherEntry.created;
	
	self.cid = anotherEntry.cid;
	self.uid = anotherEntry.uid;
}

-(void)convertToNewUnit:(FCUnit *)newUnit {
/*	This converts any set numerical data to the given unit.
	Does NOT update the corresponding category. */
	
	if (![self.uid isEqualToString:newUnit.uid]) {
		
		if (self.integer != nil) {
			
			FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:newUnit];
			
			NSNumber *convertedNumber = [converter convertNumber:self.integer withUnit:self.unit roundedToScale:0];
			
			self.integer = convertedNumber;
			
			[converter release];
			
		} else if (self.decimal != nil) {
			
			FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:newUnit];
			
			NSInteger scale = [self.category.decimals integerValue];
			NSNumber *convertedNumber = [converter convertNumber:self.decimal withUnit:self.unit roundedToScale:scale];
			
			self.decimal = convertedNumber;
			
			[converter release];
		}
		
		self.uid = newUnit.uid;
	}
}

#pragma mark Descriptions

-(NSString *)descriptionWithExtensions:(BOOL)addExtensions converted:(BOOL)doConvert {
/*	Returns a string that describes the data content of this entry.
	The extensions argument determines if things like unit abbreviations are included.
	Nil if no data is set. */
	
	NSString *description;
	
	// string
	if (self.string != nil) {
	
		description = self.string;
	
	// numbers
	} else if (self.integer != nil || self.decimal != nil) {
		
		FCCategory *category = self.category;
		
		FCUnitConverter *converter;
		FCUnit *categoryUnit;
		if (doConvert) {
			
			converter = [[FCUnitConverter alloc] initWithTarget:category.unit];
			categoryUnit = category.unit;
		}
		
		// integer
		if (self.integer != nil) {
			
			NSNumber *trueInteger = doConvert ? [converter convertNumber:self.integer withUnit:self.unit] : self.integer;
			description = [[NSString alloc] initWithFormat:@"%d", [trueInteger intValue]];
		
		// decimal
		} else {
		
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			
			FCCategory *category = self.category;
			[formatter setMinimumFractionDigits:[category.decimals intValue]];
			[formatter setMaximumFractionDigits:[category.decimals intValue]];
			
			NSNumber *trueDecimal = doConvert ? [converter convertNumber:self.decimal withUnit:self.unit] : self.decimal;
			description = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromNumber:trueDecimal]];
			
			[formatter release];
		}
		
		if (addExtensions) {
			
			// add unit abbreviation
			FCUnit *unit = doConvert ? categoryUnit : self.unit;
			if (unit) {
				
				NSString *oldDescription = description;
				description = [[NSString alloc] initWithFormat:@"%@ %@", oldDescription, unit.abbreviation];
				[oldDescription release];
			}
		}
		
		// autorelease
		[description autorelease];
		
	} else {
	
		// if no data was set, return the category name
		description = self.category.name;
	}
	
	return description;
}

-(NSString *)fullDescription {
/*	Returns a string describing the entry's data value with any possible extensions.
	Nil if no data is set. */

	return [self descriptionWithExtensions:YES converted:NO];
}

-(NSString *)convertedFullDescription {
/*	Returns a string describing the entry's data value with any possible extensions
	 and converted to the currently set unit for the category.
	 Nil if no data is set. */
	
	return [self descriptionWithExtensions:YES converted:YES];
}

-(NSString *)shortDescription {
/*	Returns a string describing the entry's data value without any extensions.
	Nil if no data is set. */
	
	return [self descriptionWithExtensions:NO converted:NO];
}

-(NSString *)convertedShortDescription {
/*	Returns a string describing the entry's data value without any extensions,
	but converted to the currently set unit for the category.
	Nil if no data is set. */
	
	return [self descriptionWithExtensions:NO converted:YES];
}

-(NSString *)timestampDescription {
/*	Returns the full timestamp as a string with local datetime format.
	Nil if there is no timestamp. */

	if (self.timestamp != nil) {
	
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *description = [formatter stringFromDate:self.timestamp];
		
		[formatter release];
		
		return description;
	}
	
	return nil;
}

-(NSString *)dateDescription {
/*	Returns the date from the entry's timestamp as a string with local datetime format.
	Nil if there is no timestamp. */
	
	if (self.timestamp != nil) {
	
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterLongStyle];
		
		NSString *description = [formatter stringFromDate:self.timestamp];
		
		[formatter release];
		
		return description;
	}
	
	return nil;
}

-(NSString *)timeDescription {
/*	Returns the time from the entry's timestamp as a string with local datetime format.
	Nil if there is no timestamp. */
	
	if (self.timestamp != nil) {
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.timeStyle = NSDateFormatterShortStyle;
		
		NSString *timeAsString = [formatter stringFromDate:self.timestamp];
		
		[formatter release];
		
		return timeAsString;
	}
	
	// return nil if there is no timestamp
	return nil;
}

@end
