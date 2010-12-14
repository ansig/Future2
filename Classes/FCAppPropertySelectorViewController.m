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
//  FCAppPropertySelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 13/09/2010.
//

#import "FCAppPropertySelectorViewController.h"


@implementation FCAppPropertySelectorViewController

@synthesize entry, category;
@synthesize propertyToSelect;
@synthesize timestampLabel, datePicker;
@synthesize tableView, rows;
@synthesize quantity, system;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)theEntry {
	
	if (self = [super init]) {
		
		entry = [theEntry retain];
	}
	
	return self;
}

-(id)initWithCategory:(FCCategory *)theCategory {
	
	if (self = [super init]) {
		
		category = [theCategory retain];
	}
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[entry release];
	[category release];
	
	[timestampLabel release];
	[datePicker release];
 
	[tableView release];
	[rows release];
	
	[super dealloc];
}

#pragma mark View

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)pushUnitSystemSelectionViewController {
	
	FCAppPropertySelectorViewController *selectorViewController = self.category != nil ? [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category] : [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.parent = self.parent;
	selectorViewController.title = @"System";
	selectorViewController.quantity = self.quantity;
	selectorViewController.propertyToSelect = FCPropertyUnitSystem;
	
	[selectorViewController createUIContent];
	[selectorViewController showUIContent];
	
	[self.navigationController pushViewController:selectorViewController animated:YES];
	
	[selectorViewController release];
}

-(void)pushUnitSelectionViewController {
	
	FCAppPropertySelectorViewController *selectorViewController = self.category != nil ? [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category] : [[FCAppPropertySelectorViewController alloc] initWithEntry:self.entry];
	selectorViewController.parent = self.parent;
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = FCUnitQuantityAsString(self.quantity);
	selectorViewController.system = self.system;
	selectorViewController.quantity = self.quantity;
	selectorViewController.propertyToSelect = FCPropertyUnit;
	
	[selectorViewController createUIContent];
	[selectorViewController showUIContent];
	
	[self.navigationController pushViewController:selectorViewController animated:YES];
	
	[selectorViewController release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSInteger row = [indexPath row];
	
	id object = [self.rows objectAtIndex:row];
	if ([object isKindOfClass:[NSDictionary class]]) {
		
		NSDictionary *dictionary = [object copy];
		
		if (self.propertyToSelect == FCPropertyUnit) {
			
			NSString *text = [[NSString alloc] initWithFormat:@"%@ (%@)", [dictionary objectForKey:@"name"], [dictionary objectForKey:@"abbreviation"]];
			cell.textLabel.text = text;
			[text release];
	
		} else if (self.propertyToSelect == FCPropertyIcon) {
			
			UIImage *icon = [UIImage imageNamed:[dictionary objectForKey:@"name"]];
			cell.imageView.image = icon;
		
			cell.textLabel.text = [[dictionary objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"Icon.png" withString:@""];
		} 
	
		[dictionary release];
		
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	} else if ([object isKindOfClass:[NSString class]]) {
	
		NSString *string = [object copy];
		cell.textLabel.text = string;
		[string release];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	} else if ([object isKindOfClass:[UIColor class]]) {
	
		UIColor *color = (UIColor *)object;
		cell.backgroundColor = color; 
	}
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (self.propertyToSelect == FCPropertyUnitSystem) {

		self.system = indexPath.row;
		[self pushUnitSelectionViewController];
	
	} else if (self.propertyToSelect == FCPropertyUnitQuantity) {
		
		self.quantity = indexPath.row;
		
		if (self.quantity == FCUnitQuantityWeight || self.quantity == FCUnitQuantityLength || self.quantity == FCUnitQuantityVolume)
			[self pushUnitSystemSelectionViewController];
		
		else
			[self pushUnitSelectionViewController];
	
	} else {
		
		[self save];
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {

	// OBS! equivalent functionality is here done in -createContentForUnitSelection,
	// -createContentForUnitQuantitySelection and -createContentForUnitSystemSelection
}

#pragma mark FCAppOverlayViewController

-(void)createUIContent {
	
	if (self.propertyToSelect == FCPropertyUnit)
		[self createContentForUnitSelection];
	
	else if (self.propertyToSelect == FCPropertyUnitSystem)
		[self createContentForUnitSystemSelection];
	
	else if (self.propertyToSelect == FCPropertyUnitQuantity)
		[self createContentForUnitQuantitySelection];
	
	else if (self.propertyToSelect == FCPropertyDateTime)
		[self createContentForTimestampSelection];
	
	else if (self.propertyToSelect == FCPropertyIcon)
		[self createContentForIconSelection];
	
	else if (self.propertyToSelect == FCPropertyColor)
		[self createContentForColorSelection];
}

-(void)presentUIContent {
	
	if (self.propertyToSelect == FCPropertyDateTime) {
		
		[self presentContentForTimestampSelection];
		
	} else {
	
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		
		[self animateTableViewAppearance];
	}
}

-(void)showUIContent {
	
	if (self.tableView != nil)
		[self.view addSubview:self.tableView];
}

-(void)dismissUIContent {
	
	if (self.datePicker != nil) {
		
		[self.timestampLabel removeFromSuperview];
		
		CGFloat verticalOffset = self.view.frame.size.height - self.datePicker.frame.origin.x;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.datePicker.transform = translation; }
						 completion:^ (BOOL finished) { [self.datePicker removeFromSuperview]; }];
		
	} else if (self.tableView != nil) {
		
		CGFloat verticalOffset = self.view.frame.size.height - self.tableView.frame.origin.x;
		CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.tableView.transform = translation; } 
						 completion:^ (BOOL finished) { [self.tableView removeFromSuperview]; } ];
	}
}

#pragma mark Animation

-(void)animateTableViewAppearance {

	// animate table view appearance
	CGFloat verticalOffset = self.view.frame.size.height - self.tableView.frame.origin.x;
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
	
	self.tableView.transform = translation;
	
	[self.view addSubview:self.tableView];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.tableView.transform = CGAffineTransformIdentity; } ];
}

