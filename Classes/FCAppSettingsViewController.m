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
//  FCAppSettingsViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 10/08/2010.
//

#import "FCAppSettingsViewController.h"


@implementation FCAppSettingsViewController

@synthesize tableView;
@synthesize sections, sectionTitles;
@synthesize convertLogSwitch;
@synthesize webView, borderView, closeButton, backButton;

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
	
	[tableView release];
	
	[sections release];
	[sectionTitles release];
	
	[convertLogSwitch release];
		
	[webView release];
	[borderView release];
	[closeButton release];
	[backButton release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppSettingsViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// * Back button
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	// * Table view
	
	[self loadSectionsAndRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f) style:UITableViewStyleGrouped];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	newTableView.backgroundColor = [UIColor clearColor];
	
	// * Footer
	
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 90.0f)];
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoDictionary = [mainBundle infoDictionary];
	
	// product info
	UILabel *trademarklabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 16.0f)];
	trademarklabel.backgroundColor = [UIColor clearColor];
	trademarklabel.font = [UIFont boldSystemFontOfSize:16.0f];
	trademarklabel.textAlignment = UITextAlignmentCenter;
	trademarklabel.textColor = [UIColor grayColor];
	trademarklabel.text = [infoDictionary objectForKey:@"Product information"];
	[footer addSubview:trademarklabel];
	[trademarklabel release];
	
	// project info
	UILabel *projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 16.0f)];
	projectLabel.backgroundColor = [UIColor clearColor];
	projectLabel.font = [UIFont systemFontOfSize:16.0f];
	projectLabel.textAlignment = UITextAlignmentCenter;
	projectLabel.textColor = [UIColor grayColor];
	projectLabel.text = [infoDictionary objectForKey:@"Project information"];
	[footer addSubview:projectLabel];
	[projectLabel release];
	
	// license info
	UILabel *licenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 60.0f, 320.0f, 16.0f)];
	licenseLabel.backgroundColor = [UIColor clearColor];
	licenseLabel.font = [UIFont systemFontOfSize:16.0f];
	licenseLabel.textAlignment = UITextAlignmentCenter;
	licenseLabel.textColor = [UIColor grayColor];
	licenseLabel.text = [infoDictionary objectForKey:@"License information"];
	[footer addSubview:licenseLabel];
	[licenseLabel release];
	
	/*
	
	// Project info
	UIButton *projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
	projectButton.frame = CGRectMake(0.0f, 46.0f, 320.0f, 20.0f);
	projectButton.backgroundColor = [UIColor clearColor];
	
	[projectButton setTitle:[infoDictionary objectForKey:@"Project information"] forState:UIControlStateNormal];
	[projectButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	
	projectButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	projectButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[projectButton addTarget:self action:@selector(displayProjectInformation) forControlEvents:UIControlEventTouchUpInside];
	
	[footer addSubview:projectButton];
	
	// License info
	UIButton *licenseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	licenseButton.frame = CGRectMake(0.0f, 76.0f, 320.0f, 20.0f);
	
	[licenseButton setTitle:[infoDictionary objectForKey:@"License information"] forState:UIControlStateNormal];
	[licenseButton setTitleColor:kButtonTitleColor forState:UIControlStateNormal];
	
	licenseButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
	licenseButton.titleLabel.textAlignment = UITextAlignmentCenter;
	
	[licenseButton addTarget:self action:@selector(displayLicenseInformation) forControlEvents:UIControlEventTouchUpInside];
	
	[footer addSubview:licenseButton];
	 
	*/
	
	newTableView.tableFooterView = footer;
	[footer release];
	
	self.tableView = newTableView;
	[self.view addSubview:newTableView];
	
	[newTableView release];
	
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

#pragma mark Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Custom

-(void)onSwitchValueChange {
/*	This is called whenever one of the switches are turned on or off. For each switch, set the default value. */
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (self.convertLogSwitch != nil) {
	
		[defaults setBool:self.convertLogSwitch.on forKey:FCDefaultConvertLog];
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationConvertLogOrUnitChanged object:self];
	}
}

-(void)dismiss {
	
	NSLog(@"FCAppSettingsViewController || Dismissing settings view controller...");
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)onUserDefaultsUpdate {
	
	[self.tableView reloadData];
}

