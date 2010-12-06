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
//  FCGraphPullMenuViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 08/10/2010.
//

#import "FCGraphPullMenuViewController.h"


@implementation FCGraphPullMenuViewController

@synthesize mode;
@synthesize sectionTitles, sections;
@synthesize tableView;
@synthesize selectButton, reorderButton, optionsButton, doneButton;
@synthesize selectedIndexPaths, storedSections;
@synthesize pendingChanges;

#pragma mark Init

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[sectionTitles release];
	[sections release];
	
	[tableView release];
 
	[selectButton release];
	[reorderButton release];
	[optionsButton release];
	[doneButton release];
	
	[selectedIndexPaths release];
	[storedSections release];
	
	[super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCGraphPullMenuViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// * Main view
	CGFloat width = kGraphPullMenuSize.width;
	CGFloat height = kGraphPullMenuSize.height;
	CGFloat xPos = (480.0f/2) - (width/2);
	CGFloat yPos = -height; // this is off screen
	
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
	newView.backgroundColor = [UIColor lightGrayColor];
	self.view = newView;
	[newView release];
	
	// * Menu buttons
	
	CGFloat padding = 5.0f;
	
	UIButton *newOptionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	width = 80.0f;
	height = 25.0f;
	xPos = padding;
	yPos = kGraphPullMenuSize.height - height - padding;
	
	newOptionsButton.frame = CGRectMake(xPos, yPos, width, height);
	
	newOptionsButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	newOptionsButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[newOptionsButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	[newOptionsButton setTitle:@"Options" forState:UIControlStateNormal];
	
	[newOptionsButton addTarget:self action:@selector(loadGeneralOptionsMode) forControlEvents:UIControlEventTouchUpInside];
	
	self.optionsButton = newOptionsButton;
	[self.view addSubview:newOptionsButton];
	
	UIButton *newReorderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	xPos = (kGraphPullMenuSize.width/2) - (width/2);
	yPos = kGraphPullMenuSize.height - height - padding;
	
	newReorderButton.frame = CGRectMake(xPos, yPos, width, height);
	
	newReorderButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	newReorderButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[newReorderButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	[newReorderButton setTitle:@"Reorder" forState:UIControlStateNormal];
	
	[newReorderButton addTarget:self action:@selector(loadReorderMode) forControlEvents:UIControlEventTouchUpInside];
	
	self.reorderButton = newReorderButton;
	[self.view addSubview:newReorderButton];
	
	UIButton *newSelectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	xPos = kGraphPullMenuSize.width - width - padding;
	yPos = kGraphPullMenuSize.height - height - padding;
	
	newSelectButton.frame = CGRectMake(xPos, yPos, width, height);
	
	newSelectButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	newSelectButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[newSelectButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	[newSelectButton setTitle:@"Select" forState:UIControlStateNormal];
	
	[newSelectButton addTarget:self action:@selector(loadSelectionMode) forControlEvents:UIControlEventTouchUpInside];
	
	self.selectButton = newSelectButton;
	[self.view addSubview:newSelectButton];
	
	// * Separator line
	
	CGFloat separation = 2.0f;
	UIView *newSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, yPos - padding, 320.0f, separation)];
	newSeparatorView.backgroundColor = [UIColor darkGrayColor];
	
	[self.view addSubview:newSeparatorView];
	[newSeparatorView release];
	
	// * Table view
	[self loadSectionsAndRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, yPos-padding) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:newTableView];
	
	[newTableView release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)loadDoneButtonForCurrentMode {
	
	if (self.doneButton != nil) {
		
		[self.doneButton removeFromSuperview];
		self.doneButton = nil;
	}

	UIButton *newDoneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	newDoneButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	newDoneButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[newDoneButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	[newDoneButton setTitle:@"Done" forState:UIControlStateNormal];
	
	// add different targets depending on mode
	if (self.mode == FCGraphMenuModeSelect) {
		
		newDoneButton.frame = self.selectButton.frame;
		[newDoneButton addTarget:self action:@selector(unloadSelectionMode) forControlEvents:UIControlEventTouchUpInside];
	
	} else if (self.mode == FCGraphMenuModeGraphOptions) {
		
		newDoneButton.frame = self.optionsButton.frame;
		[newDoneButton addTarget:self action:@selector(unloadGraphOptionsMode) forControlEvents:UIControlEventTouchUpInside];
	
	} else if (self.mode == FCGraphMenuModeGeneralOptions) {
		
		newDoneButton.frame = self.optionsButton.frame;
		[newDoneButton addTarget:self action:@selector(unloadGeneralOptionsMode) forControlEvents:UIControlEventTouchUpInside];
	
	} else if (self.mode == FCGraphMenuModeReorder) {
		
		newDoneButton.frame = self.reorderButton.frame;
		[newDoneButton addTarget:self action:@selector(unloadReorderMode) forControlEvents:UIControlEventTouchUpInside];
	}
	
	newDoneButton.alpha = 0.0f; // in preparation for fade in animation when loading select mode
	
	self.doneButton = newDoneButton;
}

-(void)reloadVisibleRows {
/*	Reloads visible rows in the current section (to ensure correct labels and indicators
	in case there are re-used cells. 
	OBS! Assumes normal mode. */
	
	if (self.mode == FCGraphMenuModeNormal) {
		
		NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visibleRows) {
			
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			
			NSDictionary *graphSet = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
			FCCategory *category = [FCCategory categoryWithCID:[graphSet objectForKey:@"Key"]];
			cell.textLabel.text = category.name;
			cell.imageView.image = [UIImage imageNamed:category.iconName];
			
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
	}
}

#pragma mark Orientation

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark FCGraphHandleViewDelegate

-(void)handleDidAddOffset:(CGFloat)addend withAnimation:(BOOL)animated {
	
	CGRect newViewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + addend, self.view.frame.size.width, self.view.frame.size.height);

	if (animated) {
		
		[UIView animateWithDuration:kGraphHandleLockDuration 
						 animations:^ { self.view.frame = newViewFrame; } ];
		
	} else {
		
		self.view.frame = newViewFrame;
	}
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	if (self.sections != nil)
		[self.sections release];
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *defaultGraphs = [defaults objectForKey:FCDefaultGraphs];
	
	if (defaultGraphs != nil) {
		
		NSRange range = NSMakeRange(0, [defaultGraphs count]);
		NSMutableArray *section = [[NSMutableArray alloc] initWithArray:[defaultGraphs subarrayWithRange:range]];
		[newSections addObject:section];
		[section release];
	}
	
	self.sections = newSections;
	[newSections release];
	
	if (self.selectedIndexPaths == nil) {
		
		NSMutableArray *newSelectedIndexPaths = [[NSMutableArray alloc] init];
		self.selectedIndexPaths = newSelectedIndexPaths;
		[newSelectedIndexPaths release];
	}
	
	if (self.storedSections == nil) {
	
		NSMutableArray *newStoredSections = [[NSMutableArray alloc] init];
		self.storedSections = newStoredSections;
		[newStoredSections release];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// variables
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	if (self.mode == FCGraphMenuModeNormal) {
		
		NSDictionary *graphSet = [[self.sections objectAtIndex:section] objectAtIndex:row];
		FCCategory *category = [FCCategory categoryWithCID:[graphSet objectForKey:@"Key"]];
		cell.textLabel.text = category.name;
		cell.imageView.image = [UIImage imageNamed:category.iconName];
		
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
	} else if (self.mode == FCGraphMenuModeGeneralOptions) {
	
		NSDictionary *item = [[self.sections objectAtIndex:section] objectAtIndex:row];
		cell.textLabel.text = [item objectForKey:@"Title"];
		
		NSString *defaultKey = [item objectForKey:@"DefaultKey"];
		if (defaultKey == FCDefaultGraphSettingDateLevel) {
			
			UISegmentedControl *newSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Hours", @"Days", @"Months", nil]];
			newSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 220.0f, 27.0f);
			newSegmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
			
			[newSegmentedControl addTarget:self action:@selector(onSegmentControlValueChanged) forControlEvents:UIControlEventValueChanged];
			
			cell.accessoryView = newSegmentedControl;
			[newSegmentedControl release];
			
		} else {
		
			UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 27.0f)];
			newSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:[item objectForKey:@"DefaultKey"]];
			
			[newSwitch addTarget:self action:@selector(onSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
			
			cell.accessoryView = newSwitch;
			[newSwitch release];
		}
		
		cell.imageView.image = nil;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	} else if (self.mode == FCGraphMenuModeGraphOptions) {
	
		NSDictionary *item = [[self.sections objectAtIndex:section] objectAtIndex:row];
		cell.textLabel.text = [item objectForKey:@"Title"];
		
		cell.accessoryView = [item objectForKey:@"ControlObject"];
		
		cell.imageView.image = nil;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	} else if (self.mode == FCGraphMenuModeSelect) {
		
		NSDictionary *graphSet = [[self.sections objectAtIndex:section] objectAtIndex:row];
		FCCategory *category = [FCCategory categoryWithCID:[graphSet objectForKey:@"Key"]];
		cell.textLabel.text = category.name;
		cell.imageView.image = [UIImage imageNamed:category.iconName];
	
		if ([self.selectedIndexPaths indexOfObjectIdenticalTo:indexPath] != NSNotFound)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		else
			cell.accessoryType = UITableViewCellAccessoryNone;
		
		cell.accessoryView = nil;
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (self.mode == FCGraphMenuModeSelect) {
	
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		
		if (cell.accessoryType == UITableViewCellAccessoryNone) {
			
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			
			[self.selectedIndexPaths addObject:indexPath];
			
		} else {
			
			cell.accessoryType = UITableViewCellAccessoryNone;
			
			NSInteger index = [self.selectedIndexPaths indexOfObjectIdenticalTo:indexPath];
			[self.selectedIndexPaths removeObjectAtIndex:index];
		}
		
		// mark pending changes
		self.pendingChanges = YES;
	
	} else if (self.mode == FCGraphMenuModeNormal) {
		
		[self.selectedIndexPaths addObject:indexPath];
		[self loadGraphOptionsMode];
	}
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)theTableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

	return YES;
}

