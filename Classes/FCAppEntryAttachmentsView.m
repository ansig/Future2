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
//  FCAppEntryAttachmentsView.m
//  Future2
//
//  Created by Anders Sigfridsson on 12/11/2010.
//

#import "FCAppEntryAttachmentsView.h"


@implementation FCAppEntryAttachmentsView

@synthesize tableViewDelegate;
@synthesize entryRef;
@synthesize attachmentButtons, noAttachmentsLabel;
@synthesize tableView, sections, rows;
@synthesize selectedIndex, previouslySelectedIndex;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)anEntry frame:(CGRect)frame {

	if (self = [self initWithFrame:frame]) {
		
		entryRef = anEntry;
		
		self.backgroundColor = [UIColor lightGrayColor];
		
		selectedIndex = -1;
		previouslySelectedIndex = -1;
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		
        // Initialization code
    }
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[attachmentButtons release];
	[noAttachmentsLabel release];
	
	[tableView release];
	
    [super dealloc];
}

#pragma mark Drawing

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark Events

-(void)buttonClicked:(UIButton *)theButton {
	
	// assert that a table view delegate has been set
	BOOL isSet = self.tableViewDelegate != nil ? YES : NO;
	NSAssert1(isSet, @"FCAttachmensView -buttonClicked: || %@", @"Table view delegate reference not set!");
	
	// make sure there is a table view
	
	if (self.tableView == nil) {
	
		CGFloat width = self.frame.size.width;
		CGFloat height = 64.0f;
		
		CGFloat xPos = self.frame.origin.x;
		CGFloat yPos = self.frame.origin.y + self.frame.size.height;
		
		CGRect frame = CGRectMake(xPos, yPos, width, height);
		
		UITableView *newTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
		newTableView.backgroundColor = [UIColor clearColor];
		newTableView.scrollEnabled = NO;
		newTableView.delegate = self.tableViewDelegate;
		newTableView.dataSource = self;
		
		self.tableView = newTableView;
		
		[self.superview addSubview:newTableView];
		
		[newTableView release];
	}
	
	// select attachment
	
	self.previouslySelectedIndex = self.selectedIndex;
	self.selectedIndex = theButton.tag;
	
	// highlight the button
	
	[theButton setBackgroundColor:[UIColor darkGrayColor]];
		
	// un-highlight previous button
	
	if (self.previouslySelectedIndex > -1) {
	
		UIButton *previouslySelectedButton = (UIButton *)[self.attachmentButtons objectAtIndex:self.previouslySelectedIndex];
		[previouslySelectedButton setBackgroundColor:[UIColor clearColor]];
	}
	
	// update the table

	[self performSelector:@selector(updateTableView) withObject:nil afterDelay:0.25f];
}

#pragma mark Get

-(FCEntry *)getSelectedAttachment {

	if (self.selectedIndex > -1)
		return [self.entryRef.attachments objectAtIndex:self.selectedIndex];
	
	return nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
	return self.sections;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	
	return self.rows;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	FCEntry *anEntry = [self.entryRef.attachments objectAtIndex:self.selectedIndex];
	
	// default is to use the entry's own description, but uses converted description
	// if the user has enabled the convert log option
	cell.textLabel.text = [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog] ? anEntry.convertedFullDescription : anEntry.fullDescription;
	
	cell.detailTextLabel.text = anEntry.timeDescription;
	cell.imageView.image = [UIImage imageNamed:anEntry.category.icon];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// remove the row/section
	
	self.sections--;
	self.rows--;
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	
	// remove the attachment
	
	FCEntry *attachment = [self.entryRef.attachments objectAtIndex:self.selectedIndex];
	[self.entryRef removeAttachment:attachment andDelete:YES];
	
	// deselect button and reset selectedIndex and previouslySelectedIndex
	
	UIButton *selectedButton = (UIButton *)[self.attachmentButtons objectAtIndex:self.selectedIndex];
	[selectedButton setBackgroundColor:[UIColor clearColor]];
	
	self.selectedIndex = -1;
	self.previouslySelectedIndex = -1;
	
	// reload
	
	[self loadAttachments];
}

