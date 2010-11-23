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
@synthesize attachmentsView;
@synthesize tableView, sectionTitles, sections;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)theEntry {
	
	if (self = [super init]) {
		
		entry = [theEntry retain];
		
		// start listening to certain notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEntryUpdatedNotification) name:FCNotificationEntryUpdated object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAttachmentAddedNotification) name:FCNotificationAttachmentAdded object:nil];
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
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
	
	[attachmentsView release];
	
	[tableView release];
	[sectionTitles release];
	[sections release];
	
    [super dealloc];
}

#pragma mark View

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	// overrides supers method because a scroll view is needed
	
	// * Main view
	
	UIScrollView *newView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f)];
	
	if (self.isOpaque)
		newView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	
	else
		newView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
	
	self.view = newView;
	[newView release];
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

-(void)loadNewEntryViewController {
	
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
	
	// update the attachments view table
	if (self.attachmentsView != nil && self.attachmentsView.tableView != nil) {
		
		[self.attachmentsView.tableView reloadData];
	}
}

-(void)onAttachmentAddedNotification {
	
	if (self.attachmentsView != nil) {
		
		// update the attachments view
		[self.attachmentsView loadAttachments];
		
		// make sure we are visible in superview
		UIScrollView *mainScrollView = (UIScrollView *)self.view;
		[mainScrollView scrollRectToVisible:self.view.frame animated:YES];
		
		// flag the new attachment
		[self.attachmentsView performSelector:@selector(flagLatestAttachment) withObject:nil afterDelay:kPerceptionDelay];
	}
}

