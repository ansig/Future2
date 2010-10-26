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
//  FCDatabaseHandler.m
//  Future2
//
//  Created by Anders Sigfridsson on 08/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import "FCDatabaseHandler.h"


@implementation FCDatabaseHandler

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		
		NSString *databasePath = [documentsDir stringByAppendingPathComponent:FCDatabaseName];
		
		if (sqlite3_open([databasePath UTF8String], &_database) != SQLITE_OK) {
		
			NSLog(@"FCDatabaseHandler -init: Failed to open SQLite3 database with message: %s", sqlite3_errmsg(_database));
			
			return nil;
		}
	}
	
	return self;
}

#pragma mark Dealloc

-(void)dealloc {
	
	if (_database != nil)
		sqlite3_close(_database);
	
	[super dealloc];
}

#pragma mark Get

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:nil filters:nil options:nil];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withFilters:(NSString *)filters {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:nil filters:filters options:nil];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withOptions:(NSString *)options {

	NSArray *result = [self getColumns:columns fromTable:table withJoints:nil filters:nil options:options];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withFilters:(NSString *)filters options:(NSString *)options {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:nil filters:filters options:options];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:joints filters:nil options:nil];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints filters:(NSString *)filters {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:joints filters:filters options:nil];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints options:(NSString *)options {
	
	NSArray *result = [self getColumns:columns fromTable:table withJoints:joints filters:nil options:options];
	
	return result;
}

-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints filters:(NSString *)filters options:(NSString *)options {
	
	// * Compose a statement

	// create with columns and table
	NSString *statementAsString = [[NSString alloc] initWithFormat:@"SELECT %@ FROM %@", columns, table];
	
	// add joints
	if (joints != nil) {

		NSString *oldStatementAsString = statementAsString;
		statementAsString = [[NSString alloc] initWithFormat:@"%@ %@", oldStatementAsString, joints];
		[oldStatementAsString release];
	}
	
	// add filters
	
	/*	OBS!
		It would make it easier for the caller who has to compose complex filters
		(e.g. see FCAppPropertySelectorViewController -createContentForUnitSelection)
		if filters were an array instead of a string.
	 
		/anders
	*/
	
	if (filters != nil) {
		
		NSString *oldStatementAsString = statementAsString;
		statementAsString = [[NSString alloc] initWithFormat:@"%@ WHERE %@", oldStatementAsString, filters];
		[oldStatementAsString release];
	}
	
	// add options
	if (options != nil) {
		
		NSString *oldStatementAsString = statementAsString;
		statementAsString = [[NSString alloc] initWithFormat:@"%@ %@", oldStatementAsString, options];
		[oldStatementAsString release];
	}
	
	// log, format and release
	//NSLog(@"FCDatabaseHandler -getColumns:fromTable:withJoints:filters:options: || %@", statementAsString);
	const char *statement = [statementAsString UTF8String];
	[statementAsString release];
	
	// * Compile and traverse statement
	NSMutableArray *rows;
	
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare(_database, statement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		rows = [[NSMutableArray alloc] init];
		
		NSMutableArray *keys;
		NSMutableArray *objects;
		NSDictionary *row;
		
		BOOL isNull;
		
		while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
			
			keys = [[NSMutableArray alloc] init];
			objects = [[NSMutableArray alloc] init];
			
			int columnCount = sqlite3_column_count(compiledStatement);
			for (int i = 0; i < columnCount; i++) {
				
				isNull = NO;
				
				if (sqlite3_column_type(compiledStatement, i) == SQLITE_TEXT) {
					
					/*	
						OBS!
						
						The need to identify whether we are dealing with a string or a date here
						is due to the fact that datetimes are saved as strings in the database, 
						but the actual solution is too specific imho (ie it only works for 
						the specified columns). But I don't want to use isEqualToString to recognize
						string which correspond to the constant timestamp format (see FCConstants),
						because this might cause crashes in model initiation with data (e.g. see
						FCEntry -initWithData) if by chance someone has saved a timestamp formatted
						string in a field which the init method tries to store as NSString.
					 
						/Anders
					 
					*/
					
					NSString *column = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
					if ([column isEqualToString:@"created"] || [column isEqualToString:@"timestamp"] || [column isEqualToString:@"modified"]) {
						
						NSDateFormatter *formatter = [NSDateFormatter fc_dateFormatterGMT];
						[formatter setDateFormat:FCFormatTimestamp];
						
						NSString *dateAsString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)];
						NSDate *date = [formatter dateFromString:dateAsString];
						[dateAsString release];
						
						[objects addObject:date];
						
					} else {
					
						NSString *string = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)];
						[objects addObject:string];
						[string release];
					}
					
					[column release];
				
				} else if (sqlite3_column_type(compiledStatement, i) == SQLITE_INTEGER) {
					
					NSNumber *number = [[NSNumber alloc] initWithInt:sqlite3_column_int(compiledStatement, i)];
					[objects addObject:number];
					[number release];

				} else if (sqlite3_column_type(compiledStatement, i) == SQLITE_FLOAT) {
					
					NSNumber *number = [[NSNumber alloc] initWithDouble:sqlite3_column_double(compiledStatement, i)];
					[objects addObject:number];
					[number release];
				
				} else if (sqlite3_column_type(compiledStatement, i) == SQLITE_NULL) {
					
					isNull = YES;
				
				} else {
					
					NSLog(@"FCDatabaseHandler -getColumns:fromTable:withFilters:options: || Encountered column of undefined type");
					
					[rows release];
					[keys release];
					[objects release];
					
					sqlite3_finalize(compiledStatement);
					
					return nil;
				}
					
				if (!isNull) {
					
					NSString *column = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
					[keys addObject:column];
					[column release];
				}
			}
			
			row = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
			[rows addObject:row];
			[row release];
			
			[keys release];
			[objects release];
		}
		
		sqlite3_finalize(compiledStatement);
		
	} else {
	
		NSLog(@"FCDatabaseHandler -getColumns:fromTable:withFilters:options: || Failed to compile SQLite3 statement with message: %s", sqlite3_errmsg(_database));
		
		return nil;
	}
	
	// * Compose the result
	NSArray *result;
	
	// if there where no rows
	if ([rows count] == 0) {
		
		result = nil;
		
	// if there was only an empty row (e.g. when using certain sql functions
	// such as max() or coalesce()
	} else if ([[rows objectAtIndex:0] count] == 0) {
		
		result = nil;
	
	} else {
		
		NSRange range = NSMakeRange(0, [rows count]);
		result = [[NSArray alloc] initWithArray:[rows subarrayWithRange:range]];
		[result autorelease];
	}
	
	[rows release];
	
	return result;
}