#pragma mark Custom

-(void)loadAttachments {
	
	// unload any present attachment buttons or the no attachments label
	
	if (self.attachmentButtons != nil) {
	
		for (UIButton *button in self.attachmentButtons)
			[button removeFromSuperview];
		
		self.attachmentButtons = nil;
	}
	
	if (self.noAttachmentsLabel != nil) {
	
		[self.noAttachmentsLabel removeFromSuperview];
		self.noAttachmentsLabel = nil;
	}
	
	// create a new attachment buttons array
	
	NSMutableArray *newAttachmentButtons = [[NSMutableArray alloc] init];
	self.attachmentButtons = newAttachmentButtons;
	[newAttachmentButtons release];

	// make sure the entry has its attachments loaded
	
	if (self.entryRef.attachments == nil)
		[self.entryRef loadAttachments];
	
	// create new buttons and add to attachment buttons array and
	// as subviews to scroll view
	
	CGFloat width = 30.0f;
	CGFloat height = 30.0f;
	
	CGFloat spacing = 10.0f;
	
	NSInteger i = 0;
	for (FCEntry *attachment in self.entryRef.attachments) {
	
		UIButton *newAttachmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		newAttachmentButton.tag = i;
		
		UIImage *icon = [UIImage imageNamed:attachment.category.icon];
		[newAttachmentButton setImage:icon forState:UIControlStateNormal];
		
		CGFloat xPos = spacing + ((spacing + width) * i);
		CGFloat yPos = (self.frame.size.height/2) - (height/2);
		
		newAttachmentButton.frame = CGRectMake(xPos, yPos, width, height);
		
		[newAttachmentButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.attachmentButtons addObject:newAttachmentButton];
		[self addSubview:newAttachmentButton];
		
		i++;
	}
	
	NSInteger total = [self.entryRef.attachments count];
	
	if (total == 0) {
		
		// no attachments label
		
		UILabel *newNoAttachmentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(spacing, 0.0f, 320.0f-(spacing*2), height)];
		newNoAttachmentsLabel.backgroundColor = [UIColor clearColor];
		newNoAttachmentsLabel.textColor = [UIColor whiteColor];
		newNoAttachmentsLabel.font = [UIFont systemFontOfSize:12.0f];
		
		newNoAttachmentsLabel.text = @"No attachments.";
		
		self.noAttachmentsLabel = newNoAttachmentsLabel;
		[self addSubview:newNoAttachmentsLabel];
		
		[newNoAttachmentsLabel release];
	
	} else {
	
		// setup scrolling
	
		self.contentSize = CGSizeMake((width + spacing) * total, self.frame.size.height);
		
		[self performSelector:@selector(flashScrollIndicators) withObject:nil afterDelay:kPerceptionDelay];
	
		// make sure selected button is still highlighted
		
		 if (self.selectedIndex > -1) {
		 
			 UIButton *selectedButton = (UIButton *)[self viewWithTag:self.selectedIndex];
			 [selectedButton setBackgroundColor:[UIColor darkGrayColor]];
		 }
	}
}

-(void)updateTableView {

	NSUInteger arrayLength = 2;
	NSUInteger integerArray[] = {0, 0};
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:integerArray length:arrayLength];
	
	if (self.sections == 0) {
		
		// animate appearance from top
		self.sections++;
		self.rows++;
		
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
		
	} else if (self.selectedIndex == self.previouslySelectedIndex) {
		
		// animate dissapearance upward
		self.sections--;
		self.rows--;
		
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
		
		// CHEAT
		self.selectedIndex = -1;
		self.previouslySelectedIndex = -1;
	
	} else if (self.selectedIndex > self.previouslySelectedIndex) {
	
		// replace row right->left
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		
	} else if (self.selectedIndex < self.previouslySelectedIndex) {
		
		// replace row left->right
		[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	}
}

@end
