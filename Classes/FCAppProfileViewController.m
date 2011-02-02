/*
 
 TiY (tm) - an iPhone app that supports self-management of type 1 diabetes
 Copyright (C) 2010  Interaction Design Centre (University of Limerick, Ireland)
 
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
//  FCAppProfileViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppProfileViewController.h"

@implementation FCAppProfileViewController

@synthesize scrollView; 
@synthesize pageControl;
@synthesize nameLabel;
@synthesize healthInfoTableView, healthInfoTableDataSource;
@synthesize personalInfoTableView, personalInfoTableDataSource;

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
	
	[scrollView release];
	
	[pageControl release];
	
	[nameLabel release];
	
	[healthInfoTableView release];
	[healthInfoTableDataSource release];
	
	[personalInfoTableView release];
	[personalInfoTableDataSource release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppProfileViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f)];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// hide navigation bar
	self.navigationController.navigationBarHidden = YES;
	
	// * Header background
	UIImageView *headerBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	headerBackground.image = [UIImage imageNamed:@"navigationBarBackground.png"];
	
	[self.view addSubview:headerBackground];
	
	[headerBackground release];
	
	// * Settings button
	
	UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	CGRect newButtonFrame = CGRectMake(12.0f, 7.0f, 30.0f, 30.0f);
	settingsButton.frame = newButtonFrame;
	
	[settingsButton setImage:[UIImage imageNamed:@"settingsButton.png"] forState:UIControlStateNormal];
	
	[settingsButton addTarget:self action:@selector(loadSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:settingsButton];
	
	// * Name label
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 12.0f, 320.0f, 20.0f)];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize:18.0f];
	label.backgroundColor = [UIColor clearColor];
	
	self.nameLabel = label;
	[self.view addSubview:label];
	
	[label release];
	
	[self updateNameLabel];
	
	// * Scroll view
	
	UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 367.0f)];
	newScrollView.delegate = self;
	newScrollView.backgroundColor = [UIColor clearColor];
	newScrollView.contentSize = CGSizeMake(640.0f, 367.0f);
	newScrollView.pagingEnabled = YES;
	
	self.scrollView = newScrollView;
	[self.view addSubview:newScrollView];
	
	[newScrollView release];
	
	// * Table views
	
	// health info table
	
	UITableView *newHealthInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
	newHealthInfoTableView.backgroundColor = [UIColor clearColor];
	
	FCProfileHealthInfoDataSource *newHealthInfoTableDataSource = [[FCProfileHealthInfoDataSource alloc] init];
	newHealthInfoTableView.delegate = self;
	newHealthInfoTableView.dataSource = newHealthInfoTableDataSource;
	
	self.healthInfoTableDataSource = newHealthInfoTableDataSource;
	[newHealthInfoTableDataSource release];
	
	self.healthInfoTableView = newHealthInfoTableView;
	[self.scrollView addSubview:newHealthInfoTableView];
	
	[newHealthInfoTableView release];
	
	// personal info table
	
	UITableView *newPersonalTableView = [[UITableView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, 320.0f, 367.0f) style:UITableViewStyleGrouped];
	newPersonalTableView.backgroundColor = [UIColor clearColor];
	
	FCProfilePersonalInfoTableDataSource *newPersonalInfoTableDataSource = [[FCProfilePersonalInfoTableDataSource alloc] init];
	newPersonalTableView.delegate = self;
	newPersonalTableView.dataSource = newPersonalInfoTableDataSource;
	
	self.personalInfoTableDataSource = newPersonalInfoTableDataSource;
	[newPersonalInfoTableDataSource release];
	
	self.personalInfoTableView = newPersonalTableView;
	[self.scrollView addSubview:newPersonalTableView];
	
	[newPersonalTableView release];
	
	// * Page control
	
	UIPageControl *newPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140.0f, 396.0f, 40.0f, 15.0f)];
	newPageControl.backgroundColor = kDarkColor;
	newPageControl.numberOfPages = 2;
	newPageControl.currentPage = 0;
	
	[self.view addSubview:newPageControl];
	self.pageControl = newPageControl;
	
	[newPageControl release];
	
	// * Notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserDefaultsUpdate) name:FCNotificationUserDefaultsUpdated object:nil];
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

-(void)viewDidAppear:(BOOL)animated {
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultShowHelpMessageProfile]) {
	
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:FCDefaultShowHelpMessageProfile];
		[self showAlertUsingResourceWithName:@"Profile"];
	}
	
	// flash the scroll indicator to remind the user that there are two pages
	[self.scrollView flashScrollIndicators];
	
	[super viewWillAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	
	// make sure that the navigation bar is always hidden here
	if (!self.navigationController.navigationBarHidden)
		[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	[super viewWillAppear:animated];
}

-(void)loadSettingsViewController {
	
	NSLog(@"FCAppProfileViewController || Loading settings view controller...");
	
	FCAppSettingsViewController *settingsViewController = [[FCAppSettingsViewController alloc] init];
	settingsViewController.title = @"Settings";
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	navigationController.delegate = self.navigationController.delegate;
	[settingsViewController release];
	
	[navigationController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
}

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Table view

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// get the default item (a dictionary with a title and a default key) to pass on to the input view controller
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSArray *sections;
	if ([theTableView isEqual:healthInfoTableView]) 
		sections = healthInfoTableDataSource.sections;
	else
		sections = personalInfoTableDataSource.sections;
		
	NSDictionary *defaultItem = [[sections objectAtIndex:section] objectAtIndex:row];
	NSArray *defaultItems = [[NSArray alloc] initWithObjects:defaultItem, nil];
	
	// create and present the input view controller
	FCAppProfileInputViewController *inputViewController = [[FCAppProfileInputViewController alloc] initWithDefaultItems:defaultItems];
	
	inputViewController.shouldAnimateContent = YES;
	
	[self presentOverlayViewController:inputViewController];
	
	[inputViewController release];
	[defaultItems release];
	
	// deselect row
	[theTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Scroll view

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView {
	
	// update the page control
	CGPoint offset = self.scrollView.contentOffset;
	if (offset.x > 319)
		self.pageControl.currentPage = 1;
	
	else
		self.pageControl.currentPage = 0;
}

#pragma mark FCProfileDisplay

-(void)onUserDefaultsUpdate {
	
	// update the tables
	[self.personalInfoTableView reloadData];
	[self.healthInfoTableView reloadData];
	
	// update the name label 
	[self updateNameLabel];
}

#pragma mark Custom

-(void)updateNameLabel {
	
	if (self.nameLabel != nil) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSString *firstName = [defaults stringForKey:FCDefaultProfileFirstName];
		NSString *surname = [defaults stringForKey:FCDefaultProfileSurname];
		
		NSString *title = [[NSString alloc] initWithString:@"Your profile"];
		
		NSString *oldTitle;
		
		if (firstName != nil) {
		
			oldTitle = title;
			title = [[NSString alloc] initWithFormat:@"%@", firstName];
			[oldTitle release];
		}
		
		if (firstName == nil && surname != nil) {
			
			oldTitle = title;
			title = [[NSString alloc] initWithFormat:@"%@", surname];
			[oldTitle release];
		
		} else if (firstName != nil && surname != nil) {
			
			oldTitle = title;
			title = [[NSString alloc] initWithFormat:@"%@ %@", oldTitle, surname];
			[oldTitle release];
		}
		
		self.nameLabel.text = title;
		[title release];
	}
}

@end
