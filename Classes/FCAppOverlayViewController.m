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
//  FCAppOverlayViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//

#import "FCAppOverlayViewController.h"


@implementation FCAppOverlayViewController

@synthesize parent;
@synthesize isOpaque, navigationControllerFadesInOut;
@synthesize shouldAnimateContent, shouldAnimateToCoverTabBar;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
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
    
	[super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// * Main view
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
	
	if (self.isOpaque)
		newView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	
	else
		newView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
	
	self.view = newView;
	[newView release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Orientation

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Animation

-(void)animateFadeIn {
	
	[UIView animateWithDuration:kViewAppearDuration 
					 animations:^ { if (self.navigationControllerFadesInOut) self.navigationController.view.alpha = 1.0f;
										else self.view.alpha = 1.0f; } ];
}

-(void)animateFadeOut {
	
	[UIView animateWithDuration:kViewDisappearDuration 
						  delay:kViewDisappearDelay 
						options:0 
					 animations:^ { if (self.navigationControllerFadesInOut) self.navigationController.view.alpha = 0.0f;
									else self.view.alpha = 0.0f; }
					 completion:^ (BOOL finished) { } ];
}

-(void)animateFadeInAndCover {
/*	Custom animation that fades in the container navigation controller (including navigation bar) 
	and covers the tab bar. */
	
	[UIView animateWithDuration:kViewAppearDuration 
					 animations:^ {	self.navigationController.view.alpha = 1.0f; 
									self.navigationController.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f); } ];
}

-(void)animateFadeOutAndUncover {
/*	Custom animation that fades out the container navigation controller (including navigation bar)
	and also uncovers the tab bar. */
	
	[UIView animateWithDuration:kViewDisappearDuration 
						  delay:kViewDisappearDelay 
						options:0 
					 animations:^ {	self.navigationController.view.alpha = 0.0f;
									self.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 367.0f); }
					 completion:^ (BOOL finished) { } ];
}

#pragma mark Custom

-(void)present {
	
	// * Create content
	
	[self createUIContent];
	
	// * Animate appearance
	
	if (self.shouldAnimateToCoverTabBar)
		[self animateFadeInAndCover];
	
	else
		[self animateFadeIn];
	
	// * Present or show content
	
	// ui content
	if (self.shouldAnimateContent) {
		
		[self performSelector:@selector(presentUIContent) 
				   withObject:nil 
				   afterDelay:kViewAppearDuration ];
		
	} else {
		
		[self showUIContent];
	}
}

-(void)transitionTo:(FCAppOverlayViewController *)anotherOverlayViewController {
	
	// * Remove or dismiss UI content in self
	
	if (self.shouldAnimateContent)
		[self dismissUIContent];
	
	else
		[self removeUIContent];
	
	// * Replace self in parent
	
	NSTimeInterval delay = kDisappearDuration;
	[self.parent performSelector:@selector(replaceOverlayViewControllerWith:) 
					  withObject:anotherOverlayViewController 
					  afterDelay:delay];	
}

-(void)dismiss {
	
	// * Remove or dismiss UI elements
	
	// navigation bar
	
	if (!self.navigationControllerFadesInOut)
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	// ui elements
	
	if (self.shouldAnimateContent)
		[self dismissUIContent];
	
	else
		[self removeUIContent];
	
	// * Animate dissappearance
	
	if (self.shouldAnimateToCoverTabBar)
		[self animateFadeOutAndUncover];
	
	else
		[self animateFadeOut];
	
	// * Dismiss self from parent view controller
	
	NSTimeInterval delay = kDisappearDuration + kViewDisappearDelay + kViewDisappearDuration;
	[self.parent performSelector:@selector(dismissOverlayViewController) 
					  withObject:nil 
					  afterDelay:delay];	
}

#pragma mark Placeholders

-(void)createUIContent {
	
	// allocates and initializes all ui elements
}

-(void)showUIContent {
	
	// simply adds all ui elements to the main view
}

-(void)presentUIContent {
	
	// adds all ui elements to the main view, but animates their appearance
}

-(void)updateUIContent {
	
	// sets or updates the content of ui elements (e.g. text in UILabels, images in UIImageViews, etc)
}

-(void)removeUIContent {
	
	// simply removes all ui elements from the main view
}

-(void)dismissUIContent {
	
	// removes all ui elements from the main view, but animates their disappearance
}

@end