- (void)tableView:(UITableView *)theTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	[[self.sections objectAtIndex:fromIndexPath.section] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	
	self.pendingChanges = YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)theTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)theTableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return YES;
}

#pragma mark Notifications

-(void)onSwitchValueChanged {
	
	// mark pending changes
	self.pendingChanges = YES;
}

-(void)onSegmentControlValueChanged {
	
	// mark pending changes
	self.pendingChanges = YES;
}

#pragma mark Custom

-(void)saveDefaultState {
/*	Saves the current section with graph sets as new user default graph sets array.
	OBS! Assumes that the current section contains graph sets and not anything else,
	which is why it checks that we are in normal mode. */
	
	if (self.mode == FCGraphMenuModeNormal) {
	
		NSMutableArray *section = [self.sections objectAtIndex:0];
		
		NSRange range = NSMakeRange(0, [section count]);
		NSArray *newDefaultGraphSets = [[NSArray alloc] initWithArray:[section subarrayWithRange:range]];
		
		[[NSUserDefaults standardUserDefaults] setObject:newDefaultGraphSets forKey:FCDefaultGraphs];
		
		[newDefaultGraphSets release];
	}
}

-(void)loadNormalMode {
/*	Loads the basic setup for normal mode, i.e. sets correct mode and UI elements. */
	
	// change mode
	
	self.mode = FCGraphMenuModeNormal;
	
	// change buttons
	
	[UIView	animateWithDuration:kViewDisappearDuration 
					 animations:^ { [self.view addSubview:self.selectButton]; self.selectButton.alpha = 1.0f; [self.view addSubview:reorderButton]; self.reorderButton.alpha = 1.0f; [self.view addSubview:self.optionsButton]; self.optionsButton.alpha = 1.0f; self.doneButton.alpha = 0.0f; } 
					 completion:^ (BOOL finished) { [self.doneButton removeFromSuperview]; self.doneButton = nil; } ];
}

