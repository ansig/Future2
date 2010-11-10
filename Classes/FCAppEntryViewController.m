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


#import "FCAppNewEntryViewController.h"

@implementation FCAppEntryViewController

@synthesize entry;
@synthesize iconImageView;
@synthesize editButton;
@synthesize timestampLabel;
@synthesize numberLabel, unitLabel;
@synthesize textView;
@synthesize imageButton, scrollView, imageView, closeButton;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)theEntry {
	
	if (self = [super init]) {
		
		entry = [theEntry copy];
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
	
	[iconImageView release];
	
	[timestampLabel release];
	
	[editButton release];
	
	[numberLabel release];
	[unitLabel release];
	
	[textView release];
	
	[imageButton release];
	[scrollView release];
	[imageView release];
	[closeButton release];
	
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadNewEntryViewController {
	
	// start listening to entry updated notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryUpdatedNotification) name:FCNotificationEntryUpdated object:nil];
	
	// create an new entry input view controller with the current entry
	FCAppEntryViewController *newEntryViewController = [[FCAppNewEntryViewController alloc] initWithEntry:self.entry];
	newEntryViewController.title = self.entry.category.name;
	newEntryViewController.shouldAnimateContent = YES;
	
	// present the new entry view controller
	[self presentOverlayViewController:newEntryViewController];
	
	// release the entry input view controller
	[newEntryViewController release];
}

-(void)loadScrollViewForImage {
	
	UIImage *image = [UIImage imageWithContentsOfFile:self.entry.filePath];
	
	if (image != nil) {
		
		// create the scroll view
	
		UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
		newScrollView.backgroundColor = [UIColor lightGrayColor];
		
		CGFloat minimumScale = image.size.height > image.size.width ? newScrollView.frame.size.height / image.size.height : newScrollView.frame.size.width / image.size.width;
		newScrollView.minimumZoomScale = minimumScale;
		newScrollView.maximumZoomScale = 2.0;
		
		newScrollView.contentSize = image.size;
		
		newScrollView.delegate = self;
		
		self.scrollView = newScrollView;
		[newScrollView release];
		
		// image view
		
		UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
		newImageView.image = image;
		
		self.imageView = newImageView;
		
		[newImageView release];
		
		// add image view to scroll view
		
		[self.scrollView addSubview:self.imageView];
		self.scrollView.zoomScale = minimumScale; // zoom all the way out
		
		// animate the scroll views appearance
		
		// shrink
		
		CGAffineTransform scale = CGAffineTransformMakeScale(0.01f, 0.01f);
		
		// move
		
		CGPoint buttonCenter = self.imageButton.center;
		
		CGFloat xOffset = buttonCenter.x - self.scrollView.center.x;
		CGFloat yOffset = buttonCenter.y - self.scrollView.center.y;
		CGAffineTransform translate = CGAffineTransformMakeTranslation(xOffset, yOffset);
		
		// set transform and add to main view
		
		self.scrollView.transform = CGAffineTransformConcat(scale, translate);
		[self.view addSubview:self.scrollView];
		
		// animate appearance
		
		[UIView animateWithDuration:kAppearDuration 
						 animations:^ { self.scrollView.transform = CGAffineTransformIdentity; } 
						 completion:^ (BOOL finished) { [self createAndDisplayCloseButton]; } ];
	}
}

-(void)unloadScrollViewForImage {

	if (self.scrollView != nil && self.closeButton != nil) {
		
		// remove close button
		
		[self.closeButton removeFromSuperview];
		self.closeButton = nil;
	
		// shrink
		
		CGAffineTransform scale = CGAffineTransformMakeScale(0.01f, 0.01f);
		
		// move
		
		CGPoint buttonCenter = self.imageButton.center;
		
		CGFloat xOffset = buttonCenter.x - self.scrollView.center.x;
		CGFloat yOffset = buttonCenter.y - self.scrollView.center.y;
		CGAffineTransform translate = CGAffineTransformMakeTranslation(xOffset, yOffset);
		
		// set transform and add to main view
		
		CGAffineTransform transform = CGAffineTransformConcat(scale, translate);
		
		// animate appearance
		
		[UIView animateWithDuration:kDisappearDuration 
						 animations:^ { self.scrollView.transform = transform; } 
						 completion:^ (BOOL finished) { [self.scrollView removeFromSuperview]; self.scrollView = nil; } ];
		
	}
}

#pragma mark Orientation

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark FCEntryView

-(void)onEntryUpdatedNotification {
	
	// update UI content
	[self updateUIContent];
	
	// stop listening to notifications about entry updates
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationEntryUpdated object:nil];
}

-(void)onAttachmentAddedNotification {
	
}

-(void)onAttachmentRemovedNotification {
	
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
	
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

#pragma mark Custom

-(void)createUIContent {
	
	if (self.entry.eid == nil && self.navigationItem.backBarButtonItem == nil) {
		
		//  left button
		UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
		self.navigationItem.leftBarButtonItem = newLeftButton;
		[newLeftButton release];
	}
	
	// right button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// timestamp label
	
	CGFloat height = 20.0f;
	CGFloat yPos = (kAppHeaderHeight/2) - (height/2);
	UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yPos, 320.0f, height)];
	newTimestampLabel.backgroundColor = [UIColor clearColor];
	newTimestampLabel.textAlignment = UITextAlignmentCenter;
	newTimestampLabel.font = kAppCommonLabelFont;
	
	self.timestampLabel = newTimestampLabel;
	
	[newTimestampLabel release];
	
	// icon
	
	height = 20.0f;
	yPos = (kAppHeaderHeight/2) - (height/2);
	UIImageView *newIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kAppSpacing, yPos, 20.0f, height)];
	newIconImageView.image = [UIImage imageNamed:self.entry.category.icon];
	
	self.iconImageView = newIconImageView;
	
	[newIconImageView release];
	
	// edit button
	
	if (self.entry.eid != nil) {
	
		UIButton *newEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		CGFloat width = 30.0f;
		height = 30.0f;
		CGFloat xPos = 320.0f-kAppSpacing-width;
		yPos = (kAppHeaderHeight/2) - (height/2);
		newEditButton.frame = CGRectMake(xPos, yPos, width, height);
		
		[newEditButton setImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
		
		[newEditButton addTarget:self action:@selector(loadNewEntryViewController) forControlEvents:UIControlEventTouchUpInside];
		 
		self.editButton = newEditButton;
	}
	
	if (self.entry.integer != nil || self.entry.decimal != nil) {
	
		// number label
		
		UILabel *newNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, kAppHeaderHeight, 320.0f, 30.0f)];
		newNumberLabel.backgroundColor = [UIColor clearColor];
		newNumberLabel.textAlignment = UITextAlignmentCenter;
		newNumberLabel.font = kAppLargeLabelFont;
		
		self.numberLabel = newNumberLabel;
		
		[newNumberLabel release];
		
		// unit label
		
		CGFloat yPos = self.numberLabel.frame.origin.y + self.numberLabel.frame.size.height + kAppAdjacentSpacing;
		UILabel *newUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, yPos, 320.0f, 20.0f)];
		newUnitLabel.backgroundColor = [UIColor clearColor];
		newUnitLabel.textAlignment = UITextAlignmentCenter;
		newUnitLabel.font = kAppCommonLabelFont;
		
		self.unitLabel = newUnitLabel;
		
		[newUnitLabel release];
	
	} else {
	
		NSString *datatype = self.entry.category.datatype;
		if ([datatype isEqualToString:@"string"]) {
			
			// text view
		
			UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(kAppSpacing, kAppHeaderHeight, 320.0f-(kAppSpacing*2), 216.0f)];
			newTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
			newTextView.backgroundColor = [UIColor clearColor];
			newTextView.textColor = [UIColor blackColor];
			newTextView.font = [UIFont systemFontOfSize:16.0f];
			newTextView.editable = NO;
			
			self.textView = newTextView;
			[newTextView release];
		
		} else if ([datatype isEqualToString:@"photo"]) {
			
			// image button
			CGFloat width = 150.0f;
			CGFloat height = 150.0f;
			CGFloat xPos = 160.0f - (width/2);
			
			UIButton *newImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
			newImageButton.frame = CGRectMake(xPos, kAppHeaderHeight, width, height);
			newImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
			newImageButton.adjustsImageWhenHighlighted = NO;
			
			[newImageButton addTarget:self action:@selector(loadScrollViewForImage) forControlEvents:UIControlEventTouchUpInside];
			
			self.imageButton = newImageButton;
		}
	}
}

