//
//  FCAppCustomViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 13/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import "FCAppCustomViewController.h"


@implementation FCAppCustomViewController

@synthesize entry;
@synthesize cancelled;
@synthesize opaque, navigationControllerFadesOut;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)theEntry {
	
	if (self = [super init]) {
		
		self.entry = theEntry;
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
	
	[entry release];
    
	[super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	// * Main view
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
	
	if (self.opaque)
		view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	else
		view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
	
	self.view = view;
	[view release];
	
	// make notification that rotation is not allowed
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationNotAllowed object:self];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Animation

-(void)animateFadeIn {
	
	[UIView beginAnimations:@"PresentInputViewController" context:NULL];
	[UIView setAnimationDuration:kViewAppearDuration];
	
	self.view.alpha = 1.0f;
	
	[UIView commitAnimations];
}

-(void)animateFadeOut {
	
	[UIView beginAnimations:@"DismissInputViewController" context:NULL];
	[UIView setAnimationDelay:kViewDisappearDelay];
	[UIView setAnimationDuration:kViewDisappearDuration];
	
	self.view.alpha = 0.0f;
	
	[UIView commitAnimations];
}

-(void)animateFadeInAndCover {
	
	if (self.navigationController != nil) {
	
		// custom animation to fade in the container navigation controller (including navigation bar) and cover the tab bar
		[UIView beginAnimations:@"PresentGlucoseInputViewController" context:NULL];
		[UIView setAnimationDuration:kViewAppearDuration];
		
		self.navigationController.view.alpha = 1.0f;
		self.navigationController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
		
		[UIView commitAnimations];
	}
}

-(void)animateFadeOutAndUncover {
	
	if (self.navigationController != nil) {
		
		// custom animation to fade out the container navigation controller (including navigation bar) and uncover the tab bar
		[UIView beginAnimations:@"DismissGlucoseInputViewController" context:NULL];
		[UIView setAnimationDelay:kViewDisappearDelay];
		[UIView setAnimationDuration:kViewDisappearDuration];
		
		self.navigationController.view.alpha = 0.0f;
		self.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 367.0f);
		
		[UIView commitAnimations];
	}
}

#pragma mark Custom

-(void)dismiss {
	
	// * Hide navigation bar
	if (!navigationControllerFadesOut)
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	// * Dismiss UI elements
	[self dismissUIElements];
	
	// * Fade out
	if (navigationControllerFadesOut)
		[self animateFadeOutAndUncover];
	else
		[self animateFadeOut];
	
	// * Remove navigation controller from superview and release it
	if (self.navigationController != nil) {
		
		NSTimeInterval delay = kViewDisappearDelay + kViewDisappearDuration;
		[self.navigationController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:delay];
		[self.navigationController performSelector:@selector(release) withObject:nil afterDelay:delay];
	}
	
	// * Make notifications
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationRotationAllowed object:self];
}

-(void)dismissUIElements {
	
}

@end