-(void)loadSelectionMode {
/*	Sets up UI elements and table view for selecting what categories are to be graphed. */
	
	/*	OBS!
		The algorithms here are quite inefficient and the functions also buggy at the moment. Needs to be worked a bit...
	 
		/Anders
	 */
	
	// change mode
	
	self.mode = FCGraphMenuModeSelect;
	
	// change buttons
	
	[self loadDoneButtonForCurrentMode];
	
	[UIView	animateWithDuration:kViewDisappearDuration 
					 animations:^ { self.selectButton.alpha = 0.0f; self.reorderButton.alpha = 0.0f; self.optionsButton.alpha = 0.0f; [self.view addSubview:self.doneButton]; self.doneButton.alpha = 1.0f; } 
					 completion:^ (BOOL finished) { [self.selectButton removeFromSuperview]; [self.reorderButton removeFromSuperview]; [self.optionsButton removeFromSuperview]; } ];
	
	// load the cid for all categories from database
	
	NSArray *allCategories = [FCCategory allCategories];
	
	// * Create a new sections array and also find the index paths for already
	//	 existing graph sets and new graph sets respectively. The index paths
	//   are added to selected index paths and the mutable insert index paths
	//   arrays respectively.
	
	NSMutableArray *oldSection = [self.sections objectAtIndex:0]; 
	[self.storedSections addObject:oldSection];
	
	NSMutableArray *newSection = [[NSMutableArray alloc] init];
	
	NSMutableArray *mutableInsertIndexPaths = [[NSMutableArray alloc] init];
	
	int i = 0;
	for (FCCategory *category in allCategories) {
	
		// create the new graph set and add it to the new section

		NSDictionary *newGraphSet = [category generateDefaultGraphSet];
		[newSection addObject:newGraphSet];
		
		// create the index path for this graph set in the new section
		
		NSUInteger arrayLength = 2;
		NSUInteger integerArray[] = {0, i};
		NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:integerArray length:arrayLength];
		
		// check if the key of the new graph set is already present in the old section
		
		NSString *newKey = [newGraphSet objectForKey:@"Key"];
		
		BOOL exists = NO;
		for (NSDictionary *graphSet in oldSection) {
			
			NSString *oldKey = [graphSet objectForKey:@"Key"];
			if ([oldKey isEqualToString:newKey]) {
				
				// flag its existance and make sure graph set carries over to new section
				exists = YES;
				[newSection replaceObjectAtIndex:indexPath.row withObject:graphSet];
			}
		}
		
		if (exists)
			[self.selectedIndexPaths addObject:indexPath]; // add to select paths
			
		else
			[mutableInsertIndexPaths addObject:indexPath]; // add to insert paths
		
		// iterate
		i++;
	}
	
	// update table with new sections
	
	[self.sections replaceObjectAtIndex:0 withObject:newSection];
		
	[newSection release];
	
	NSRange range = NSMakeRange(0, [mutableInsertIndexPaths count]);
	NSArray *insertIndexPaths = [[NSArray alloc] initWithArray:[mutableInsertIndexPaths subarrayWithRange:range]];
	[mutableInsertIndexPaths release];
	
	[self.tableView beginUpdates];
	
	[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
	
	[self.tableView endUpdates];
	
	[insertIndexPaths release];
	
	// reload the already selected cells to ensure the labels are not
	// resused and to add checkmarks to them
	
	range = NSMakeRange(0, [self.selectedIndexPaths count]);
	NSArray *updateIndexPaths = [[NSArray alloc] initWithArray:[self.selectedIndexPaths subarrayWithRange:range]];
	
	for (NSIndexPath *indexPath in updateIndexPaths) {
	
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		
		NSDictionary *graphSet = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		FCCategory *category = [FCCategory categoryWithCID:[graphSet objectForKey:@"Key"]];
		cell.textLabel.text = category.name;
		cell.imageView.image = [UIImage imageNamed:category.iconName];
		
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[updateIndexPaths release];
}

-(void)unloadSelectionMode {
/*	Updates the user default graphs according to what user has selected in the table view
	and restores UI elements and table view to normal mode. */
	
	/*	OBS!
		The algorithms here are quite inefficient and the functions also buggy at the moment. Needs to be worked a bit...
	 
		/Anders
	*/
	
	// load normal mode
	[self loadNormalMode];
	
	// remove the cells which are not selected and also remove checkmark on the ones
	// that are
	
	NSMutableArray *newSection = [[NSMutableArray alloc] init];
	NSMutableArray *mutableDeleteIndexPaths = [[NSMutableArray alloc] init];
	
	int i = 0;
	for (NSDictionary *graphSet in [self.sections objectAtIndex:0]) {
		
		NSUInteger arrayLength = 2;
		NSUInteger integerArray[] = {0, i};
		NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:integerArray length:arrayLength];
		
		if ([self.selectedIndexPaths indexOfObjectIdenticalTo:indexPath] == NSNotFound) {
			
			[mutableDeleteIndexPaths addObject:indexPath]; // add to cells which are to be deleted
			
		} else {
			
			[newSection addObject:graphSet]; // add to new section
		}
			 
		i++;
	}
	
	// if there are pending changes, use the new section
	if (self.pendingChanges)
		[self.sections replaceObjectAtIndex:0 withObject:newSection];
	
	// if not, simply reuse the old one (preserves ordering)
	else
		[self.sections replaceObjectAtIndex:0 withObject:[self.storedSections objectAtIndex:0]];
	
	[newSection release];
	
	NSRange range = NSMakeRange(0, [mutableDeleteIndexPaths count]);
	NSArray *deleteIndexPaths = [[NSArray alloc] initWithArray:[mutableDeleteIndexPaths subarrayWithRange:range]];
	
	[mutableDeleteIndexPaths release];
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
	
	[self.tableView endUpdates];
	
	[deleteIndexPaths release];
	
	// reload visible rows the new section to ensure correct labels and indicators
	[self reloadVisibleRows];
	
	// remove selected index paths and stored sections
	[self.selectedIndexPaths removeAllObjects];
	[self.storedSections removeAllObjects];
	
	// save default state
	if (self.pendingChanges) {
		
		[self saveDefaultState];
		
		// make notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphSetsChanged object:self];
		
		self.pendingChanges = NO;
	}
}

