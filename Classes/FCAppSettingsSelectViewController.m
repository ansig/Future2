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
//  FCAppSettingsSelectViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 02/09/2010.
//

#import "FCAppSettingsSelectViewController.h"


@implementation FCAppSettingsSelectViewController

@synthesize defaultItem;
@synthesize tableView, sections;

#pragma mark Init

-(id)initWithDefaultItem:(NSDictionary *)theDefaultItem {
	
	if (self = [super init]) {
		
		self.defaultItem = theDefaultItem;
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
	
	[defaultItem release];
	
	[tableView release];
	[sections release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	self.view = view;
	[view release];
	
	// * Title
	self.title = [defaultItem objectForKey:@"Title"];
	
	// * Table view
	[self loadSectionsAndRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	[self.view addSubview:self.tableView];
	
	[newTableView release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void)viewDidDisappear:(BOOL)animated {
	
	// Since the user defaults may have been changed, we also
	// want to synchronise
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
}

- (void)didReceiveMemoryWarning {
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	NSString *defaultKey = [defaultItem objectForKey:@"DefaultKey"];
	
	if (self.sections != nil)
		self.sections = nil;
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	NSArray *section;
	
	// height/weight system
	if (defaultKey == FCDefaultHeightWeigthSystem) {
		
		section = [[NSArray alloc] initWithObjects:FCUnitSystemAsString(FCUnitSystemMetric), FCUnitSystemAsString(FCUnitSystemImperial), FCUnitSystemAsString(FCUnitSystemCustomary), nil];
		
		
	// age display
	} else if (defaultKey == FCDefaultAgeDisplay) {
		
		section = [[NSArray alloc] initWithObjects:FCDateDisplayAsString(FCDateDisplayDate), FCDateDisplayAsString(FCDateDisplayYears), nil];
	
	} else if (defaultKey == FCDefaultTabBarIndex) {
	
		section = [[NSArray alloc] initWithObjects:FCTabAsString(FCTabProfile), FCTabAsString(FCTabGlucose), FCTabAsString(FCTabTags), FCTabAsString(FCTabRecording), FCTabAsString(FCTabLog), nil];
	}
	
	[newSections addObject:section];
	[section release];
	
	self.sections = newSections;
	[newSections release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	cell.textLabel.text = [[sections objectAtIndex:section] objectAtIndex:row];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger current = [defaults integerForKey:[defaultItem objectForKey:@"DefaultKey"]];
	if (current == row)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSInteger row = [indexPath row];

	// Update user defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:row forKey:[defaultItem objectForKey:@"DefaultKey"]];
	
	// Send notification about the update
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationUserDefaultsUpdated object:self];
	
	// Deselect the row
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// Reload table date (after delay, to allow deselection)
	[theTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.40f];
}

@end
