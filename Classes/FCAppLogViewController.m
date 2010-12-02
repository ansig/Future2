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
//  FCAppLogViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppLogViewController.h"


@implementation FCAppLogViewController

@synthesize startDate, endDate;
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
	
	// remove self as observer from notification center
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[startDate release];
	[endDate release];
	
	[tableView release];
	
	[sectionTitles release];
	[sections release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	self.view = view;
	[view release];
	
	// * Left button
	UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(loadDateSelectorViewController)];
	self.navigationItem.leftBarButtonItem = newButton;
	[newButton release];
	
	// * Dates and left button title
	[self onLogDateChangedNotification]; // OBS! also loads sections and rows!
	
	// * Table view
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:newTableView];
	
	[newTableView release];
	
	// Start listening to certain notifications
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	// FCEntryList
	[notificationCenter addObserver:self selector:@selector(onEntryUpdatedNotification) name:FCNotificationEntryUpdated object:nil];
	[notificationCenter addObserver:self selector:@selector(onEntryCreatedNotification) name:FCNotificationEntryCreated object:nil];
	[notificationCenter addObserver:self selector:@selector(onEntryDeletedNotification) name:FCNotificationEntryDeleted object:nil];
	[notificationCenter addObserver:self selector:@selector(onAttachmentAddedNotification) name:FCNotificationAttachmentAdded object:nil];
	[notificationCenter addObserver:self selector:@selector(onAttachmentRemovedNotification) name:FCNotificationAttachmentRemoved object:nil];
	[notificationCenter addObserver:self selector:@selector(onCategoryUpdatedNotification) name:FCNotificationCategoryUpdated object:nil];
	
	// custom
	[notificationCenter addObserver:self selector:@selector(onConvertLogOrUnitChange) name:FCNotificationConvertLogOrUnitChanged object:nil];
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

// NOTE: I put the operations for notifying whether rotation is allowed or not
// in did/will respectively because of the custom solution in FCAppRootViewController's 
// UINavigationBarDelegare and UITabBarDelegare methods to make sure
// the view controllers gets callbacks.

