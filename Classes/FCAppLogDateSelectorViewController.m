//
//  FCAppLogDateSelectorViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 21/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import "FCAppLogDateSelectorViewController.h"


@implementation FCAppLogDateSelectorViewController

@synthesize datePickerView;
@synthesize startDateLabel, endDateLabel;
@synthesize separatorLabel;

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
	
	[datePickerView release];
	
	[startDateLabel release];
	[endDateLabel release];
	
	[separatorLabel release];
	
    [super dealloc];
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

#pragma mark Custom

-(void)presentContent {

	// right button
	
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// get the end date
	NSDate *endDate = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultLogDates] objectForKey:@"EndDate"];
	
	NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0.0f];
	
	if (endDate == nil)
		endDate = now;
	
	// create date picker
	
	UIDatePicker *newDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 460.0f, 320.0f, 216.0f)];
	newDatePicker.datePickerMode = UIDatePickerModeDate;
	
	[newDatePicker addTarget:self action:@selector(setLabels) forControlEvents:UIControlEventValueChanged];
	
	newDatePicker.maximumDate = now;
	newDatePicker.date = endDate;
	
	[now release];
	
	[self.view addSubview:newDatePicker];
	self.datePickerView = newDatePicker;
	
	[newDatePicker release];
	
	// create the labels
	
	UILabel *newStartDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 155.0f, 24.0f)];
	newStartDateLabel.backgroundColor = [UIColor clearColor];
	newStartDateLabel.textColor = [UIColor whiteColor];
	newStartDateLabel.textAlignment = UITextAlignmentCenter;
	newStartDateLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	self.startDateLabel = newStartDateLabel;
	[self.view addSubview:newStartDateLabel];
	
	[newStartDateLabel release];
	
	UILabel *newEndDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(165.0f, 20.0f, 155.0f, 24.0f)];
	newEndDateLabel.backgroundColor = [UIColor clearColor];
	newEndDateLabel.textColor = [UIColor whiteColor];
	newEndDateLabel.textAlignment = UITextAlignmentCenter;
	newEndDateLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	self.endDateLabel = newEndDateLabel;
	[self.view addSubview:newEndDateLabel];
	
	[newEndDateLabel release];
	
	UILabel *newSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(155.0f, 20.0f, 10.0f, 24.0f)];
	newSeparatorLabel.backgroundColor = [UIColor clearColor];
	newSeparatorLabel.textColor = [UIColor whiteColor];
	newSeparatorLabel.textAlignment = UITextAlignmentCenter;
	newSeparatorLabel.font = [UIFont boldSystemFontOfSize:22.0f];
	
	newSeparatorLabel.text = @"-";
	
	self.separatorLabel = newSeparatorLabel;
	[self.view addSubview:newSeparatorLabel];
	
	[newSeparatorLabel release];
	
	// set the labels
	[self setLabels];
	
	// show navigation bar
	if (self.navigationController.navigationBarHidden == YES)
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// animate date picker appearance
	
	[UIView beginAnimations:@"PresentDatePicker" context:NULL];
	[UIView setAnimationDuration:kAppearDuration];
	
	CGRect newFrame = CGRectMake(0.0f, 200.0f, 320.0f, 216.0f);
	self.datePickerView.frame = newFrame;
	
	[UIView commitAnimations];
}

-(void)dismiss {
	
	// get end date from the picker
	NSDate *endDate = [self.datePickerView.date retain];
	
	// calculate the start date
	NSTimeInterval interval = -518400; // 6 days
	NSDate *startDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:endDate];
	
	// save the dates
	NSDictionary *logDates = [[NSDictionary alloc] initWithObjectsAndKeys:startDate, @"StartDate", endDate, @"EndDate", nil];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:logDates forKey:FCDefaultLogDates];
	
	[logDates release];
	
	[startDate release];
	[endDate release];
	
	// post notification
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationLogDateChanged object:self];
	
	// super dismiss
	[super dismiss];
}

-(void)dismissUIElements {
	
	[self.startDateLabel removeFromSuperview];
	[self.separatorLabel removeFromSuperview];
	[self.endDateLabel removeFromSuperview];
		
	[UIView beginAnimations:@"DismissDatePicker" context:NULL];
	[UIView setAnimationDuration:kDisappearDuration];
	
	CGRect newFrame = CGRectMake(0.0f, 460.f, 320.0f, 216.0f);
	self.datePickerView.frame = newFrame;
	
	[UIView commitAnimations];
}

-(void)setLabels {

	// get end date from the picker
	NSDate *endDate = [self.datePickerView.date retain];
	
	// calculate the start date
	NSTimeInterval interval = -518400; // 6 days
	NSDate *startDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:endDate];
	
	// set the labels
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	
	self.startDateLabel.text = [formatter stringFromDate:startDate];
	self.endDateLabel.text = [formatter stringFromDate:endDate];
	
	[formatter release];
	
	[endDate release];
	[startDate release];
}


@end
