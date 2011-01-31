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
//  FCAppSettingsViewMessagesViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 31/01/2011.
//

#import "FCAppSettingsViewMessagesViewController.h"


@implementation FCAppSettingsViewMessagesViewController

@synthesize tableView, sections, sectionTitles;

#pragma mark Init

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[tableView release];
	[sections release];
	[sectionTitles release];
	
    [super dealloc];
}

#pragma mark Memory warnings

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// * Title
	self.title = kSettingsItemViewMessages;
	
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

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	if (self.sections != nil)
		self.sections = nil;
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	
	NSArray *section;
	
	// INFO
	
	[newSectionTitles addObject:@"Info"];
	
	section = [[NSArray alloc] initWithObjects:@"About TiY", @"About the project", nil];
	[newSections addObject:section];
	[section release];
	
	// HELP MESSAGES
	
	[newSectionTitles addObject:@"Help"];
	
	section = [[NSArray alloc] initWithObjects:@"Profile", @"Glucose", @"Tags", @"Record", @"Log", @"Graph", nil];
	[newSections addObject:section];
	[section release];
	
	self.sections = newSections;
	[newSections release];
	
	self.sectionTitles = newSectionTitles;
	[newSectionTitles release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [self.sectionTitles objectAtIndex:section];
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
	
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	NSString *resourceName;
	
	if (section == 0) {
	
		resourceName = row == 0 ? @"Introduction" : @"ProjectInfo";
		
	} else {
		
		resourceName = [[self.sections objectAtIndex:section] objectAtIndex:row];
	}
	
	[self showAlertUsingResourceWithName:resourceName];
	
	// Deselect the row
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