-(void)viewDidAppear:(BOOL)animated {

	// Notify that rotation is allowed
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationAllowed object:self];
	
	// Also make sure that the user default setting is not to show log on startup (makes FCAppRootViewController
	// select whatever FCDefaultTabBarIndex the user has specified as the tab when loaded).
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:NO forKey:FCDefaultShowLog];
	
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	// Rotation no longer allowed
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationNotAllowed object:self];
	
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadDateSelectorViewController {
	
	// start listening to date changed notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogDateChangedNotification) name:FCNotificationLogDateChanged object:nil];
	
	// create and present a new selector view controller
	FCAppLogDateSelectorViewController *selectorViewController = [[FCAppLogDateSelectorViewController alloc] init];
	selectorViewController.shouldAnimateContent = YES;
	selectorViewController.title = @"Select log period";
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Notifications

-(void)onLogDateChangedNotification {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	self.startDate = [logDates objectForKey:@"StartDate"];
	self.endDate = [logDates objectForKey:@"EndDate"];
	
	// also compose title for the select button
		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterShortStyle;
		
	self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:@"%@-%@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
		
	[formatter release];

	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onConvertLogOrUnitChange {
/*	Catches notifications for when the user changes a unit on a category or sets the default option convert log. */
	
	[self.tableView reloadData];
}

#pragma mark FCEntryList

-(void)onEntryCreatedNotification {
	
	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onEntryUpdatedNotification {
	
	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onEntryDeletedNotification {
	
	[self loadSectionsAndRows];
	[self.tableView reloadData];
}

-(void)onAttachmentAddedNotification {
	
	[self.tableView reloadData];
}

-(void)onAttachmentRemovedNotification {
	
	[self.tableView reloadData];
}

-(void)onCategoryUpdatedNotification {

	[self.tableView reloadData];
}

#pragma mark FCGroupedTableSourceDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	FCEntry *anEntry = [[self.sections objectAtIndex:section] objectAtIndex:row];
	
	// default is to use the entry's own description, but uses converted description
	// if the user has enabled the convert log option
	cell.textLabel.text = [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog] ? anEntry.convertedFullDescription : anEntry.fullDescription;
	
	cell.detailTextLabel.text = anEntry.timeDescription;
	cell.imageView.image = [UIImage imageNamed:anEntry.category.iconName];
	
	if ([anEntry.attachments count] > 0) {
	
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attachmentsIcon.png"]];
		cell.accessoryView = imageView;
		[imageView release];
	
	} else {
		
		cell.accessoryView = nil;
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	// get the entry
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	FCEntry *anEntry = [[self.sections objectAtIndex:section] objectAtIndex:row];
	
	// create an entry input view controller
	FCAppEntryViewController *anEntryViewController = [[FCAppEntryViewController alloc] initWithEntry:anEntry];
	anEntryViewController.title = anEntry.category.name;
	anEntryViewController.navigationControllerFadesInOut = YES;
	anEntryViewController.isOpaque = YES;
	anEntryViewController.shouldAnimateToCoverTabBar = YES;
	
	// present the new controllers
	[self presentOverlayViewController:anEntryViewController];
	
	// release the entry input view controller
	[anEntryViewController release];
	
	// finally deselect the row
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	// retain the entry
	FCEntry *entry = [[[sections objectAtIndex:section] objectAtIndex:row] retain];
	
	if ([[self.sections objectAtIndex:section] count] == 1) {
		
		// remove section array
		[sections removeObjectAtIndex:section];
		
		// remove the section
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
		
	} else {
		
		// remove the entry object from sections array
		[[sections objectAtIndex:section] removeObjectAtIndex:row];
		
		// remove the row
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	
	// delete the entry from database afer delay that allows 
	// table view row animations to finish
	[entry performSelector:@selector(delete) withObject:nil afterDelay:0.25f];
	[entry performSelector:@selector(release) withObject:nil afterDelay:0.25f];
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
/*	Loads section titles and all entries within the start date - end date interval from the database */
	
	// release old
	if (self.sectionTitles != nil)
		self.sectionTitles = nil;
	
	if (self.sections != nil)
		self.sections = nil;
	
	// database handler
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	// date formatter for converting dates to/from strings
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = FCFormatDate;
	
	// new titles and sections arrays
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	// get all the distinct dates within the date range
	NSString *titlesFilter = [[NSString alloc] initWithFormat:@"date(timestamp) >= '%@' AND date(timestamp) <= '%@' AND eid NOT IN (SELECT attachment_eid FROM attachments)", [formatter stringFromDate:self.startDate], [formatter stringFromDate:self.endDate]];
	NSArray *resultForTitles = [dbh getColumns:@"distinct(date(timestamp))" fromTable:@"entries" withFilters:titlesFilter options:@"ORDER BY timestamp DESC"];
	[titlesFilter release];
	
	// date formatter for formatting title strings from dates
	NSDateFormatter *stringFormatter = [[NSDateFormatter alloc] init];
	stringFormatter.dateStyle = NSDateFormatterLongStyle;
	
	// loop through the section titles
	for (NSDictionary *row in resultForTitles) {
	
		// get the current date as a string
		NSString *dateAsString;
		
		NSArray *keys = [row allKeys];
		for (NSString *key in keys)
			dateAsString = [row objectForKey:key];
		
		// format and add the title
		NSDate *date = [formatter dateFromString:dateAsString];
		[newSectionTitles addObject:[stringFormatter stringFromDate:date]];
		
		// get all the rows within the date range
		NSString *rowFilters = [[NSString alloc] initWithFormat:@"eid NOT IN (SELECT attachment_eid FROM attachments) AND date(timestamp) = '%@'", dateAsString];
		NSArray *resultForRows = [dbh getColumns:@"*" fromTable:@"entries" withFilters:rowFilters options:@"ORDER BY timestamp DESC"];
		[rowFilters release];
		
		// add the result entries to an array
		
		NSMutableArray *section = [[NSMutableArray alloc] init];

		for (NSDictionary *row in resultForRows) {
			
			FCEntry *anEntry = [[FCEntry alloc] initWithDictionary:row];
			[anEntry loadAttachments];
			[section addObject:anEntry];
			[anEntry release];
		}
		
		// add the array to the sections array
		
		[newSections addObject:section];
		[section release];
	}
	
	// release
	
	[dbh release];
	[formatter release];
	[stringFormatter release];
	
	// finally, save the new sections
	
	self.sectionTitles = newSectionTitles;
	[newSectionTitles release];
	
	self.sections = newSections;
	[newSections release];
}

@end