-(void)loadGraphOptionsMode {
/*	Sets up UI elements and table view to display options for a selected graph set. */
	
	// change mode
	
	self.mode = FCGraphMenuModeGraphOptions;
	
	// change buttons
	
	[self loadDoneButtonForCurrentMode];
	
	[UIView	animateWithDuration:kViewDisappearDuration 
					 animations:^ { self.selectButton.alpha = 0.0f; self.reorderButton.alpha = 0.0f; self.optionsButton.alpha = 0.0f; [self.view addSubview:self.doneButton]; self.doneButton.alpha = 1.0f; } 
					 completion:^ (BOOL finished) { [self.selectButton removeFromSuperview]; [self.reorderButton removeFromSuperview]; [self.optionsButton removeFromSuperview]; } ];
	
	// * create the graph set options section
	
	// variables
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"GraphSetKey", @"ControlObject", nil];
	NSArray *objects;
	
	NSString *graphSetKey;
	
	UISwitch *newSwitch;
	
	// entry view mode
	
	NSIndexPath *selectedIndexPath = [self.selectedIndexPaths objectAtIndex:0];
	NSDictionary *selectedGraphSet = [[self.sections objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
	
	graphSetKey = @"EntryViewMode";
	
	UISegmentedControl *newSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Dots", @"Bars", @"None", nil]];
	newSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 220.0f, 27.0f);
	
	NSInteger index = [[selectedGraphSet objectForKey:graphSetKey] integerValue];
	newSegmentedControl.selectedSegmentIndex = index; // set index
	
	if (index > 2)
		newSegmentedControl.enabled = NO; // disable	
	
	[newSegmentedControl addTarget:self action:@selector(onSegmentControlValueChanged) forControlEvents:UIControlEventValueChanged];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemEntryViewMode, graphSetKey, newSegmentedControl, nil];
	NSDictionary *entryViewModePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	[newSegmentedControl release];
	
	// draw lines
	
	graphSetKey = @"DrawLines";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawLines, graphSetKey, newSwitch, nil];
	NSDictionary *linesPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw average
	
	graphSetKey = @"DrawAverage";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawAverage, graphSetKey, newSwitch, nil];
	NSDictionary *averagePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw median
	
	graphSetKey = @"DrawMedian";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawMedian, graphSetKey, newSwitch, nil];
	NSDictionary *medianPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw IQR
	
	graphSetKey = @"DrawIQR";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawIQR, graphSetKey, newSwitch, nil];
	NSDictionary *IQRPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw references
	
	graphSetKey = @"DrawReferences";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawReferences, graphSetKey, newSwitch, nil];
	NSDictionary *referencesPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw x scale
	
	graphSetKey = @"DrawXScale";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawXScale, graphSetKey, newSwitch, nil];
	NSDictionary *xAxisPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw axes
	
	graphSetKey = @"DrawAxes";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawAxes, graphSetKey, newSwitch, nil];
	NSDictionary *axesPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// draw grid
	
	graphSetKey = @"DrawGrid";
	newSwitch = [self switchForGraphSetKey:graphSetKey];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDrawGrid, graphSetKey, newSwitch, nil];
	NSDictionary *gridPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	[keys release];
	
	NSArray *graphSetOptionsSection = [[NSArray alloc] initWithObjects:entryViewModePair, linesPair, averagePair, medianPair, IQRPair, referencesPair, xAxisPair, axesPair, gridPair, nil];
	
	[entryViewModePair release];
	[gridPair release];
	[axesPair release];
	[xAxisPair release];
	[linesPair release];
	[averagePair release];
	[medianPair release];
	[IQRPair release];
	[referencesPair release];
	
	// replace the current section with the new one
	
	[self.storedSections addObject:[self.sections objectAtIndex:0]];
	[self.sections replaceObjectAtIndex:0 withObject:graphSetOptionsSection];
	
	[graphSetOptionsSection release];
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
	
	[self.tableView endUpdates];
}

