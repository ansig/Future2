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
//  FCAppSettingsViewMessagesViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 31/01/2011.
//

#import "FCAppViewController.h" // SUPERCLASS


@interface FCAppSettingsViewMessagesViewController : FCAppViewController <FCGroupedTableSourceDelegate> {

	UITableView *tableView;
	
	NSMutableArray *sectionTitles;
	NSMutableArray *sections;
}

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sections;

@end
