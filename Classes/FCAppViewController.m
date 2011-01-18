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
//  FCAppViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//

#import "FCAppViewController.h"


#import "FCAppOverlayViewController.h"

@implementation FCAppViewController

@synthesize overlaidNavigationController;

#pragma mark Init

-(id)init {

	if (self = [super init]) {
		
	}
	
	return self;
}

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
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppViewController (SUPERCLASS) -didReceiveMemoryWarning!");
}

#pragma mark View

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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

-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	
	_isVisible = YES;

	[super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	
	_isVisible = NO;
	
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
}

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    
	// Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
	_progressHUD = nil;
}

#pragma mark Custom

-(void)presentOverlayViewController:(id)anOverlayViewController {
	
	// assert that we are passed the correct object
	BOOL isKind = [anOverlayViewController isKindOfClass:[FCAppOverlayViewController class]];
	NSAssert1(isKind, @"FCAppViewController -presentOverlayViewController: || %@", @"Could not present overlay view controller since object was not kind of FCAppOverlayViewController!");
	
	// make notification that rotation is not allowed
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationNotAllowed object:self];
	
	// static typing for practical purposes
	
	FCAppOverlayViewController *typedOverlayController = (FCAppOverlayViewController *)anOverlayViewController;
	
	// set parent as self
	
	typedOverlayController.parent = self;
	
	// create a navigation controller which will contain the custom view controller
	// and prepare both view controllers for the correct appearance animations
	
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:typedOverlayController];
	aNavigationController.delegate = self.navigationController.delegate;
	
	if (typedOverlayController.shouldAnimateToCoverTabBar)
		aNavigationController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 411.0f);
	
	else
		aNavigationController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
	
	if (typedOverlayController.navigationControllerFadesInOut) {
		
		aNavigationController.view.alpha = 0.0f;
		
	} else {
		
		[aNavigationController setNavigationBarHidden:YES animated:NO];
		typedOverlayController.view.alpha = 0.0f;
	}
	
	// add the navigation controller to the app window to cover all
	
	/* [self.view.window addSubview:aNavigationController.view]; */
	
	if (self.tabBarController != nil)
		[self.tabBarController.view addSubview:aNavigationController.view];
	
	else if (self.navigationController != nil)
		[self.navigationController.view addSubview:aNavigationController.view];
	
	else
		NSAssert1(0, @"FCAppViewController -presentOverlayViewController: || %@", @"Failed to present overlay view controller since neither self.tabBarController nor self.navigationBarController was set!");
	
	// save the ivar and release
	self.overlaidNavigationController = aNavigationController;
	[aNavigationController release];
	
	// present custom view controller (affects navigation controller too)
	
	[typedOverlayController present];
}

-(void)replaceOverlayViewControllerWith:(id)anotherOverlayViewController {
	
	// assert that we are passed the correct object
	BOOL isKind = [anotherOverlayViewController isKindOfClass:[FCAppOverlayViewController class]];
	NSAssert1(isKind, @"FCAppViewController -replaceOverlayViewControllerWith: || %@", @"Could not replace overlay view controller since object was not kind of FCAppOverlayViewController!");
	
	// get pointer to and retain old overlaid container
	
	UINavigationController *oldOverlaidContainer = [self.overlaidNavigationController retain];
	
	// present the new overlay
	
	[self presentOverlayViewController:anotherOverlayViewController];
	
	// remove form superview and release the old overlay container
	
	NSTimeInterval delay = kViewAppearDuration + kAppearDuration;
	
	[oldOverlaidContainer.view performSelector:@selector(removeFromSuperview) 
									withObject:nil 
									afterDelay:delay];
	
	[oldOverlaidContainer performSelector:@selector(release) 
							   withObject:nil 
							   afterDelay:delay];
}

-(void)dismissOverlayViewController {
	
	// make notification that rotation is allowed
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationAllowed object:self];
	
	// remove the overlaid navigation controller from its superview
	[self.overlaidNavigationController.view removeFromSuperview];
	
	// release navigation controller which contains the overlay view controller
	self.overlaidNavigationController = nil;
	
	if (!self.searchDisplayController.active)
		[self viewDidAppear:YES];
}

-(void)performTask:(SEL)task {
	
	[self performTask:task withObject:nil message:@"Loading"];
}

-(void)performTask:(SEL)task withMessage:(NSString *)message {
	
	[self performTask:task withObject:nil message:message];
}

-(void)performTask:(SEL)task withObject:(id)object {
	
	[self performTask:task withObject:object message:@"Loading"];
}

-(void)performTask:(SEL)task withObject:(id)object message:(NSString *)message {
	
	if (_progressHUD == nil) {
	
		UIView *topView = self.tabBarController != nil ? self.tabBarController.view : self.navigationController.view;
		
		// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
		_progressHUD = [[MBProgressHUD alloc] initWithView:topView];
		
		// Add HUD to screen
		[topView addSubview:_progressHUD];
		
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		_progressHUD.delegate = self;
		
		_progressHUD.labelText = message;
		
		// Show the HUD while the provided method executes in a new thread
		[_progressHUD showWhileExecuting:task onTarget:self withObject:object animated:YES];
	}
}

@end
