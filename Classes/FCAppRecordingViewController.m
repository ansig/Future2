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
//  FCAppRecordingViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppRecordingViewController.h"


@implementation FCAppRecordingViewController

@synthesize tableView;
@synthesize sectionTitles, sections;

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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[tableView release];
	
	[sectionTitles release];
	[sections release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppRecordingViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// * Table view
	
	[self loadSectionsAndRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:newTableView];
	
	[newTableView release];
	
	// * Notifications
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter addObserver:self selector:@selector(onCategoryCreatedNotification) name:FCNotificationCategoryCreated object:nil];
	[notificationCenter addObserver:self selector:@selector(onCategoryUpdatedNotification) name:FCNotificationCategoryUpdated object:nil];
	[notificationCenter addObserver:self selector:@selector(onCategoryDeletedNotification) name:FCNotificationCategoryDeleted object:nil];
}

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

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark FCCategoryList

-(void)onCategoryCreatedNotification {
	
	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onCategoryUpdatedNotification {

	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onCategoryDeletedNotification {
	
	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onCategoryObjectUpdatedNotification {
	
}

#pragma mark FCGroupedTableSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
	
	return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	FCCategory *aCategory = [[self.sections objectAtIndex:section] objectAtIndex:row];
	
	cell.textLabel.text = aCategory.name;
	
	[cell.imageView configureImageViewForCategory:aCategory];
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// get the selected category
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	FCCategory *aCategory = [[self.sections objectAtIndex:section] objectAtIndex:row];
	
	// create an new entry input view controller
	FCAppEntryViewController *newEntryViewController = [[FCAppNewEntryViewController alloc] initWithCategory:aCategory];
	newEntryViewController.title = aCategory.name;
	newEntryViewController.shouldAnimateContent = YES;
	
	// show the entry intut view controller
	[self presentOverlayViewController:newEntryViewController];
	
	// release the entry input view controller
	[newEntryViewController release];
	
	// finally deselect the row
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	// release any present sections and section titles arrays
	if (self.sectionTitles != nil)
		self.sectionTitles = nil;
	
	if (self.sections != nil)
		self.sections = nil;
	
	// get the owners for which we want to retrieve categories
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *table = @"owners";
	NSString *columns = @"oid, name";
	NSString *filters = @"oid IS NOT 'system_0_1' AND oid IS NOT 'system_0_4'"; // we do not want categories related to
																				// Glucose or Profile to appear here
	
	NSArray *owners = [dbh getColumns:columns fromTable:table withFilters:filters];
	
	[dbh release];
	
	// create new sections and section titles arrays
	
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	// loop through the retrieved owners
	for (NSDictionary *owner in owners) {
	
		// add owners name to tiles
		[newSectionTitles addObject:[owner objectForKey:@"name"]];
		
		// retrieve the owners categories
		NSArray *categories = [FCCategory allCategoriesWithOwner:[owner objectForKey:@"oid"]];
		
		// add as new section
		NSMutableArray *section = [[NSMutableArray alloc] initWithArray:categories];
		[newSections addObject:section];
		[section release];
	}
	
	// store new section titles and sections
	
	self.sectionTitles = newSectionTitles;
	[newSectionTitles release];
	
	self.sections = newSections;
	[newSections release];
}

@end
