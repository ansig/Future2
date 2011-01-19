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
//  FCRegistrationViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 10/08/2010.
//

#import "FCRegistrationViewController.h"


@implementation FCRegistrationViewController

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
	
	[super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
	self.view = view;
	[view release];
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

-(void)viewDidAppear:(BOOL)animation {

	[self showWelcomeMessage];
}

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Custom

-(void)showWelcomeMessage {
	
	[self showAlertUsingResourceWithName:@"Introduction"];
}

-(void)showCompletedMessage {
	
	[self showAlertUsingResourceWithName:@"ProjectInfo"];
}

#pragma mark Delegate

/* UIAlertView delegate methods */

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	// OBS! Tmp solution to simply show welcome messages instead of doing the registration process!
	
	if (![[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultRegistrationComplete]) {
		
		[self showCompletedMessage];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:FCDefaultRegistrationComplete];
		
	} else {
	
		// user defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		// * SETTINGS
		
		[defaults setInteger:FCTabGlucose forKey:FCDefaultTabBarIndex]; // Glucose tab
		[defaults setInteger:FCUnitSystemMetric forKey:FCDefaultHeightWeigthSystem]; // Metric
		[defaults setInteger:FCDateDisplayDate forKey:FCDefaultAgeDisplay]; // Date
		[defaults setBool:YES forKey:FCDefaultGraphSettingScrollRelatives]; // scroll relatives in graph
		
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageProfile];
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageGlucose];
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageTags];
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageRecord];
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageLog];
		[defaults setBool:YES forKey:FCDefaultShowHelpMessageGraph];
		
		// synchronise defaults
		[defaults synchronize];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRegistrationCompleted object:self];
	}
}

@end
