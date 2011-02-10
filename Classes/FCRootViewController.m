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
//  FCRootViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 06/08/2010.
//

#import "FCRootViewController.h"

#import "FCAppRootViewController.h"
#import "FCGraphRootViewController.h"
#import "FCRegistrationViewController.h"

@implementation FCRootViewController

@synthesize activityIndicator, statusLabel;
@synthesize rotationIsAllowed, isShowingLandscapeView;

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
	
	[activityIndicator release];
	[statusLabel release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCRootViewController -didReceiveMemoryWarning!");
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	self.view = view;
	[view release];
	
	// * Orientation
	self.rotationIsAllowed = NO; // default is no, certain view controllers enable it via a notification
	self.isShowingLandscapeView = NO;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationChangeNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRotationAllowedNotification) name:FCNotificationRotationAllowed object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRotationNotAllowedNotification) name:FCNotificationRotationNotAllowed object:nil];
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

	 // * Add an activity indicator
	 UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	 
	 CGRect newFrame = CGRectMake(10.0f, 10.0f, activityView.frame.size.width, activityView.frame.size.height);
	 activityView.frame = newFrame;
	 
	 [activityView startAnimating];
	 
	 self.activityIndicator = activityView;
	 [activityView release];
	 
	 [self.view addSubview:self.activityIndicator];
	 
	 // * Add a status label
	 UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 20.0f, 260.0f, 20.0f)];
	 
	 aLabel.backgroundColor = [UIColor clearColor];
	 aLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	 aLabel.text = @"Please wait...";
	 
	 self.statusLabel = aLabel;
	 [aLabel release];
	 
	 [self.view addSubview:self.statusLabel];
	
	// call super
	[super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	self.statusLabel.text = @"Here we go!";
	[self.activityIndicator stopAnimating];
	
	// call super
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
	
	[self.statusLabel removeFromSuperview];
	self.statusLabel = nil;
	
	// call super
	[super viewDidDisappear:animated];
}

-(void)loadApplication {
	
	// * Maintinance
	
	[self setLogDatesToNow];
	[self purgeDefaultGraphSets];
	
	// * Load application...
	
	BOOL registrationComplete = [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultRegistrationComplete];
	if (registrationComplete) {
		
		// * Application view controller
		[self performSelector:@selector(loadApplicationViewController) withObject:NULL afterDelay:1.0f]; // delay for dramatical effect...
		
	} else {
		
		// * Registration view controller
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegistrationCompleteNotification) name:FCNotificationRegistrationCompleted object:nil];
		
		[self performSelector:@selector(loadRegistrationViewController) withObject:NULL afterDelay:1.0f]; // delay for dramatical effect...
	}
}

-(void)loadApplicationViewController {
	
	NSLog(@"FCRootViewController || Loading application view controller...");
	
	FCAppRootViewController *appViewController = [[FCAppRootViewController alloc] init];
	
	[appViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:appViewController animated:YES];
	
	[appViewController release];
}

-(void)loadGraphViewController {
	
	NSLog(@"FCRootViewController || Loading graph view controller...");
	
	// create and display view controller
	
	FCGraphRootViewController *graphViewController = [[FCGraphRootViewController alloc] init];
	
	[graphViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:graphViewController animated:YES];
	
	[graphViewController release];
	
	// update the user defaults so that it remembers to return to graph when rotated back to app mode
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:FCDefaultShowLog];
}

-(void)loadRegistrationViewController {
	
	NSLog(@"FCRootViewController || Loading registration view controller...");
	
	FCRegistrationViewController *registrationViewController = [[FCRegistrationViewController alloc] init];
	
	[registrationViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:registrationViewController animated:YES];
	
	[registrationViewController release];
}

-(void)onRegistrationCompleteNotification {
	
	NSLog(@"FCRootViewController || Dismissing registration view controller...");
	
	[self dismissModalViewControllerAnimated:YES];
	
	[self performSelector:@selector(loadApplicationViewController) withObject:NULL afterDelay:1.0f]; // delay to wait for dismiss modal view controller animation to finish
}

#pragma mark Orientation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (rotationIsAllowed) {
	
		if (interfaceOrientation == UIInterfaceOrientationPortrait) {
			
			if([UIApplication sharedApplication].statusBarHidden)
				[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
			
			return YES;
			
		} else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			
			if(![UIApplication sharedApplication].statusBarHidden)
				[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
			
			return YES;
		}
	}
	
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

	NSLog(@"FCRootViewController -willAnimateRotationToInterfaceOrientation:duration:");
}
*/

