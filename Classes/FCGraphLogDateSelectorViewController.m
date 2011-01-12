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
//  FCGraphLogDateSelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 06/01/2011.
//

#import "FCGraphLogDateSelectorViewController.h"


@implementation FCGraphLogDateSelectorViewController

@synthesize calendarMonthView, calendarDelegate;
@synthesize doneButton;
@synthesize selectingAdditionalLogDates;

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
	
	[calendarMonthView release];
	[calendarDelegate release];
	
	[doneButton release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 320.0f)];
	newView.backgroundColor = [UIColor blackColor];
	
	self.view = newView;
	
	[newView release];
	
	UIButton *newDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *image = [UIImage imageNamed:@"doneButton.png"];
	[newDoneButton setImage:image forState:UIControlStateNormal];
	
	newDoneButton.frame = CGRectMake(self.view.frame.size.width - 35.0f, 5.0f, image.size.width, image.size.height);
	
	[newDoneButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
	
	self.doneButton = newDoneButton;
	
	FCCalendarDelegate *newCalendarDelegate = [[FCCalendarDelegate alloc] init];
	self.calendarDelegate = newCalendarDelegate;
	[newCalendarDelegate release];
	
	TKCalendarMonthView *newCalendarMonthView = [[TKCalendarMonthView alloc] init];
	newCalendarMonthView.delegate = self.calendarDelegate;
	newCalendarMonthView.dataSource = self.calendarDelegate;
	self.calendarDelegate.calendarMonthView = newCalendarMonthView;
	
	newCalendarMonthView.frame = CGRectMake(5.0f, 5.0f, newCalendarMonthView.frame.size.width, newCalendarMonthView.frame.size.height); // in preparation for appearance animation below
	
	self.calendarMonthView = newCalendarMonthView;
	[newCalendarMonthView release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Custom

-(void)presentUIContent {
	
	NSDate *endDate = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultLogDates] objectForKey:@"EndDate"];
	[self.calendarMonthView selectDate:endDate];
	
	// reload calendar month view to highlight selected
	[self.calendarMonthView reload];
	
	// animate calendar month view, label and segmented control onto screen
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	self.calendarMonthView.transform = translation;
	
	[self.view addSubview:self.calendarMonthView];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.calendarMonthView.transform = CGAffineTransformIdentity; } 
					 completion:^ (BOOL finished) { [self.view addSubview:self.doneButton]; } ];
}

-(void)dismissUIContent {
	
	[self.doneButton removeFromSuperview];
	
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, 460.0f);
	
	[UIView animateWithDuration:kDisappearDuration 
					 animations:^{ self.calendarMonthView.transform = translation; } 
					 completion:^(BOOL finished) { [self.calendarMonthView removeFromSuperview]; [[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphLogDateSelectorDismissed object:self]; } ];	
}

-(void)save {
	
	if (self.calendarDelegate.lastSelectedDate != nil && !self.selectingAdditionalLogDates)
		[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphOptionsChanged object:self];

	[self dismissUIContent];
}

@end