-(void)onAttachmentRemovedNotification {
	
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
	
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	// release any present sections and section titles arrays
	if (self.sectionTitles != nil)
		self.sectionTitles = nil;
	
	if (self.sections != nil)
		self.sections = nil;
	
	// get the owners for which we want to retrieve categories
	
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	NSString *table = @"owners";
	NSString *columns = @"oid, name";
	NSString *filters = @"oid IS NOT 'system_0_1'"; // we do not want the Glucose category to appear here
	
	NSArray *owners = [dbh getColumns:columns fromTable:table withFilters:filters];
	
	[dbh release];
	
	// create new sections and section titles arrays
	
	NSMutableArray *newSectionTitles = [[NSMutableArray alloc] init];
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	// loop through the retrieved owners
	for (NSDictionary *owner in owners) {
		
		// add owners name to tiles
		[newSectionTitles addObject:[owner objectForKey:@"name"]];
		
		// retrieve the owners categories
		NSArray *categories = [FCCategory allCategoriesWithOwner:[owner objectForKey:@"oid"]];
		
		// add as new section
		NSMutableArray *section = [[NSMutableArray alloc] initWithArray:categories];
		[newSections addObject:section];
		[section release];
	}
	
	// store new section titles and sections
	
	self.sectionTitles = newSectionTitles;
	[newSectionTitles release];
	
	self.sections = newSections;
	[newSections release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	
	FCCategory *aCategory = [[self.sections objectAtIndex:section] objectAtIndex:row];
	
	cell.textLabel.text = aCategory.name;
	cell.imageView.image = [UIImage imageNamed:aCategory.icon];
	
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// deselect row
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (aTableView.tag == 1) {
		
		// load new entry view controller to make an attachment
		
		NSInteger section = indexPath.section;
		NSInteger row = indexPath.row;
		
		FCCategory *aCategory = [[self.sections objectAtIndex:section] objectAtIndex:row];
		
		FCAppNewEntryViewController *newEntryViewController = [[FCAppNewEntryViewController alloc] initWithCategory:aCategory owner:self.entry];
		newEntryViewController.title = aCategory.name;
		newEntryViewController.shouldAnimateContent = YES;
		
		[self presentOverlayViewController:newEntryViewController];
		
		[newEntryViewController release];
		
	} else {
	
		// load entry view controller for the attachment
		
		FCEntry *attachment = [self.attachmentsView getSelectedAttachment];
		
		FCAppEntryViewController *entryViewController = [[FCAppEntryViewController alloc] initWithEntry:attachment];
		entryViewController.isOpaque = YES;
		entryViewController.title = attachment.category.name;
		[entryViewController createUIContent];
		[entryViewController showUIContent];
		
		[self.navigationController pushViewController:entryViewController animated:YES];
		
		[entryViewController release];
	}
}

#pragma mark Custom

-(void)createUIContent {
	
	if (self.entry.eid == nil && self.entry.owner == nil) {
		
		//  left button
		UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
		self.navigationItem.leftBarButtonItem = newLeftButton;
		[newLeftButton release];
	}
	
	if (self.entry.owner == nil) {
	
		// right button
		UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
		self.navigationItem.rightBarButtonItem = newRightButton;
		[newRightButton release];
	}
	
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
			
			NSString *string = self.entry.string;
			UIFont *font = [UIFont systemFontOfSize:16.0f];
			
			CGSize maximumSize = CGSizeMake(320.0f-(kAppSpacing*2), 150.0f);
			CGSize size = [string sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
		
			UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(kAppSpacing, kAppHeaderHeight, maximumSize.width, size.height+20)];
			newTextView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
			newTextView.backgroundColor = [UIColor clearColor];
			newTextView.textColor = [UIColor blackColor];
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
	
	if (self.entry.owner == nil) {
	
		// attachments view
		
		if (self.unitLabel != nil) {
			
			yPos = self.unitLabel.frame.origin.y + self.unitLabel.frame.size.height + kAppSpacing;
			
		} else if (self.textView != nil) {	
			
			yPos = self.textView.frame.origin.y + self.textView.frame.size.height + kAppSpacing;
			
		} else if (self.imageButton != nil) {
			
			yPos = self.imageButton.frame.origin.y + self.imageButton.frame.size.height + kAppSpacing;
		
		} else if (self.timestampLabel != nil) {
		
			yPos = self.timestampLabel.frame.origin.y + self.timestampLabel.frame.size.height + kAppSpacing;
		}
		
		CGRect frame = CGRectMake(0.0f, yPos, 320.0f, 30.0f);
		FCAppEntryAttachmentsView *newAttachmentsView = [[FCAppEntryAttachmentsView alloc] initWithEntry:self.entry frame:frame];
		newAttachmentsView.tableViewDelegate = self;
		[newAttachmentsView loadAttachments];
		
		self.attachmentsView = newAttachmentsView;
		
		[newAttachmentsView release];
		
		// attachments table
		
		[self loadSectionsAndRows];
		
		UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.0f) style:UITableViewStyleGrouped];
		newTableView.backgroundColor = [UIColor clearColor];
		newTableView.tag = 1;
		newTableView.scrollEnabled = NO;
		newTableView.delegate = self;
		newTableView.dataSource = self;
		
		self.tableView = newTableView;
		
		[newTableView release];
		
		UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
		tableHeaderView.backgroundColor = [UIColor lightGrayColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 30.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor whiteColor];
		label.text = @"Available attachments:";
		
		[tableHeaderView addSubview:label];
		
		[label release];
		
		self.tableView.tableHeaderView = tableHeaderView;
		
		[tableHeaderView release];
		
		[self setNewFrameForTableView];
		
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
	
	// attachments view
	if (self.attachmentsView != nil)
		[self.view addSubview:self.attachmentsView];
	
	// table view
	if (self.tableView != nil)
		[self.view addSubview:self.tableView];
	
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
		
		// text label
		
		NSString *string = self.entry.string;
		UIFont *font = [UIFont systemFontOfSize:16.0f];
		
		CGSize maximumSize = CGSizeMake(320.0f-(kAppSpacing*2), 150.0f);
		CGSize size = [string sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:UILineBreakModeWordWrap];
		
		CGRect newFrame = CGRectMake(kAppSpacing, kAppHeaderHeight, maximumSize.width, size.height+20);
		
		self.textView.frame = newFrame;
	
		self.textView.font = font;
		self.textView.text = string;
		
		if (self.attachmentsView != nil && self.tableView != nil) {
		
			// attachments view
			
			CGFloat yPos = self.textView.frame.origin.y + self.textView.frame.size.height + kAppSpacing;
			self.attachmentsView.frame = CGRectMake(0.0f, yPos, 320.0f, 30.0f);
			
			// table view
			
			[self setNewFrameForTableView];
		}
	
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

-(void)setNewFrameForTableView {
/*	Calculates the correct position and size for the table view
	and its current content, then creates and sets a new frame for it. */
	
	// calculate position and size
	
	CGFloat yPos = self.attachmentsView.frame.origin.y + self.attachmentsView.frame.size.height + 64.0f;
	
	CGFloat height = self.tableView.contentSize.height;
	
	// set new frame
	
	CGRect newFrame = CGRectMake(0.0f, yPos, 320.0f, height);
	
	self.tableView.frame = newFrame;
	
	// also update the scroll view settings
	
	UIScrollView *mainScrollView = (UIScrollView *)self.view;
	mainScrollView.contentSize = CGSizeMake(320.0f, yPos + height);
}

@end