/*
- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	NSLog(@"FCRootViewController -willAnimateFirstHalfOfRotationToInterfaceOrientation:duration:");
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {

	NSLog(@"FCRootViewController -willAnimateSecondHalfOfRotationFromInterfaceOrientation:duration:");
}
*/

-(void)onOrientationChangeNotification {
	
	if (rotationIsAllowed) {
		
		UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
		
		if (deviceOrientation == UIDeviceOrientationLandscapeLeft && !isShowingLandscapeView) {
			
			NSLog(@"FCRootViewController || Dismissing app view controller...");
			[self dismissModalViewControllerAnimated:YES];
			
			[self performSelector:@selector(loadGraphViewController) withObject:NULL afterDelay:1.0f]; // delay to wait for dismiss modal view controller animation to finish
			
			self.isShowingLandscapeView = YES;
			
		} else if (deviceOrientation == UIDeviceOrientationPortrait && isShowingLandscapeView) {
			
			NSLog(@"FCRootViewController || Dismissing graph view controller...");
			[self dismissModalViewControllerAnimated:YES];
			
			[self performSelector:@selector(loadApplicationViewController) withObject:NULL afterDelay:1.0f]; // delay to wait for dismiss modal view controller animation to finish
			
			self.isShowingLandscapeView = NO;
		}
	}
}

-(void)onRotationAllowedNotification {
	
	self.rotationIsAllowed = YES;
}

-(void)onRotationNotAllowedNotification {
	
	self.rotationIsAllowed = NO;
}

-(void)setLogDatesToNow {
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	NSDateComponents *components = [gregorian components:unitFlags fromDate:now]; // makes sure we are always dealing with 00:00 AM on both dates
	[now release];
	
	NSDate *newEndDate = [gregorian dateFromComponents:components];
	
	[gregorian release];
	
	NSDate *newStartDate;
	
	FCGraphScaleDateLevel level = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
	
	switch (level) {
			
		case FCGraphScaleDateLevelHours:
			newStartDate = [NSDate dateWithTimeInterval:-518400 sinceDate:newEndDate]; // week
			break;
			
		default:
			newStartDate = [NSDate dateWithTimeInterval:-2505600 sinceDate:newEndDate]; // month
			break;
	}
	
	// save the dates in the user defaults
	NSDictionary *logDates = [[NSDictionary alloc] initWithObjectsAndKeys:newStartDate, @"StartDate", newEndDate, @"EndDate", nil];
	[[NSUserDefaults standardUserDefaults] setObject:logDates forKey:FCDefaultLogDates];
	[logDates release];
}

-(void)purgeDefaultGraphSets {
/*	Ensures that there are no graph sets for categories that no longer exists.
 
	Should always be none, but I have encountered a few instances where there were
	left-over graph sets after having deleted numerous tags or where the app has crashed
	before defaults were synchronised. This method ensures consistency. */
	
	NSArray *defaultGraphs = [[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs];
	if (defaultGraphs != nil) {
		
		NSMutableArray *graphSetsToRemove = [[NSMutableArray alloc] init];		
		for (NSDictionary *graphSet in defaultGraphs) {
			
			FCCategory *category = [FCCategory categoryWithCID:[graphSet objectForKey:@"Key"]];
			if (category == nil)
				[graphSetsToRemove addObject:graphSet];
		}
		
		if ([graphSetsToRemove count] > 0) {
			
			NSMutableArray *mutableNewDefaultGraphs = [[NSMutableArray alloc] initWithArray:defaultGraphs];
			
			for (NSDictionary *graphSet in graphSetsToRemove)
				[mutableNewDefaultGraphs removeObject:graphSet];
			
			NSRange range = NSMakeRange(0, [mutableNewDefaultGraphs count]);
			NSArray *newDefaultGraphs = [[NSArray alloc] initWithArray:[mutableNewDefaultGraphs subarrayWithRange:range]];
			[mutableNewDefaultGraphs release];
			
			[[NSUserDefaults standardUserDefaults] setObject:newDefaultGraphs forKey:FCDefaultGraphs];
			
			[newDefaultGraphs release];
			
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		[graphSetsToRemove release];
	}
}

@end