#pragma mark Custom

-(void)save {
	
	if (self.entry != nil) {
	
		if (self.datePicker != nil) {
			
			// timestamp
			self.entry.timestamp = self.datePicker.date;
			
		} else if (self.tableView != nil) {
			
			// unit
			NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
			FCUnit *newUnit = [FCUnit unitWithUID:[[rows objectAtIndex:indexPath.row] objectForKey:@"uid"]];
			
			[self.entry convertToNewUnit:newUnit];
			
			// post notification
			[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationConvertLogOrUnitChanged object:self];
		}
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryObjectUpdated object:self];
		
		// dismiss
		[super dismiss];
		
	} else if (self.category != nil) {
	
		if (self.propertyToSelect == FCPropertyUnit) {
		
			NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
			self.category.uid = [[rows objectAtIndex:indexPath.row] objectForKey:@"uid"];
		
		} else if (self.propertyToSelect == FCPropertyIcon) {
		
			NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
			NSDictionary *dictionary = [rows objectAtIndex:indexPath.row];
			
			self.category.iid = [dictionary objectForKey:@"iid"];
			self.category.iconName = [dictionary objectForKey:@"name"];
		
		} else if (self.propertyToSelect == FCPropertyColor) {
		
			NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
			NSInteger colorIndex = indexPath.row;
			
			NSNumber *color = [[NSNumber alloc] initWithInteger:colorIndex];
			self.category.colorIndex = color;
			[color release];
		}
		
		[super dismiss];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryObjectUpdated object:self];
	}
}

-(void)cancel {
	
	if (self.entry != nil) {
	
		// remove the timestamp
		self.entry.timestamp = nil;
	
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryObjectUpdated object:self];
	
	} else if (self.category != nil) {
	
		// remove the unit
		self.category.uid = nil;
		
		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationCategoryObjectUpdated object:self];
	}
	
	// super dismiss
	[super dismiss];
}

-(void)createContentForTimestampSelection {
	
	// * Left button
	NSString *title;
	if (self.entry.timestamp == nil)
		title = @"Cancel";
	else
		title = @"Remove";
	
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = newLeftButton;
	[newLeftButton release];
	
	// * Right button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Label
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 24.0f)];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.textColor = [UIColor whiteColor];
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	self.timestampLabel = newLabel;
	
	// * Date picker
	UIDatePicker *newDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 216.0f)];
	newDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	newDatePicker.maximumDate = now;
	[now release];
	
	self.datePicker = newDatePicker;
	
	[newDatePicker release];
}

-(void)createContentForUnitSelection {
	
	// * Rows
	
	NSMutableArray *newRows = [[NSMutableArray alloc] init];

	NSString *table = @"units";
	NSString *columns = @"uid, name, abbreviation";
	
	NSString *filter = [NSString stringWithFormat:@"system = %d AND quantity = %d", self.system, self.quantity];
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filter options:@"ORDER BY name"];
	
	[dbh release];
	
	for (NSDictionary *row in result) {
	
		[newRows addObject:row];
	}
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	
	[self createTableView];
}

-(void)createContentForUnitQuantitySelection {
	
	// * Cancel button
	
	NSString *title;
	if (self.category.uid == nil)
		title = @"Cancel";
	else
		title = @"Remove";
	
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = newLeftButton;
	[newLeftButton release];
	
	// * Rows
	
	NSMutableArray *newRows = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < FCUnitQuantityCount(); i++)
		[newRows addObject:FCUnitQuantityAsString(i)];
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	
	[self createTableView];
}

-(void)createContentForIconSelection {
	
	// * Rows
	
	NSMutableArray *newRows = [[NSMutableArray alloc] init];
	
	NSString *table = @"icons";
	NSString *columns = @"iid, name";
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSArray *result = [dbh getColumns:columns fromTable:table withOptions:@"ORDER BY name"];
	
	[dbh release];
	
	for (NSDictionary *row in result) {
		
		[newRows addObject:row];
	}
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	
	[self createTableView];
}

-(void)createContentForUnitSystemSelection {
	
	// * Rows
	
	NSMutableArray *newRows = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < 3; i++)
		[newRows addObject:FCUnitSystemAsString(i)];
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	
	[self createTableView];
}

-(void)createContentForColorSelection {
	
	// * Rows
	
	NSMutableArray *newRows = [[NSMutableArray alloc] init];
	
	for (UIColor *color in [[FCColorCollection sharedColorCollection] allFreeColors])
		[newRows addObject:color];
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	
	[self createTableView];
}

-(void)presentContentForTimestampSelection {
	
	// show navigation bar
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[self.view addSubview:self.timestampLabel];
	
	// set initial data if there is any
	if (self.entry.timestamp != nil) 
		self.timestampLabel.text = self.entry.timestampDescription;
	
	// animate date picker appearance
	
	CGFloat verticalOffset = self.view.frame.size.height - self.datePicker.frame.origin.x;
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
	
	self.datePicker.transform = translation;
	
	[self.view addSubview:self.datePicker];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.datePicker.transform = CGAffineTransformIdentity; } 
					 completion:^ (BOOL finished) { if (self.entry.timestamp != nil) [self.datePicker setDate:self.entry.timestamp]; }];
}

-(void)createTableView {

	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	
	[newTableView release];
}

@end
