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
//  FCAppProfileInputViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/09/2010.
//

#import "FCAppProfileInputViewController.h"


@implementation FCAppProfileInputViewController

@synthesize defaultItems;
@synthesize textView, label, datePicker;

#pragma mark Init

-(id)initWithDefaultItems:(NSArray *)theDefaultItems {
	
	if (self = [super init]) {
		
		self.defaultItems = theDefaultItems;
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
	
	[defaultItems release];
	
	if (textView != nil)
		[textView release];
	
	if (label != nil)
		[label release];
	
	if (datePicker != nil)
		[datePicker release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	[super loadView];
	
	// * Title
	NSArray *viewControllersInStack = [self.navigationController viewControllers];
	NSUInteger index = [viewControllersInStack indexOfObject:self];
	self.title = [[defaultItems objectAtIndex:index] objectForKey:@"Title"];
	
	// * Cancelled
	self.cancelled = NO;
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

#pragma mark Orientation

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Custom

-(void)presentContent {
	
	// * Determine if this is the last one in the navigation stack
	NSArray *viewControllersInStack = [self.navigationController viewControllers];
	NSUInteger index = [viewControllersInStack indexOfObject:self];	
	NSUInteger lastIndex = [self.defaultItems count] - 1;
	
	BOOL isLast;
	if (index == lastIndex) 
		isLast = YES;
	else 
		isLast = NO;
	
	// * Right button
	NSString *rightButtonTitle = isLast ? @"Done" : @"Next";
	if (self.navigationItem.rightBarButtonItem == nil) {
		
		// create new button
		UIBarButtonItem *rightButton;
		if (isLast)
			rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
		
		else
			rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(next)];
		
		self.navigationItem.rightBarButtonItem = rightButton;
		[rightButton release];
	
	} else {
		
		// update title
		self.navigationItem.rightBarButtonItem.title = rightButtonTitle;
	}
	
	// * Navigation bar
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// * Input elements
	
	// get the default object which is to be changed
	NSDictionary *item = [defaultItems objectAtIndex:index];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id object = [defaults objectForKey:[item objectForKey:@"DefaultKey"]];
	
	// flag for if we're dealing with a saved date or not
	BOOL isNow = NO;
	
	// deal with no entered defaults
	if (object == nil) {
		
		// Just consider these special cases: date of birth, date diagnosed, height and weigh.
		// The rest are per default strings.
		
		NSString *defaultKey = [item objectForKey:@"DefaultKey"];
		if (defaultKey == FCDefaultProfileDateOfBirth || defaultKey == FCDefaultProfileDiabetesDateDiagnosed) {
			
			object = (NSDate *)[NSDate dateWithTimeIntervalSinceNow:0.0f];
			isNow = YES;
		
		} else if (defaultKey == FCDefaultProfileHeight || defaultKey == FCDefaultProfileWeight)
			object = (NSNumber *)[NSNumber numberWithInt:0];
		
		else
			object = [NSString stringWithString:@""];
	}
	
	// call upp appropriate UI elements for its type
	if ([object isKindOfClass:[NSString class]]) {
		
		NSString *string = [[NSString alloc] initWithString:(NSString *)object];
		UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 160.0f)];
		newTextView.backgroundColor = [UIColor clearColor];
		newTextView.font = [UIFont boldSystemFontOfSize:22.0f];
		newTextView.textColor = [UIColor whiteColor];
		newTextView.textAlignment = UITextAlignmentCenter;
		newTextView.text = string;
		
		self.textView = newTextView;
		[self.view addSubview:newTextView];
		
		[string release];
		[newTextView release];
		
		[self.textView becomeFirstResponder];
		
	} else if ([object isKindOfClass:[NSDate class]]) {
		
		NSDate *date = [(NSDate *)object copy];
		
		// label
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.dateStyle = NSDateFormatterMediumStyle;
		
		NSString *string = [[NSString alloc] initWithString:[formatter stringFromDate:date]];
		
		[formatter release];
		
		UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 280.0f, 24.0f)];
		newLabel.backgroundColor = [UIColor clearColor];
		newLabel.textColor = [UIColor whiteColor];
		newLabel.textAlignment = UITextAlignmentCenter;
		newLabel.font = [UIFont boldSystemFontOfSize:22.0f];
		newLabel.text = string;
		
		self.label = newLabel;
		[self.view addSubview:newLabel];
		
		[string release];
		
		// date picker
		UIDatePicker *newDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 416.0f, 320.0f, 216.0f)];
		newDatePicker.datePickerMode = UIDatePickerModeDate;
		
		NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
		newDatePicker.maximumDate = now;
		[now release];
		
		newDatePicker.date = date;
		[date release];
		
		[self.view addSubview:newDatePicker];
		self.datePicker = newDatePicker;
		
		[newDatePicker release];
		
		// animate date picker appearance
		[UIView beginAnimations:@"PresentDatePicker" context:NULL];
		[UIView setAnimationDuration:kAppearDuration];
		
		CGRect newFrame = CGRectMake(0.0f, 200.0f, 320.0f, 216.0f);
		self.datePicker.frame = newFrame;
		
		[UIView commitAnimations];
		
		// also add a remove button for dates
		NSString *title;
		if (isNow) 
			title = @"Cancel";
		else 
			title = @"Remove";
		
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
		self.navigationItem.leftBarButtonItem = newButton;
		
	} else if ([object isKindOfClass:[NSNumber class]]) {
		
	}
}

-(void)dismiss {

	// * Update the user defaults
	[self updateUserDefaults];
	
	// * Super dismiss
	[super dismiss];
}

-(void)next {
	
}

-(void)cancel {
	
	// flag that cancel/remove has been pressed
	self.cancelled = YES;
	
	// update user defaults
	[self updateUserDefaults];
	
	[super dismiss];
}

-(void)updateUserDefaults {
	
	NSArray *viewControllersInStack = [self.navigationController viewControllers];
	NSUInteger index = [viewControllersInStack indexOfObject:self];
	NSDictionary *item = [defaultItems objectAtIndex:index];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (self.textView != nil) {
		
		NSString *string = [(NSString *)self.textView.text copy];
		if ([string length] == 0)
			[defaults removeObjectForKey:[item objectForKey:@"DefaultKey"]];
		else
			[defaults setObject:string forKey:[item objectForKey:@"DefaultKey"]];
		
	} else if (self.datePicker != nil) {
		
		NSDate *date = [(NSDate *)self.datePicker.date copy];
		if (cancelled)
			[defaults removeObjectForKey:[item objectForKey:@"DefaultKey"]];
		else 
			[defaults setObject:date forKey:[item objectForKey:@"DefaultKey"]];
	}
	
	// synchronise user defaults and send notification
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationUserDefaultsUpdated object:self];
}

-(void)dismissUIElements {
	
	if (self.textView != nil) {
		
		[self.textView resignFirstResponder];
		[self.textView removeFromSuperview];
		
	} else if (self.datePicker != nil) {
		
		[self.label removeFromSuperview];
		
		[UIView beginAnimations:@"DismissDatePicker" context:NULL];
		[UIView setAnimationDuration:kDisappearDuration];
		
		CGRect newFrame = CGRectMake(0.0f, 460.f, 320.0f, 216.0f);
		self.datePicker.frame = newFrame;
		
		[UIView commitAnimations];
		
		[self.datePicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDisappearDuration];
	}
}

@end
