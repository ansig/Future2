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
//  FCAppRootViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 09/08/2010.
//

#import "FCAppRootViewController.h"

#import "FCAppProfileViewController.h"
#import "FCAppGlucoseViewController.h"
#import "FCAppTagsViewController.h"
#import "FCAppRecordingViewController.h"
#import "FCAppLogViewController.h"

@implementation FCAppRootViewController

@synthesize tabBarController;

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
 
	[tabBarController release];
	
	[super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppRootViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// Profile
	FCAppProfileViewController *profileViewController = [[FCAppProfileViewController alloc] init];
	profileViewController.title = @"Profile";
	profileViewController.tabBarItem.image = [UIImage imageNamed:@"profileTabBarIcon.png"];
	
	UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
	profileNavigationController.delegate = self;
	
	[profileViewController release];
	
	// Glucose
	FCAppGlucoseViewController *glucoseViewController = [[FCAppGlucoseViewController alloc] init];
	glucoseViewController.title = @"Glucose";
	glucoseViewController.tabBarItem.image = [UIImage imageNamed:@"glucoseTabBarIcon.png"];
	
	UINavigationController *glucoseNavigationController = [[UINavigationController alloc] initWithRootViewController:glucoseViewController];
	glucoseNavigationController.delegate = self;
	
	[glucoseViewController release];
	
	// Tags
	FCAppTagsViewController *tagsViewController = [[FCAppTagsViewController alloc] init];
	tagsViewController.title = @"Tags";
	tagsViewController.tabBarItem.image = [UIImage imageNamed:@"tagsTabBarIcon.png"];
	
	UINavigationController *tagsNavigationController = [[UINavigationController alloc] initWithRootViewController:tagsViewController];
	tagsNavigationController.delegate = self;
	
	[tagsViewController release];
	
	// Recording
	FCAppRecordingViewController *recordingViewController = [[FCAppRecordingViewController alloc] init];
	recordingViewController.title = @"Recording";
	recordingViewController.tabBarItem.image = [UIImage imageNamed:@"recordingTabBarIcon.png"];
	
	UINavigationController *recordingNavigationController = [[UINavigationController alloc] initWithRootViewController:recordingViewController];
	recordingNavigationController.delegate = self;
	
	[recordingViewController release];
	
	// Log
	FCAppLogViewController *logViewController = [[FCAppLogViewController alloc] init];
	logViewController.title = @"Log";
	logViewController.tabBarItem.image = [UIImage imageNamed:@"logTabBarIcon.png"];
	
	UINavigationController *logNavigationController = [[UINavigationController alloc] initWithRootViewController:logViewController];
	logNavigationController.delegate = self;
	
	[logViewController release];
	
	// Tab bar controller
	UITabBarController *aTabBarController = [[UITabBarController alloc] init];
	
	aTabBarController.viewControllers = [NSArray arrayWithObjects:profileNavigationController, glucoseNavigationController, tagsNavigationController, recordingNavigationController, logNavigationController, nil];
	
	[profileNavigationController release];
	[glucoseNavigationController release];
	[tagsNavigationController release];
	[recordingNavigationController release];
	[logNavigationController release];
	
	// default selected tab
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL showLog = [defaults boolForKey:FCDefaultShowLog];
	if (showLog) {
		
		aTabBarController.selectedIndex = 4;
	
	} else {
	
		NSNumber *defaultIndex = [[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultTabBarIndex];
		aTabBarController.selectedIndex = [defaultIndex intValue];
	}
	
	aTabBarController.delegate = self;
	
	self.tabBarController = aTabBarController;
	[aTabBarController release];
	
	self.view = self.tabBarController.view;
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

#pragma mark Delegate

/* Navigation controller delegate methods */

-(void)navigationController:(UINavigationController *)aNavigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	// * Custom label to use as navigation bar title
	UILabel *newTitleLabel = [[UILabel alloc] init];
	
	newTitleLabel.text = [viewController title];
	
	[newTitleLabel setFont:[UIFont boldSystemFontOfSize:18]];
	[newTitleLabel setTextColor:[UIColor blackColor]];
	[newTitleLabel setBackgroundColor:[UIColor clearColor]];
	
	//[newTitleLabel setShadowColor:[UIColor lightGrayColor]];
	//[newTitleLabel setShadowOffset:CGSizeMake(0.0f, -2.0f)];
	
	[newTitleLabel sizeToFit];
	
	viewController.navigationItem.titleView = newTitleLabel;
	
	[newTitleLabel release];
	
	// * Navigation bar tint color
	viewController.navigationController.navigationBar.tintColor = kTintColor;
	
	// manually make sure that whatever view controller is about to get shown gets a viewWillAppear callback,
	// reasons discussed here: http://discussions.info.apple.com/message.jspa?messageID=7412478
	[viewController viewWillAppear:animated];
	
	// and that the currently visible view controller gets -viewWillDisappear callback
	UIViewController *currentViewController = (UIViewController *)aNavigationController.visibleViewController;
	[currentViewController viewWillDisappear:animated];
}

- (void)navigationController:(UINavigationController *)aNavigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	
	// manually make sure that whatever view controller is about to get shown gets a viewWillAppear callback,
	// reasons discussed here: http://discussions.info.apple.com/message.jspa?messageID=7412478
	[viewController viewDidAppear:animated];
}

/* Tab bar controller delegate methods */

- (void)tabBarController:(UITabBarController *)aTabBarController didSelectViewController:(UIViewController *)viewController {
	
	// manually make sure that whatever view controller is about to get shown gets a viewWillAppear callback,
	// reasons discussed here: http://discussions.info.apple.com/message.jspa?messageID=7412478
	[viewController viewDidAppear:NO];
}

- (BOOL)tabBarController:(UITabBarController *)aTabBarController shouldSelectViewController:(UIViewController *)viewController {

	// manually make sure that the currently selected view controller gets a -viewWillDisappear callback,
	// reasons discussed here: http://discussions.info.apple.com/message.jspa?messageID=7412478
	UIViewController *currentViewController = (UIViewController *)aTabBarController.selectedViewController;
	[currentViewController viewWillDisappear:NO];
	
	return YES;
}

@end
