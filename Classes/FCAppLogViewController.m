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
@synthesize searchBar, searchWasActive;

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
	
	[searchBar release];
	
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
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchMode)];
	self.navigationItem.leftBarButtonItem = newLeftButton;
	[newLeftButton release];
	
	// * Left button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(loadSortByActionSheet)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Table view
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:newTableView];
	
	[newTableView release];
	
	// * Table view header and footer
	
	[self loadTableHeaderAndFooter];
	
	// * Search bar and search display controller
	
	[self loadSearchBarAndSearchDisplayController];
	
	// * Log dates
	
	[self onLogDateChangedNotification]; // OBS! also loads sections and rows!
	
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
	
	// Reactivate search display
	if (self.searchWasActive)
		[self enterSearchMode];
	
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	// Rotation no longer allowed
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationNotAllowed object:self];
	
	// Deactivate search display
	self.searchWasActive = self.searchDisplayController.active;
	if (self.searchDisplayController.active)
		[self.searchDisplayController setActive:NO animated:YES];
	
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

-(void)loadSortByActionSheet {

	UIActionSheet *sortByActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select what to sort on:" 
																   delegate:self 
														  cancelButtonTitle:nil
													 destructiveButtonTitle:nil 
														  otherButtonTitles:nil];
	
	
	NSInteger count = FCSortByCount();
	for (int i = 0; i < count; i++)
		[sortByActionSheet addButtonWithTitle:FCSortByAsString(i)];
	
	[sortByActionSheet addButtonWithTitle:@"Cancel"];
	sortByActionSheet.cancelButtonIndex = count;
	
	sortByActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	[sortByActionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
	
	[sortByActionSheet release];
}

-(void)loadTableHeaderAndFooter {
	
	// * Table header view
	
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"40pxBandBackground.png"]];
	
	UILabel *tableHeaderViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 270.0f, 40.0f)];
	tableHeaderViewLabel.tag = 1;
	tableHeaderViewLabel.backgroundColor = [UIColor clearColor];
	tableHeaderViewLabel.font = kAppSmallLabelFont;
	tableHeaderViewLabel.textColor = [UIColor blackColor];
	tableHeaderViewLabel.textAlignment = UITextAlignmentLeft;
	
	[tableHeaderView addSubview:tableHeaderViewLabel];
	
	[tableHeaderViewLabel release];
	
	UIButton *tableHeaderViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	tableHeaderViewButton.frame = CGRectMake(280.0f, 5.0f, 30.0f, 30.0f);
	
	[tableHeaderViewButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
	[tableHeaderViewButton addTarget:self action:@selector(loadDateSelectorViewController) forControlEvents:UIControlEventTouchUpInside];
	
	[tableHeaderView addSubview:tableHeaderViewButton];
	
	self.tableView.tableHeaderView = tableHeaderView;
	
	[tableHeaderView release];
	
	// * Table footer view
	
	UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	tableFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"40pxBandBackground.png"]];
	
	UILabel *tableFooterViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 275.0f, 40.0f)];
	tableFooterViewLabel.tag = 1;
	tableFooterViewLabel.backgroundColor = [UIColor clearColor];
	tableFooterViewLabel.font = kAppSmallLabelFont;
	tableFooterViewLabel.textColor = [UIColor blackColor];
	tableFooterViewLabel.textAlignment = UITextAlignmentLeft;
	
	[tableFooterView addSubview:tableFooterViewLabel];
	
	[tableFooterViewLabel release];
	
	UIButton *tableFooterViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	tableFooterViewButton.frame = CGRectMake(280.0f, 5.0f, 30.0f, 30.0f);
	
	[tableFooterViewButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
	[tableFooterViewButton addTarget:self action:@selector(loadDateSelectorViewController) forControlEvents:UIControlEventTouchUpInside];
	
	[tableFooterView addSubview:tableFooterViewButton];
	
	self.tableView.tableFooterView = tableFooterView;
	
	[tableFooterView release];
}

-(void)loadSearchBarAndSearchDisplayController {
	
	UISearchBar *newSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	newSearchBar.tintColor = kTintColor;
	newSearchBar.placeholder = @"Example: glucose";
	
	self.searchBar = newSearchBar;
	
	[newSearchBar release];
	
	UISearchDisplayController *newSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:newSearchBar contentsController:self];
	newSearchDisplayController.delegate = self;
	newSearchDisplayController.searchResultsDataSource = self;
	newSearchDisplayController.searchResultsDelegate = self;
}

#pragma mark Animation

-(void)animateSearchBarFadeIn {
	
	self.searchBar.alpha = 0.0f;
	
	[self.view addSubview:self.searchBar];
	
	[UIView animateWithDuration:0.25f 
					 animations:^ { self.searchBar.alpha = 1.0f; } ];
}

-(void)animateSearchBarFadeOut {

	[UIView animateWithDuration:0.25f 
					 animations:^ { self.searchBar.alpha = 0.0f; } 
					 completion:^ (BOOL finished) { [self.searchBar removeFromSuperview]; } ];
}