-(UISwitch *)switchForGraphSetKey:(NSString *)theGraphSetKey {
/*	Returns a switch set to the correct mode for the selected graph set.
	OBS! Assumes FCGraphMenuModeGraphOptions but original sections. */
	
	if (self.mode == FCGraphMenuModeGraphOptions) {
	
		// get the selected graph set
		
		NSIndexPath *selectedIndexPath = [self.selectedIndexPaths objectAtIndex:0];
		NSDictionary *selectedGraphSet = [[self.sections objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
		
		// create a new switch set to correct mode
		
		UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 27.0f)];
		newSwitch.on = [[selectedGraphSet objectForKey:theGraphSetKey] boolValue];
		
		[newSwitch addTarget:self action:@selector(onSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
		
		// autorelease and return
		
		[newSwitch autorelease];
		
		return newSwitch;
	}
	
	return nil;
}

-(void)unloadGraphOptionsMode {
	
	if (self.pendingChanges) {
	
		// * Create a new graph set and replace the one in the stored section
		
		// get the preferences
		
		NSMutableDictionary *preferences = [[NSMutableDictionary alloc] init];
	
		NSMutableArray *section = [self.sections objectAtIndex:0];
		for (NSDictionary *graphOption in section) {
		
			NSString *graphSetKey = [graphOption objectForKey:@"GraphSetKey"];
			
			if ([graphSetKey isEqualToString:@"EntryViewMode"]) {
			
				UISegmentedControl *aSegmentedControl = [graphOption objectForKey:@"ControlObject"];
				
				// TMP BUGFIX: until a better system for selecting entry view mode is devised,
				// there is a bug where icon mode gets ignored. This fixes it temporarily, but
				// is ugly...
				NSInteger selectedSegment = aSegmentedControl.selectedSegmentIndex == -1 ? FCGraphEntryViewModeIcon : aSegmentedControl.selectedSegmentIndex;
				
				NSNumber *number = [[NSNumber alloc] initWithInteger:selectedSegment];
				[preferences setObject:number forKey:graphSetKey];
				[number release];
				
			} else {
				
				UISwitch *aSwitch = [graphOption objectForKey:@"ControlObject"];
				NSNumber *number = [[NSNumber alloc] initWithBool:aSwitch.on];
				[preferences setObject:number forKey:graphSetKey];
				[number release];
			}
		}
		
		// get the old graph set
		
		NSIndexPath *selectedIndexPath = [self.selectedIndexPaths objectAtIndex:0];
		NSDictionary *oldGraphSet = [[self.storedSections objectAtIndex:selectedIndexPath.section] objectAtIndex:selectedIndexPath.row];
		
		// compose new graph set
		
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
							[oldGraphSet objectForKey:@"Key"],
							[preferences objectForKey:@"DrawGrid"],
							[preferences objectForKey:@"DrawAxes"],
							[preferences objectForKey:@"DrawXScale"],
							[preferences objectForKey:@"DrawLines"],
							[preferences objectForKey:@"DrawAverage"],
							[preferences objectForKey:@"DrawMedian"],
							[preferences objectForKey:@"DrawIQR"],
							[preferences objectForKey:@"DrawReferences"],
							[preferences objectForKey:@"EntryViewMode"],
							nil];
		
		NSDictionary *newGraphSet = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		
		[keys release];
		[objects release];
		
		[preferences release];
		
		// replace old graph set in the stored section
		
		[[self.storedSections objectAtIndex:selectedIndexPath.section] replaceObjectAtIndex:selectedIndexPath.row withObject:newGraphSet];
		
		[newGraphSet release];
		
		self.pendingChanges = NO;
	}
	
	// load normal mode
	
	[self loadNormalMode];
	
	// replace the current section with the one stored
	
	[self.sections replaceObjectAtIndex:0 withObject:[self.storedSections objectAtIndex:0]];
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
	
	[self.tableView endUpdates];
	
	// remove selected index path, stored sections, and graph preferences
	
	[self.selectedIndexPaths removeAllObjects];
	[self.storedSections removeAllObjects];
	
	// update the user defaults and make notification
	
	[self saveDefaultState];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphPreferencesChanged object:self];
}