#pragma mark Set

// insert

-(void)insertSets:(NSArray *)sets intoTable:(NSString *)table {

	// * Compose a statement
	
	// get the columns and values
	
	NSDictionary *set = [sets objectAtIndex:0];
	NSString *columns = [[set objectForKey:@"Column"] copy];
	NSString *values = [[set objectForKey:@"Value"] copy];
	
	NSString *oldColumns;
	NSString *oldValues;
	for (int i = 1; i < [sets count]; i++) {
	
		set = [sets objectAtIndex:i];
		
		oldColumns = columns;
		columns = [[NSString alloc] initWithFormat:@"%@, %@", oldColumns, [set objectForKey:@"Column"]];
		[oldColumns release];
		
		oldValues = values;
		values = [[NSString alloc] initWithFormat:@"%@, %@", oldValues, [set objectForKey:@"Value"]];
		[oldValues release];
	}
	
	// set created to now and add to columns and values
	
	NSDateFormatter *dateFormatter = [NSDateFormatter fc_dateFormatterGMT];
	dateFormatter.dateFormat = FCFormatTimestamp;
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	NSString *value = [[NSString alloc] initWithFormat:@"'%@'", [dateFormatter stringFromDate:now]];
	[now release];
	
	oldColumns = columns;
	columns = [[NSString alloc] initWithFormat:@"%@, %@", oldColumns, @"created"];
	[oldColumns release];
	
	oldValues = values;
	values = [[NSString alloc] initWithFormat:@"%@, %@", oldValues, value];
	[oldValues release];
	
	[value release];
	
	// get a new primary key
	NSString *primaryKeyColumn = [self primaryKeyColumnNameForTable:table];
	NSString *primaryKey = [self newPrimaryKeyForTable:table];
	
	oldColumns = columns;
	columns = [[NSString alloc] initWithFormat:@"%@, %@", oldColumns, primaryKeyColumn];
	[oldColumns release];
	
	oldValues = values;
	values = [[NSString alloc] initWithFormat:@"%@, %@", oldValues, primaryKey];
	[oldValues release];
	
	// add columns and values a to complete statement
	NSString *statementAsString = [[NSString alloc] initWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", table, columns, values];
	
	[columns release];
	[values release];
	
	// final statement
	const char *statement = [statementAsString UTF8String];
	
	[statementAsString release];
	
	// * Compile and execute the statement
	
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare(_database, statement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			
			NSLog(@"FCDatabaseHandler -insertSets:intoTable: || Could not execute statement with message: %s", sqlite3_errmsg(_database));
			NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
		}
		
	} else {
		
		NSLog(@"FCDatabaseHandler -insertSets:intoTable: || Could not compile statement with message: %s", sqlite3_errmsg(_database));
		NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
	}
	
	sqlite3_finalize(compiledStatement);
}