#pragma mark Notifications

-(void)onLogDateChangedNotification {
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	self.startDate = [logDates objectForKey:@"StartDate"];
	self.endDate = [logDates objectForKey:@"EndDate"];
		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	
	NSString *logDatesString = [[NSString alloc] initWithFormat:@"%@ - %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
	
	UILabel *headerLabel = (UILabel *)[self.tableView.tableHeaderView viewWithTag:1];
	headerLabel.text = logDatesString;
	
	UILabel *footerLabel = (UILabel *)[self.tableView.tableFooterView viewWithTag:1];
	footerLabel.text = logDatesString;
	
	[logDatesString release];
		
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

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex != FCSortByCount()) {
	
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		FCSortBy currentSortBy = [defaults integerForKey:FCDefaultLogSortBy];
		
		if (currentSortBy != buttonIndex) {
			
			[defaults setInteger:buttonIndex forKey:FCDefaultLogSortBy];
		
			[self loadSectionsAndRows];
			[self.tableView reloadData];
		}
	}
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
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// default is to use the entry's own description, but uses converted description
	// if the user has enabled the convert log option
	cell.textLabel.text = [defaults boolForKey:FCDefaultConvertLog] ? anEntry.convertedFullDescription : anEntry.fullDescription;
	
	cell.detailTextLabel.text = [defaults integerForKey:FCDefaultLogSortBy] == FCSortByDate ? anEntry.timeDescription : anEntry.timestampDescription;
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

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
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
	[theTableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	// retain the entry
	FCEntry *entry = [[[sections objectAtIndex:section] objectAtIndex:row] retain];
	
	if ([[self.sections objectAtIndex:section] count] == 1) {
		
		// remove section array and section title
		[sections removeObjectAtIndex:section];
		[sectionTitles removeObjectAtIndex:section];
		
		// remove the section
		[theTableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
		
	} else {
		
		// remove the entry object from sections array
		[[sections objectAtIndex:section] removeObjectAtIndex:row];
		
		// remove the row
		[theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
	
	// load new
	
	NSDictionary *newSectionTitlesAndSections = nil;
	
	FCSortBy sortyBy = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultLogSortBy];
	switch (sortyBy) {
			
		case FCSortByDate:
			newSectionTitlesAndSections = [self sectionsAndRowsSortedByDate];
			break;
			
		case FCSortByCategory:
			newSectionTitlesAndSections = [self sectionsAndRowsSortedByCategory];
			break;
			
		case FCSortByAttachment:
			newSectionTitlesAndSections = [self sectionsAndRowsSortedByAttachment];
			break;
			
		default:
			break;
	}
	
	// save new
	
	self.sectionTitles = [newSectionTitlesAndSections objectForKey:@"SectionTitles"];
	self.sections = [newSectionTitlesAndSections objectForKey:@"Sections"];
}

#pragma mark UISearchDisplayControllerDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationAllowed object:self];
	
	[self animateSearchBarFadeOut];
}

#pragma mark Custom

-(NSDictionary *)sectionsAndRowsSortedByDate {
	
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	// date formatter for converting dates to/from strings
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = FCFormatDate;
	
	// date formatter for formatting title strings from dates
	NSDateFormatter *titlesFormatter = [[NSDateFormatter alloc] init];
	titlesFormatter.dateStyle = NSDateFormatterLongStyle;
	
	// get all the distinct dates within the date range
	NSString *titlesFilter = [[NSString alloc] initWithFormat:@"date(timestamp) >= '%@' AND date(timestamp) <= '%@' AND eid NOT IN (SELECT attachment_eid FROM attachments)", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];
	NSArray *titlesResult = [dbh getColumns:@"distinct(date(timestamp))" fromTable:@"entries" withFilters:titlesFilter options:@"ORDER BY timestamp DESC"];
	[titlesFilter release];
	
	for (NSDictionary *row in titlesResult) {
		
		// get the current date as a string
		NSString *dateAsString;
		
		NSArray *keys = [row allKeys];
		for (NSString *key in keys)
			dateAsString = [row objectForKey:key];
		
		// format and add the title to section titles array
		NSDate *date = [dateFormatter dateFromString:dateAsString];
		[newSectionTitles addObject:[titlesFormatter stringFromDate:date]];
		
		// get all the rows within the date range
		NSString *rowsFilter = [[NSString alloc] initWithFormat:@"eid NOT IN (SELECT attachment_eid FROM attachments) AND date(timestamp) = '%@'", dateAsString];
		NSArray *rowsResult = [dbh getColumns:@"*" fromTable:@"entries" withFilters:rowsFilter options:@"ORDER BY timestamp DESC"];
		[rowsFilter release];
		
		// add the result entries to an array
		
		NSMutableArray *section = [[NSMutableArray alloc] init];
		
		for (NSDictionary *row in rowsResult) {
			
			FCEntry *anEntry = [[FCEntry alloc] initWithDictionary:row];
			[anEntry loadAttachments];
			[section addObject:anEntry];
			[anEntry release];
		}
		
		// add the array to the sections array
		
		[newSections addObject:section];
		[section release];
	}
	
	[dbh release];
	[dateFormatter release];
	[titlesFormatter release];
	
	NSDictionary *sectionTitlesAndSections = [NSDictionary dictionaryWithObjectsAndKeys:newSectionTitles, @"SectionTitles", newSections, @"Sections", nil];
	
	[newSectionTitles release];
	[newSections release];
	
	return sectionTitlesAndSections;
}

-(NSDictionary *)sectionsAndRowsSortedByCategory {
	
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	// date formatter for converting dates to/from strings
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = FCFormatDate;
	
	// get all the distinct categories within the date range
	NSString *titlesFilter = [[NSString alloc] initWithFormat:@"date(timestamp) >= '%@' AND date(timestamp) <= '%@' AND eid NOT IN (SELECT attachment_eid FROM attachments)", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];
	NSString *titlesJoints = [[NSString alloc] initWithFormat:@"LEFT JOIN categories ON categories.cid = entries.cid"];
	
	NSArray *titlesResult = [dbh getColumns:@"distinct(entries.cid), categories.name" fromTable:@"entries" withJoints:titlesJoints filters:titlesFilter options:@"ORDER BY categories.name ASC"];
	
	[titlesFilter release];
	[titlesJoints release];
	
	[dateFormatter release];
	
	for (NSDictionary *row in titlesResult) {
		
		[newSectionTitles addObject:[row objectForKey:@"name"]];
		
		NSString *aCID = [row objectForKey:@"cid"];
		
		NSString *rowsFilter = [[NSString alloc] initWithFormat:@"eid NOT IN (SELECT attachment_eid FROM attachments) AND cid = '%@'", aCID];
		NSArray *rowsResult = [dbh getColumns:@"*" fromTable:@"entries" withFilters:rowsFilter options:@"ORDER BY timestamp DESC"];
		[rowsFilter release];
		
		NSMutableArray *section = [[NSMutableArray alloc] init];
		
		for (NSDictionary *row in rowsResult) {
			
			FCEntry *anEntry = [[FCEntry alloc] initWithDictionary:row];
			[anEntry loadAttachments];
			[section addObject:anEntry];
			[anEntry release];
		}
		
		[newSections addObject:section];
		[section release];
	}
	
	[dbh release];
	
	NSDictionary *sectionTitlesAndSections = [NSDictionary dictionaryWithObjectsAndKeys:newSectionTitles, @"SectionTitles", newSections, @"Sections", nil];
	
	[newSectionTitles release];
	[newSections release];
	
	return sectionTitlesAndSections;
}

-(NSDictionary *)sectionsAndRowsSortedByAttachment {

	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	// date formatter for converting dates to/from strings
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = FCFormatDate;
	
	// get all the distinct categories within the date range
	NSString *titlesFilter = [[NSString alloc] initWithFormat:@"date(e1.timestamp) >= '%@' AND date(e1.timestamp) <= '%@'", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];
	NSString *titlesJoints = [[NSString alloc] initWithFormat:@"INNER JOIN attachments as a ON e1.eid = a.owner_eid LEFT JOIN entries as e2 on e2.eid = a.attachment_eid LEFT JOIN categories as c ON e2.cid = c.cid"];
	
	NSArray *titlesResult = [dbh getColumns:@"e1.eid, c.name" fromTable:@"entries AS e1" withJoints:titlesJoints filters:titlesFilter options:@"ORDER BY c.name ASC"];
	
	[titlesFilter release];
	[titlesJoints release];
	
	[dateFormatter release];
	
	for (NSDictionary *row in titlesResult) {
		
		NSString *title = [[NSString alloc] initWithFormat:@"Have %@'s attached:", [row objectForKey:@"name"]];
		[newSectionTitles addObject:title];
		[title release];
		
		NSString *anEID = [row objectForKey:@"eid"];
		
		NSString *rowsFilter = [[NSString alloc] initWithFormat:@"eid = '%@'", anEID];
		NSArray *rowsResult = [dbh getColumns:@"*" fromTable:@"entries" withFilters:rowsFilter options:@"ORDER BY timestamp DESC"];
		[rowsFilter release];
		
		NSMutableArray *section = [[NSMutableArray alloc] init];
		
		for (NSDictionary *row in rowsResult) {
			
			FCEntry *anEntry = [[FCEntry alloc] initWithDictionary:row];
			[anEntry loadAttachments];
			[section addObject:anEntry];
			[anEntry release];
		}
		
		[newSections addObject:section];
		[section release];
	}
	
	[dbh release];
	
	NSDictionary *sectionTitlesAndSections = [NSDictionary dictionaryWithObjectsAndKeys:newSectionTitles, @"SectionTitles", newSections, @"Sections", nil];
	
	[newSectionTitles release];
	[newSections release];
	
	return sectionTitlesAndSections;
}

-(void)enterSearchMode {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationNotAllowed object:self];
	
	[self animateSearchBarFadeIn];
	
	[self.searchDisplayController setActive:YES animated:YES];
}

@end