-(void)loadGeneralOptionsMode {
/*	Sets up UI elements and table view to display general options */
	
	// change mode
	
	self.mode = FCGraphMenuModeGeneralOptions;
	
	// change buttons
	
	[self loadDoneButtonForCurrentMode];
	
	[UIView	animateWithDuration:kViewDisappearDuration 
					 animations:^ { self.selectButton.alpha = 0.0f; self.reorderButton.alpha = 0.0f; self.optionsButton.alpha = 0.0f; [self.view addSubview:self.doneButton]; self.doneButton.alpha = 1.0f; } 
					 completion:^ (BOOL finished) { [self.selectButton removeFromSuperview]; [self.reorderButton removeFromSuperview]; [self.optionsButton removeFromSuperview]; } ];
	
	// create the general options section
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"DefaultKey", nil];
	NSArray *objects;
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemDateLevel, FCDefaultGraphSettingDateLevel, nil];
	NSDictionary *levelPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemConvertLog, FCDefaultConvertLog, nil];
	NSDictionary *convertPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemScrollRelatives, FCDefaultGraphSettingScrollRelatives, nil];
	NSDictionary *scrollPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemLabelsInGraph, FCDefaultGraphSettingLabelsInGraph, nil];
	NSDictionary *labelsPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	[keys release];
	
	NSArray *generalOptionsSection = [[NSArray alloc] initWithObjects:levelPair, convertPair, scrollPair, labelsPair, nil];
	
	[levelPair release];
	[convertPair release];
	[scrollPair release];
	[labelsPair release];
	
	// replace the current section with the new one
	
	[self.storedSections addObject:[self.sections objectAtIndex:0]];
	[self.sections replaceObjectAtIndex:0 withObject:generalOptionsSection];
	
	[generalOptionsSection release];
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
	
	[self.tableView endUpdates];
}

