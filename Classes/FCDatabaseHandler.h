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
//  FCDatabaseHandler.h
//  Future2
//
//  Created by Anders Sigfridsson on 08/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//


#import "sqlite3.h"

@interface FCDatabaseHandler : NSObject {

	sqlite3 *_database;
}

// Get
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withFilters:(NSString *)filters;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withOptions:(NSString *)options;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withFilters:(NSString *)filters options:(NSString *)options;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints filters:(NSString *)filters;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints options:(NSString *)options;
-(NSArray *)getColumns:(NSString *)columns fromTable:(NSString *)table withJoints:(NSString *)joints filters:(NSString *)filters options:(NSString *)options;


// Set
-(void)insertSets:(NSArray *)sets intoTable:(NSString *)table;
-(void)updateTable:(NSString *)table withSets:(NSArray *)sets filters:(NSString *)filters;

// Custom
-(NSString *)primaryKeyColumnNameForTable:(NSString *)table;
-(NSString *)newPrimaryKeyForTable:(NSString *)table;

@end
