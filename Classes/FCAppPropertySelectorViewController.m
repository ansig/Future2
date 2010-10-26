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

@synthesize timestampLabel, datePicker;
@synthesize tableView, rows;
@synthesize quantity, system;

#pragma mark Init

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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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
	NSDictionary *object = [self.rows objectAtIndex:row];
	NSString *text = [[NSString alloc] initWithFormat:@"%@ (%@)", [object objectForKey:@"name"], [object objectForKey:@"abbreviation"]];
	
	cell.textLabel.text = text;
	
	[text release];
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Dismiss
	[self dismiss];
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {

	// OBS! equivalent functionality is here done in -createContentForUnitSelection,
	// -createContentForUnitQuantitySelection and -createContentForUnitSystemSelection
}

#pragma mark Custom

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
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Label
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 24.0f)];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.textColor = [UIColor whiteColor];
	newLabel.textAlignment = UITextAlignmentCenter;
	newLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	self.timestampLabel = newLabel;
	[self.view addSubview:newLabel];
	
	// * Date picker
	UIDatePicker *newDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 460.0f, 320.0f, 216.0f)];
	newDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	newDatePicker.maximumDate = now;
	[now release];
	
	[self.view addSubview:newDatePicker];
	self.datePicker = newDatePicker;
	
	[newDatePicker release];
}

-(void)createContentForUnitSelection {
	
	// * Rows
	NSMutableArray *newRows = [[NSMutableArray alloc] init];

	NSString *table = @"units";
	NSString *columns = @"uid, name, abbreviation";
	
	NSString *filter = nil;
	if (self.quantity == FCUnitQuantityMass) {
		
		filter = [NSString stringWithFormat:@"kilogram IS NOT NULL AND system = %d", self.system]; // masses
	
	} else if (self.quantity == FCUnitQuantityLength) {
		
		filter = [NSString stringWithFormat:@"metre IS NOT NULL AND exponent = 1 AND system = %d", self.system]; // lengths
	
	} else if (self.quantity == FCUnitQuantityVolume) {
		
		filter = [NSString stringWithFormat:@"metre IS NOT NULL AND exponent = 3 AND system = %d", self.system]; // volumes
		
	} else if (self.quantity == FCUnitQuantityTime) {
		
		filter = [NSString stringWithFormat:@"second IS NOT NULL AND system = %d", self.system]; // times
		
	} else if (self.quantity == FCUnitQuantityGlucose) {
		
		filter = [NSString stringWithFormat:@"uid = '%@' OR uid = '%@'", FCKeyUIDGlucoseMillimolesPerLitre, FCKeyUIDGlucoseMilligramsPerDecilitre]; // glucose
		
	} else if (self.quantity == FCUnitQuantityInsulin) {
		
		filter = [NSString stringWithFormat:@"uid = '%@'", FCKeyUidInsulinUnits]; // insulin
	}
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filter];
	
	[dbh release];
	
	for (NSDictionary *row in result) {
	
		[newRows addObject:row];
	}
	
	self.rows = newRows;
	[newRows release];
	
	// * Table
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 460.0f, 320.0f, 416.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:self.tableView];
	
	[newTableView release];
}

-(void)createContentForUnitQuantitySelection {
	
}

-(void)createContentForUnitSystemSelection {
	
}

-(void)presentContentForTimestampSelection {
	
	// create content
	[self createContentForTimestampSelection];
	
	// show navigation bar
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// animate date picker appearance
	[UIView beginAnimations:@"PresentDatePicker" context:NULL];
	[UIView setAnimationDuration:kAppearDuration];
	
	CGRect newFrame = CGRectMake(0.0f, 200.0f, 320.0f, 216.0f);
	self.datePicker.frame = newFrame;
	
	[UIView commitAnimations];
	
	// set initial data if there is any
	if (self.entry.timestamp != nil) {
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.dateStyle = NSDateFormatterMediumStyle;
		formatter.timeStyle = NSDateFormatterShortStyle;
		
		NSString *string = [[NSString alloc] initWithString:[formatter stringFromDate:self.entry.timestamp]];
		self.timestampLabel.text = string;
		
		[formatter release];
		[string release];
		
		self.datePicker.date = self.entry.timestamp;
	}
}

-(void)presentContentForUnitSelection {
	
	// create the content
	[self createContentForUnitSelection];
	
	// show navigation bar
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// animate table view appearance
	[UIView beginAnimations:@"PresentTableView" context:NULL];
	[UIView setAnimationDuration:kAppearDuration];
	
	self.tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 416.0f);
	
	[UIView commitAnimations];
}

-(void)showContentForUnitQuantitySelection {
	
}

-(void)showContentForUnitSystemSelection {
	
}

-(void)dismiss {
	
	// save whatever data we have elements for
	if (self.datePicker != nil) {
	
		// timestamp
		if (!self.cancelled)
			self.entry.timestamp = self.datePicker.date;
		else
			self.entry.timestamp = nil;
	
	} else if (self.tableView != nil) {
	
		// unit
		NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
		FCUnit *newUnit = [FCUnit unitWithUID:[[rows objectAtIndex:indexPath.row] objectForKey:@"uid"]];
		
		[self.entry convertToNewUnit:newUnit];
		
		// also update the category
		FCCategory *category = self.entry.category;
		
		[category saveNewUnit:newUnit andConvert:YES];

		// post notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationConvertLogOrUnitChanged object:self];
	}
	
	// post notifications
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryUpdated object:self];
	
	// super dismiss
	[super dismiss];
}

-(void)dismissUIElements {
	
	if (self.datePicker != nil) {
		
		[self.timestampLabel removeFromSuperview];
		
		[UIView beginAnimations:@"DismissDatePicker" context:NULL];
		[UIView setAnimationDuration:kDisappearDuration];
		
		CGRect newFrame = CGRectMake(0.0f, 460.f, 320.0f, 216.0f);
		self.datePicker.frame = newFrame;
		
		[UIView commitAnimations];
	
	} else if (self.tableView != nil) {
	
		[UIView beginAnimations:@"DismissTableView" context:NULL];
		[UIView setAnimationDuration:kDisappearDuration];
		
		CGRect newFrame = CGRectMake(0.0f, 460.f, 320.0f, 416.0f);
		self.tableView.frame = newFrame;
		
		[UIView commitAnimations];
	}
}

-(void)cancel {
	
	self.cancelled = YES;
	
	[self dismiss];
}

@end