-(void)unloadGeneralOptionsMode {
	
	if (self.pendingChanges) {
		
		// update the preferences
		
		BOOL needsReload = NO;
		
		NSMutableArray *section = [self.sections objectAtIndex:0];
		int i = 0;
		for (NSDictionary *pair in section) {
			
			// get the cell and extract it's asseccory view
			
			NSUInteger arrayLength = 2;
			NSUInteger integerArray[] = {0, i};
			NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:integerArray length:arrayLength];
			
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
			
			// update the correct user default
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			
			NSString *defaultKey = [pair objectForKey:@"DefaultKey"];
			if (defaultKey == FCDefaultGraphSettingDateLevel) {
				
				UISegmentedControl *segmentedControl = (UISegmentedControl *)cell.accessoryView;
				
				// determine if the graphs need to be reloaded
				NSInteger oldSetting = [defaults integerForKey:defaultKey];
				if (oldSetting != segmentedControl.selectedSegmentIndex)
					needsReload = YES;
				
				[defaults setInteger:segmentedControl.selectedSegmentIndex forKey:defaultKey];
				
			} else {
				
				UISwitch *switchView = (UISwitch *)cell.accessoryView;
				[defaults setBool:switchView.on forKey:defaultKey];
			}
			
			// iterate
			
			i++;
		}
		
		if (needsReload)
			[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphSetsChanged object:self];
		
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphPreferencesChanged object:self];
	}
	
	// load normal mode
	
	[self loadNormalMode];
	
	// replace the current section with the one stored
	
	[self.sections replaceObjectAtIndex:0 withObject:[self.storedSections objectAtIndex:0]];
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
	
	[self.tableView endUpdates];
	
	// remove selected index path and stored sections
	
	[self.selectedIndexPaths removeAllObjects];
	[self.storedSections removeAllObjects];
}

-(void)loadReorderMode {
	
	// change mode
	
	self.mode = FCGraphMenuModeReorder;
	
	// change buttons
	
	[self loadDoneButtonForCurrentMode];
	
	[UIView	animateWithDuration:kViewDisappearDuration 
					 animations:^ { self.selectButton.alpha = 0.0f; self.reorderButton.alpha = 0.0f; self.optionsButton.alpha = 0.0f; [self.view addSubview:self.doneButton]; self.doneButton.alpha = 1.0f; } 
					 completion:^ (BOOL finished) { [self.selectButton removeFromSuperview]; [self.reorderButton removeFromSuperview]; [self.optionsButton removeFromSuperview]; } ];
	
	// go to editing mode
	
	[self.tableView setEditing:YES animated:YES];
}

-(void)unloadReorderMode {
	
	// load normal mode
	[self loadNormalMode];
	
	// exit editing mode
	[self.tableView setEditing:NO animated:YES];
	
	if (self.pendingChanges) {
		
		// save default state
		[self saveDefaultState];
	
		// make notification
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphSetsChanged object:self];
		
		// reload visible rows the new section to ensure correct labels and indicators
		[self reloadVisibleRows];
		
		self.pendingChanges = NO;
	}
}

@end