-(void)showUIContent {
	
	// timestamp label
	[self.view addSubview:self.timestampLabel];
	
	// icon image view
	[self.view addSubview:self.iconImageView];
	
	// edit button
	if (self.editButton != nil)
		[self.view addSubview:self.editButton];
	
	// number label
	if (self.numberLabel != nil)
		[self.view addSubview:self.numberLabel];
	
	// unit label
	if (self.unitLabel != nil)
		[self.view addSubview:self.unitLabel];
	
	// text view
	if (self.textView != nil)
		[self.view addSubview:self.textView];
	
	// image view
	if (self.imageButton != nil)
		[self.view addSubview:self.imageButton];
	
	// fill in content
	[self updateUIContent];
}

-(void)updateUIContent {
	
	// timestamp label
	
	self.timestampLabel.text = self.entry.timestampDescription;
	
	// number and unit label
	
	BOOL converted = [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog];

	if (self.numberLabel != nil) {
		
		if (converted)
			self.numberLabel.text = self.entry.convertedShortDescription;
		else
			self.numberLabel.text = self.entry.shortDescription;
	
		if (converted)
			self.unitLabel.text = self.entry.category.unit.abbreviation;
		else 
			self.unitLabel.text = self.entry.unit.abbreviation;
	
	} else if (self.textView != nil) {
	
		self.textView.text = self.entry.string;
	
	} else if (self.imageButton != nil) {
		
		UIImage *image = [UIImage imageWithContentsOfFile:self.entry.filePath];
		[self.imageButton setImage:image forState:UIControlStateNormal];
	}
}

-(void)save {
	
	// save the entry only if it is not already saved (ie has an eid)
	if (self.entry.eid == nil)
		[self.entry save];
	
	// dismiss
	[super dismiss];
}

-(void)createAndDisplayCloseButton {
/*	Creates a close button and adds it to main view. */
	
	// close button
	
	UIButton *newCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *image = [UIImage imageWithContentsOfFile:TKBUNDLE(@"TapkuLibrary.bundle/Images/graph/close.png")];
	
	newCloseButton.frame = CGRectMake(self.view.frame.size.width - 35.0f, 10.0f, image.size.width, image.size.height);
	
	[newCloseButton setImage:image forState:UIControlStateNormal];
	[newCloseButton addTarget:self action:@selector(unloadScrollViewForImage) forControlEvents:UIControlEventTouchUpInside];
	
	self.closeButton = newCloseButton;
	[self.view addSubview:newCloseButton];
}

@end