-(void)loadURL:(NSString *)theURL {
	
	// create the link
	
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@", theURL]];
	
	// open link in Safari browser
	
	[[UIApplication sharedApplication] openURL:url]; 
	
	/*
	 
	 // open link in own webview
	 
	 // create webview and controllers
	 [self displayWebview];
	 
	 // request the appropriate webpage
	 NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	 [self.webView loadRequest:request];
	 [request release];
	 
	 */
	
	[url release];
}

-(void)displayWebview {
	
	// disable table selection and scrolling
	self.tableView.allowsSelection = NO;
	self.tableView.scrollEnabled = NO;
	
	// disable Done button
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	// create the container view, whose purpose is to show a border
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 376.0f)];
	newView.backgroundColor = [UIColor blackColor];
	newView.alpha = 0.0f; // in anticipation of the fade-in animation
	
	self.borderView = newView;
	[self.view addSubview:newView];
	
	[newView release];
	
	// create a web view
	UIWebView *newWebView = [[UIWebView alloc] initWithFrame:CGRectMake(21.0f, 21.0f, 278.0f, 374.0f)];
	newWebView.scalesPageToFit = YES;
	newWebView.alpha = 0.0f; // in anticipation of the fade-in animation
	
	self.webView = newWebView;
	[self.view addSubview:newWebView];
	
	[newWebView release];
	
	// back button
	UIButton *newBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newBackButton.frame = CGRectMake(5.0f, 5.0f, 30.0f, 30.0f);
	
	[newBackButton setImage:[UIImage imageNamed:@"webviewBack.png"] forState:UIControlStateNormal];
	
	[newBackButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	
	self.backButton = newBackButton;
	[self.view addSubview:newBackButton];
	
	// close button
	UIButton *newCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newCloseButton.frame = CGRectMake(285.0f, 5.0f, 30.0f, 30.0f);
	
	[newCloseButton setBackgroundImage:[UIImage imageNamed:@"webviewClose.png"] forState:UIControlStateNormal];
	
	[newCloseButton addTarget:self action:@selector(dismissWebView) forControlEvents:UIControlEventTouchUpInside];
	
	self.closeButton = newCloseButton;
	[self.view addSubview:newCloseButton];
	
	// fade in animation
	
	[UIView beginAnimations:@"PresentWebView" context:NULL];
	[UIView setAnimationDuration:0.5f];
	
	self.borderView.alpha = 1.0f;
	self.webView.alpha = 1.0f;
	
	[UIView commitAnimations];
}

-(void)dismissWebView {
	
	// enable table selection and scrolling
	self.tableView.allowsSelection = YES;
	self.tableView.scrollEnabled = YES;
	
	// enable Done button
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	if (self.webView != nil) {
	
		NSTimeInterval duration = 0.5f;
		[UIView beginAnimations:@"DismissWebView" context:NULL];
		[UIView setAnimationDuration:duration];
		
		self.webView.alpha = 0.0f;
		self.borderView.alpha = 0.0f;
		
		[UIView commitAnimations];
		
		self.borderView = nil;
		[self.borderView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
		
		self.webView = nil;
		[self.webView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
		
		[self.backButton removeFromSuperview];
		self.backButton = nil;
		
		[self.closeButton removeFromSuperview];
		self.closeButton = nil;
	}
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	// * Section titles
	
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	
	[newSectionTitles addObject:@"Units"];
	[newSectionTitles addObject:@"Profile"];
	[newSectionTitles addObject:@"General"];
	[newSectionTitles addObject:@"About"];
	
	self.sectionTitles = newSectionTitles;
	
	[newSectionTitles release];
	
	// * Sections
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"DefaultKey", @"Title", nil];
	NSArray *objects;
	
	// units
	
	objects = [[NSArray alloc] initWithObjects:FCDefaultHeightWeigthSystem, kSettingsItemHeightWeightSystem, nil];
	NSDictionary *heightWeigthPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:FCDefaultConvertLog, kSettingsItemConvertLog, nil];
	NSDictionary *convertLogPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	NSArray *unitsSection = [[NSArray alloc] initWithObjects:heightWeigthPair, convertLogPair, nil];
	[newSections addObject:unitsSection];
	
	[convertLogPair release];
	[heightWeigthPair release];
	
	[unitsSection release];
	
	// profile
	objects = [[NSArray alloc] initWithObjects:FCDefaultAgeDisplay, kSettingsItemAgeDisplay, nil];
	NSDictionary *dateOfBirthPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	NSArray *profileSection = [[NSArray alloc] initWithObjects:kSettingsItemUsernamePassword, kSettingsItemRearrangeProfile, dateOfBirthPair, nil];
	[newSections addObject:profileSection];
	
	[dateOfBirthPair release];
	[profileSection release];
	
	// general
	objects = [[NSArray alloc] initWithObjects:FCDefaultTabBarIndex, kSettingsItemDefaultTab, nil];
	NSDictionary *defaultTabPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	NSArray *generalSection = [[NSArray alloc] initWithObjects:defaultTabPair, nil];
	[newSections addObject:generalSection];
	
	[defaultTabPair release];
	[generalSection release];
	
	// about
	
	[keys release];
	keys = [[NSArray alloc] initWithObjects:@"Title", @"URL", nil];
	
	// getting info from bundle...
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoDictionary = [mainBundle infoDictionary];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemProjectInfo, [infoDictionary objectForKey:@"Project URL"], nil];
	NSDictionary *projectPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemLicenseInfo, [infoDictionary objectForKey:@"License URL"], nil];
	NSDictionary *licensePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	objects = [[NSArray alloc] initWithObjects:kSettingsItemSourceInfo, [infoDictionary objectForKey:@"Source URL"], nil];
	NSDictionary *sourcePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	NSArray *aboutSection = [[NSArray alloc] initWithObjects:projectPair, licensePair, sourcePair, nil];
	
	[newSections addObject:aboutSection];
	
	[aboutSection release];
	
	[projectPair release];
	[licensePair release];
	[sourcePair release];
	
	// set and release
	
	self.sections = newSections;
	
	[newSections release];
	
	[keys release];
}

