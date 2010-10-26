/*
 
 TiY (tm) - an adaptable iPhone application for self-management of type 1 diabetes
 Copyright (C) 2010  Anders Sigfridsson
 
 TiY (tm) is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TiY (tm) is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See  the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with TiY (tm).  If not, see <http://www.gnu.org/licenses/>.
 
 */  

//
//  FCAppEntryViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 16/09/2010.
//

#import "FCAppEntryViewController.h"


@implementation FCAppEntryViewController

@synthesize iconImageView, timestampLabel, numberLabel, textView, unitLabel;

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
	
	[iconImageView release];
	[timestampLabel release];
	[numberLabel release];
	[textView release];
	[unitLabel release];
	
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

-(void)createContentForCreatingNewEntry; {
	
}

-(void)createContentForAddingAttachments {
	
	// timestamp label
	
	UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 20.0f)];
	newTimestampLabel.backgroundColor = [UIColor clearColor];
	newTimestampLabel.textAlignment = UITextAlignmentCenter;
	newTimestampLabel.font = [UIFont systemFontOfSize:18.0f];
	
	self.timestampLabel = newTimestampLabel;
	[self.view addSubview:newTimestampLabel];
	
	[newTimestampLabel release];
	
	if (self.entry.integer != nil || self.entry.decimal != nil) {
	
		// number label
		
		UILabel *newNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 40.0f)];
		newNumberLabel.backgroundColor = [UIColor clearColor];
		newNumberLabel.textAlignment = UITextAlignmentCenter;
		newNumberLabel.font = [UIFont boldSystemFontOfSize:36.0f];
		
		self.numberLabel = newNumberLabel;
		[self.view addSubview:newNumberLabel];
		
		[newNumberLabel release];
		
		// unit label
		
		UILabel *newUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 90.0f, 320.0f, 20.0f)];
		newUnitLabel.backgroundColor = [UIColor clearColor];
		newUnitLabel.textAlignment = UITextAlignmentCenter;
		newUnitLabel.font = [UIFont systemFontOfSize:18.0f];
		
		self.unitLabel = newUnitLabel;
		[self.view addSubview:newUnitLabel];
		
		[newUnitLabel release];
	}
}

-(void)showContentForAddingAttachments {
	
	// if this entry has not yet been saved (ie has no eid) and there is NOT already a back button, add a cancel button (happens for new glucose readings)
	if (self.entry.eid == nil && self.navigationItem.backBarButtonItem == nil) {
		
		// * Left button
		UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
		self.navigationItem.leftBarButtonItem = newLeftButton;
		[newLeftButton release];
	}
	
	// * Right button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// create the UI content
	[self createContentForAddingAttachments];
	
	// fill in content
	[self setContentsForUIElements];
}

-(void)setContentsForUIElements {
	
	// timestamp label and icon image view
	
	if (self.timestampLabel != nil) {
		
		// set the timestamp label text
		self.timestampLabel.text = self.entry.timestampDescription;
	
		// resize and reposition the timestamp label
		CGSize newSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font];
		
		CGFloat xPosition = 160.0f - (newSize.width / 2);
		CGFloat yPosition = self.timestampLabel.frame.origin.y;
		CGFloat width = newSize.width;
		CGFloat height = self.timestampLabel.frame.size.height;
		
		self.timestampLabel.frame = CGRectMake(xPosition, yPosition, width, height);
		
		// add an icon image view next to the timestamp
		UIImage *icon = [UIImage imageNamed:self.entry.category.icon];
		UIImageView *newIconImageView = [[UIImageView alloc] initWithImage:icon];
		
		CGFloat spacing = 10.0f;
		xPosition = self.timestampLabel.frame.origin.x - icon.size.width - spacing;
		yPosition = self.timestampLabel.frame.origin.y;
		width = icon.size.width;
		height = icon.size.height;
		
		newIconImageView.frame = CGRectMake(xPosition, yPosition, width, height);
		
		self.iconImageView = newIconImageView;
		[self.view addSubview:newIconImageView];
		
		[newIconImageView release];
	}
	
	// number and unit label
	
	BOOL converted = [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog];

	if (self.numberLabel != nil) {
		
		if (converted)
			self.numberLabel.text = self.entry.convertedShortDescription;
		else
			self.numberLabel.text = self.entry.shortDescription;
	}
	
	if (self.unitLabel != nil) {
	
		if (converted)
			self.unitLabel.text = self.entry.category.unit.abbreviation;
		else 
			self.unitLabel.text = self.entry.unit.abbreviation;
	}
}

-(void)save {
	
	// save the entry only if it is not already saved (ie has an eid)
	if (self.entry.eid == nil)
		[self.entry save];
	
	// dismiss
	[super dismiss];
}

@end
