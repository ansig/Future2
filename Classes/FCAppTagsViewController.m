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
//  FCAppTagsViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppTagsViewController.h"


@implementation FCAppTagsViewController

@synthesize section, tableView, deleteIndexPath;

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
	
	[section release];
	[tableView release];
	[deleteIndexPath release];
	
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
	
	// * Right button
	
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Create new tag" style:UIBarButtonItemStyleDone target:self action:@selector(loadNewCategoryViewController)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Table view
	
	[self loadRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadNewCategoryViewController {
	
	FCAppCategoryViewController *newCategoryViewController = [[FCAppCategoryViewController alloc] init];
	newCategoryViewController.shouldAnimateContent = YES;
	newCategoryViewController.title = @"New tag";
	
	[self presentOverlayViewController:newCategoryViewController];
	
	[newCategoryViewController release];
}

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark Events

-(void)editButtonPressed:(UIButton *)theEditButton {
	
	FCCategory *theCategory = [self.section objectAtIndex:theEditButton.tag];

	FCAppCategoryViewController *newCategoryViewController = [[FCAppCategoryViewController alloc] initWithCategory:theCategory];
	newCategoryViewController.shouldAnimateContent = YES;
	
	newCategoryViewController.title = theCategory.name;
	
	[self presentOverlayViewController:newCategoryViewController];
	
	[newCategoryViewController release];
}

#pragma mark FCPlainTableSourceDelegate

-(void)loadRows {
	
	if (self.section != nil)
		self.section = nil;
	
	NSArray *tags = [FCCategory allCategoriesWithOwner:@"system_0_5"];
	
	NSMutableArray *newSection = [[NSMutableArray alloc] initWithArray:tags];
	
	self.section = newSection;
	
	[newSection release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.section count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	FCCategory *category = [self.section objectAtIndex:indexPath.row];
	
	cell.textLabel.text = category.name;
	
	if ([category.datatype isEqualToString:@"integer"] || [category.datatype isEqualToString:@"decimal"]) {
		
		if (category.uid != nil)
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Countable, %@", category.unit.name];
		
		else
			cell.detailTextLabel.text = @"Countable";
	
	} else {
		
		cell.detailTextLabel.text = nil;
	}
	
	cell.imageView.image = [UIImage imageNamed:category.icon];
	
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
	editButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
	editButton.tag = indexPath.row;
	
	[editButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
	[editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	cell.accessoryView = editButton;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// finally deselect the row
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	self.deleteIndexPath = indexPath;
	
	UIActionSheet *deleteMenu = [[UIActionSheet alloc] initWithTitle:@"Do you really want to delete this tag?" delegate:self cancelButtonTitle:@"No, do not delete!" destructiveButtonTitle:@"Yes, delete!" otherButtonTitles:nil];
	deleteMenu.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];	
	[deleteMenu showFromRect:cell.frame inView:self.tableView animated:YES];
	
	[deleteMenu release];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 0) {
	
		FCCategory *category = [[self.section objectAtIndex:self.deleteIndexPath.row] retain];
		
		[self.section removeObjectAtIndex:self.deleteIndexPath.row];
	
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[category delete];
		
		[self purgeDefaultGraphSetsWithCID:category.cid];
		
		[category release];
	}
}

#pragma mark FCCategoryList

-(void)onCategoryCreatedNotification {
	
	[self loadRows];
	[self.tableView reloadData];
}

-(void)onCategoryUpdatedNotification {
	
	[self loadRows];
	[self.tableView reloadData];
}

-(void)onCategoryDeletedNotification {
	
}

-(void)onCategoryObjectUpdatedNotification {
	
}

#pragma mark Custom

-(void)purgeDefaultGraphSetsWithCID:(NSString *)theCID; {
	
	[theCID retain];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *defaultGraphs = [defaults objectForKey:FCDefaultGraphs];
	if (defaultGraphs != nil) {
	
		NSDictionary *graphSetToRemove = nil;
		for (NSDictionary *graphSet in defaultGraphs) {
			
			if ([theCID isEqualToString:[graphSet objectForKey:@"Key"]])
				graphSetToRemove = graphSet;
		}
		
		if (graphSetToRemove != nil) {
			
			NSMutableArray *mutableNewDefaultGraphs = [[NSMutableArray alloc] initWithArray:defaultGraphs];
			[mutableNewDefaultGraphs removeObject:graphSetToRemove];
			
			NSRange range = NSMakeRange(0, [mutableNewDefaultGraphs count]);
			NSArray *newDefaultGraphs = [[NSArray alloc] initWithArray:[mutableNewDefaultGraphs subarrayWithRange:range]];
			[mutableNewDefaultGraphs release];
			
			[defaults setObject:newDefaultGraphs forKey:FCDefaultGraphs];
			
			[newDefaultGraphs release];
		}
	}
	
	[theCID release];
}

@end