// update

-(void)updateTable:(NSString *)table withSets:(NSArray *)sets filters:(NSString *)filters {
	
	// * Compose a statement
	
	// compose sets
	NSDictionary *set = [sets objectAtIndex:0];
	NSString *setsAsString = [[NSString alloc] initWithFormat:@"%@=%@", [set objectForKey:@"Column"], [set objectForKey:@"Value"]];
	NSString *oldSetsAsString;
	for (int i = 1; i < [sets count]; i++) {
	
		set = [sets objectAtIndex:i];
		oldSetsAsString = setsAsString;
		setsAsString = [[NSString alloc] initWithFormat:@"%@, %@=%@", oldSetsAsString, [set objectForKey:@"Column"], [set objectForKey:@"Value"]];
		[oldSetsAsString release];
	}
	
	// also set modified to now and add to the sets
	
	NSDateFormatter *dateFormatter = [NSDateFormatter fc_dateFormatterGMT];
	dateFormatter.dateFormat = FCFormatTimestamp;
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	NSString *value = [[NSString alloc] initWithFormat:@"'%@'", [dateFormatter stringFromDate:now]];
	[now release];
	
	oldSetsAsString = setsAsString;
	setsAsString = [[NSString alloc] initWithFormat:@"%@, %@=%@", oldSetsAsString, @"modified", value];
	[oldSetsAsString release];
	[value release];
	
	// final statement
	NSString *statementAsString = [[NSString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, setsAsString, filters];
	const char *statement = [statementAsString UTF8String];
	
	[setsAsString release];
	[statementAsString release];
	
	// * Compile and execute the statement
	
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare(_database, statement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
		
			NSLog(@"FCDatabaseHandler -updateTable:withSets:filters: || Could not execute statement with message: %s", sqlite3_errmsg(_database));
			NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
		}
		
	} else {
	
		NSLog(@"FCDatabaseHandler -updateTable:withSets:filters: || Could not compile statement with message: %s", sqlite3_errmsg(_database));
		NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
	}
	
	sqlite3_finalize(compiledStatement);
}

#pragma mark Custom

#pragma mark Private

-(NSString *)primaryKeyColumnNameForTable:(NSString *)table {
/*	Returns the column name for the primary key column of table. */
	
	// TMP
	
	NSRange range = NSMakeRange(0, 1);
	NSString *name = [NSString stringWithFormat:@"%@id", [table substringWithRange:range]];
	
	return name; 
}

-(NSString *)newPrimaryKeyForTable:(NSString *)table {
/*	Creates a new primary key for the given table name and returns it.
	This includes updating the sequence number for the table. */
	
	// * platform
	NSString *platform = @"iphone";
	
	// * device identifier
	NSString *device = [[UIDevice currentDevice] uniqueIdentifier];
	
	// * user
	NSString *user = @"1"; // OBS! temporary
	
	// * sequence
	
	// add one to current sequence
	NSString *statementAsString = [[NSString alloc] initWithFormat:@"UPDATE sequences SET sequence = sequence+1 WHERE name = '%@'", table];
	const char *statement = [statementAsString UTF8String];
	[statementAsString release];
	
	sqlite3_stmt *compiledStatement;
	if (sqlite3_prepare(_database, statement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
			
			NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
			NSAssert1(0, @"FCDatabaseHandler -getNewPrimaryKeyForTable: || Could not execute statement with message: %s", sqlite3_errmsg(_database));
		}
		
	} else {
		
		NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
		NSAssert1(0, @"FCDatabaseHandler -getNewPrimaryKeyForTable: || Could not compile statement with message: %s", sqlite3_errmsg(_database));
	}
	
	sqlite3_finalize(compiledStatement);
	
	// get new sequence
	int sequence;
	
	statementAsString = [[NSString alloc] initWithFormat:@"SELECT sequence FROM sequences WHERE name = '%@'", table];
	statement = [statementAsString UTF8String];
	[statementAsString release];
	
	if (sqlite3_prepare(_database, statement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		
		if (sqlite3_step(compiledStatement) == SQLITE_ROW)
			sequence = sqlite3_column_int(compiledStatement, 0);
		
	} else {
		
		NSLog(@"Statement: %@", [NSString stringWithUTF8String:statement]);
		NSAssert1(0, @"FCDatabaseHandler -getNewPrimaryKeyForTable: || Could not compile statement with message: %s", sqlite3_errmsg(_database));
	}
	
	sqlite3_finalize(compiledStatement);
	
	// * compose new key
	
	NSString *key = [[NSString alloc] initWithFormat:@"'%@_%@_%@_%d'", platform, device, user, sequence];
	
	// * return new key
	
	[key autorelease];
	
	return key;
}

@end