#pragma mark Table view methods

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
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// variables
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	id object = [[sections objectAtIndex:section] objectAtIndex:row];
	if ([object isKindOfClass:[NSDictionary class]]) {
		
		NSDictionary *item = [object copy];
		cell.textLabel.text = [item objectForKey:@"Title"];
		
		// user defaults settings
		NSString *defaultKey = [item objectForKey:@"DefaultKey"];
		if (defaultKey != nil) {
		
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			if ([defaultKey isEqualToString:FCDefaultHeightWeigthSystem]) {
				
				cell.detailTextLabel.text = FCUnitSystemAsString([defaults integerForKey:defaultKey]);
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.accessoryView = nil;
				
			} else if ([defaultKey isEqualToString:FCDefaultAgeDisplay]) {
				
				cell.detailTextLabel.text = FCDateDisplayAsString([defaults integerForKey:defaultKey]);
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.accessoryView = nil;
				
			}  else if ([defaultKey isEqualToString:FCDefaultTabBarIndex]) {
				
				cell.detailTextLabel.text = FCTabAsString([defaults integerForKey:defaultKey]);
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.accessoryView = nil;
			
			} else if ([defaultKey isEqualToString:FCDefaultConvertLog]) {
			
				UISwitch *newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 27.0f)];
				newSwitch.on = [defaults boolForKey:FCDefaultConvertLog];
				
				[newSwitch addTarget:self action:@selector(onSwitchValueChange) forControlEvents:UIControlEventValueChanged];
				
				self.convertLogSwitch = newSwitch;
				cell.accessoryView = newSwitch;
				
				[newSwitch release];
				
				cell.detailTextLabel.text = nil;
			}
		
		// about links
		} else {
			
			cell.detailTextLabel.text = [item objectForKey:@"URL"];
			cell.accessoryType = UITableViewCellAccessoryNone; // makes sure there is no accesory if this is a re-used cell
			cell.accessoryView = nil;
		}
		
		[item release];
		
	} else {
		
		NSString *string = [object copy];
		
		cell.textLabel.text = string;
		
		[string release];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	id object = [[sections objectAtIndex:section] objectAtIndex:row];
	if ([object isKindOfClass:[NSDictionary class]]) {
		
		NSDictionary *item = [object copy];
		
		// user default settings
		NSString *defaultKey = [item objectForKey:@"DefaultKey"];
		if (defaultKey != nil) {
		
			if ([defaultKey isEqualToString:FCDefaultConvertLog]) {
				
				// do nothing...
				
			} else {
			
				// push selection view controller
				
				FCAppSettingsSelectViewController *selectViewController = [[FCAppSettingsSelectViewController alloc] initWithDefaultItem:item];
				[self.navigationController pushViewController:selectViewController animated:YES];
				[selectViewController release];
			}
			
		} else {
			
			// open link in Safari browser
			[self loadURL:[item objectForKey:@"URL"]];
		}
		
		[item release];
		
	}
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
