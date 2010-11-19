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
//  FCAppCategoryViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 17/11/2010.
//

#import "FCAppCategoryViewController.h"


@implementation FCAppCategoryViewController

@synthesize category;
@synthesize sections;
@synthesize tableView;
@synthesize nameTextField, countableSwitch;
@synthesize minimumTextField, maximumTextField, decimalsSegmentedControl, unitButton;
@synthesize beingEdited;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
	
		if (self.category == nil) {
		
			// create empty category for saving
			category = [[FCCategory alloc] init];
		}
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
	
	[category release];
	
	[tableView release];
	
	[sections release];
	
	[nameTextField release];
	[countableSwitch release];
	
	[minimumTextField release];
	[maximumTextField release];
	[decimalsSegmentedControl release];
	[unitButton release];
	
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
	
    [super viewDidUnload];
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

#pragma mark FCAppOverlayViewController

-(void)createUIContent {
	
	// * Navigation buttons
	
	//  left button
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = newLeftButton;
	[newLeftButton release];
	
	// right button
	UIBarButtonItem *newRightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = newRightButton;
	[newRightButton release];
	
	// * Control objects
	
	// name text field
	
	UITextField *newNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 22.0f)];
	newNameTextField.delegate = self;
	newNameTextField.placeholder = @"Click to enter name";
	newNameTextField.textAlignment = UITextAlignmentRight;
	newNameTextField.font = [UIFont boldSystemFontOfSize:18.0f];
	
	self.nameTextField = newNameTextField;
	
	[newNameTextField release];
	
	// countable switch
	
	UISwitch *newCountableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 27.0f)];
	
	[newCountableSwitch addTarget:self action:@selector(countableSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
	
	self.countableSwitch = newCountableSwitch;
	
	[newCountableSwitch release];
	
	// minimum text field
	
	UITextField *newMinimumTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 22.0f)];
	newMinimumTextField.delegate = self;
	newMinimumTextField.placeholder = @"1";
	newMinimumTextField.textAlignment = UITextAlignmentRight;
	newMinimumTextField.font = [UIFont boldSystemFontOfSize:18.0f];
	
	self.minimumTextField = newMinimumTextField;
	
	[newMinimumTextField release];
	
	// maximum text field
	
	UITextField *newMaximumTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 22.0f)];
	newMaximumTextField.delegate = self;
	newMaximumTextField.placeholder = @"10";
	newMaximumTextField.textAlignment = UITextAlignmentRight;
	newMaximumTextField.font = [UIFont boldSystemFontOfSize:18.0f];
	
	self.maximumTextField = newMaximumTextField;
	
	[newMaximumTextField release];
	
	// decimals segmented control
	
	UISegmentedControl *newDecimalsSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"1", @"1.0", @"1.00", @"1.000", nil]];
	newDecimalsSegmentedControl.frame = CGRectMake(0.0f, 0.0f, 220.0f, 27.0f);
	newDecimalsSegmentedControl.selectedSegmentIndex = 0;
	
	self.decimalsSegmentedControl = newDecimalsSegmentedControl;
	
	[newDecimalsSegmentedControl release];
	
	// unit button
	
	UIButton *newUnitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newUnitButton.frame = CGRectMake(0.0f, 0.0f, 220.0f, 22.0f);
	
	[newUnitButton addTarget:self action:@selector(unitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	UILabel *buttonLabel = [[UILabel alloc] initWithFrame:newUnitButton.bounds];
	buttonLabel.textAlignment = UITextAlignmentRight;
	buttonLabel.textColor = [UIColor lightGrayColor];
	buttonLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	
	buttonLabel.text = @"Click to select unit";
	
	[newUnitButton addSubview:buttonLabel];
	
	self.unitButton = newUnitButton;
	
	// * Table view
	
	[self loadSectionsAndRows];
	
	UITableView *newTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 416.0f) style:UITableViewStyleGrouped];
	newTableView.backgroundColor = [UIColor clearColor];
	newTableView.delegate = self;
	newTableView.dataSource = self;
	
	self.tableView = newTableView;
	
	[newTableView release];
}

-(void)presentUIContent {
	
	// show naviation controller
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// animate table view appearance
	CGFloat verticalOffset = self.view.frame.size.height - self.tableView.frame.origin.x;
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
	
	self.tableView.transform = translation;
	
	[self.view addSubview:self.tableView];
	
	[UIView animateWithDuration:kAppearDuration 
					 animations:^ { self.tableView.transform = CGAffineTransformIdentity; } ];
}

-(void)updateUIContent {
	
	// sets or updates the content of ui elements (e.g. text in UILabels, images in UIImageViews, etc)
}

-(void)dismissUIContent {
	
	CGFloat verticalOffset = self.view.frame.size.height - self.tableView.frame.origin.x;
	CGAffineTransform translation = CGAffineTransformMakeTranslation(0.0f, verticalOffset);
	
	[UIView animateWithDuration:kDisappearDuration 
					 animations:^ { self.tableView.transform = translation; } 
					 completion:^ (BOOL finished) { [self.tableView removeFromSuperview]; } ];
}

#pragma mark FCGroupedTableSourceDelegate

-(void)loadSectionsAndRows {
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"ControlObject", nil];
	NSArray *objects;
	
	// name
	
	objects = [[NSArray alloc] initWithObjects:@"Name", self.nameTextField, nil];
	NSDictionary *namePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// type
	
	objects = [[NSArray alloc] initWithObjects:@"Countable", self.countableSwitch, nil];
	NSDictionary *countablePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// compose the section
	
	NSMutableArray *basicSection = [[NSMutableArray alloc] initWithObjects:namePair, countablePair, nil];
	
	[namePair release];
	[keys release];
	
	[newSections addObject:basicSection];
	
	self.sections = newSections;
	[newSections release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		// title label
		UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 12.0f, 100.0f, 20.0f)];
		leftLabel.tag = 1;
		leftLabel.font = [UIFont systemFontOfSize:14.0f];
		[cell addSubview:leftLabel];
		[leftLabel release];
	}
	
	NSDictionary *item = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	// title
	UILabel *theLeftLabel = (UILabel *)[cell viewWithTag:1];
	theLeftLabel.text = [item objectForKey:@"Title"];
	
	// control object
	//id controlObject = [item objectForKey:@"ControlObject"];
	
	cell.accessoryView = [item objectForKey:@"ControlObject"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	if (!self.beingEdited)
		return YES;
	
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	// enter edit mode
	
	self.beingEdited = YES;
	
	self.navigationItem.leftBarButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.countableSwitch.enabled = NO;
	self.decimalsSegmentedControl.enabled = NO;
	self.unitButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	// exit edit mode
	
	self.beingEdited = NO;
	
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.countableSwitch.enabled = YES;
	self.decimalsSegmentedControl.enabled = YES;
	self.unitButton.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark Events

-(void)countableSwitchValueChanged {
	
	if (self.countableSwitch.on) {
	
		// * Create new rows and add to section
		
		NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"ControlObject", nil];
		NSArray *objects;
		
		// minimum
		
		objects = [[NSArray alloc] initWithObjects:@"Minimum", self.minimumTextField, nil];
		NSDictionary *minimumPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		[[self.sections objectAtIndex:0] addObject:minimumPair];
		
		[minimumPair release];
		
		// maximum
		
		objects = [[NSArray alloc] initWithObjects:@"Maximum", self.maximumTextField, nil];
		NSDictionary *maximumPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		[[self.sections objectAtIndex:0] addObject:maximumPair];
		
		[maximumPair release];
		
		// decimals
		
		objects = [[NSArray alloc] initWithObjects:@"Decimals", self.decimalsSegmentedControl, nil];
		NSDictionary *decimalsPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		[[self.sections objectAtIndex:0] addObject:decimalsPair];
		
		[decimalsPair release];
		
		// unit
		
		objects = [[NSArray alloc] initWithObjects:@"Unit", self.unitButton, nil];
		NSDictionary *unitPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		[[self.sections objectAtIndex:0] addObject:unitPair];
		
		[unitPair release];
		
		[keys release];
		
		// update table
		
		NSArray *insertIndexPaths = [NSArray arrayWithObjects:	
									 [NSIndexPath indexPathForRow:2 inSection:0],
									 [NSIndexPath indexPathForRow:3 inSection:0],
									 [NSIndexPath indexPathForRow:4 inSection:0],
									 [NSIndexPath indexPathForRow:5 inSection:0],
									 nil];
		
		[self.tableView beginUpdates];
		
		[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
		
		[self.tableView endUpdates];
		
	} else {
		
		// * Remove four lower rows from section
		
		[[self.sections objectAtIndex:0] removeObjectAtIndex:2];
		[[self.sections objectAtIndex:0] removeObjectAtIndex:2];
		[[self.sections objectAtIndex:0] removeObjectAtIndex:2];
		[[self.sections objectAtIndex:0] removeObjectAtIndex:2];
		
		NSArray *deleteIndexPaths = [NSArray arrayWithObjects:	
									 [NSIndexPath indexPathForRow:2 inSection:0],
									 [NSIndexPath indexPathForRow:3 inSection:0],
									 [NSIndexPath indexPathForRow:4 inSection:0],
									 [NSIndexPath indexPathForRow:5 inSection:0],
									 nil];
		
		[self.tableView beginUpdates];
		
		[self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
		
		[self.tableView endUpdates];
	}
}

-(void)unitButtonPressed {

	NSLog(@"Unit button pressed!");
}

#pragma mark Custom

-(void)save {
	
	// * Set all category's properties from filled in form
	
	// name
	
	self.category.name = self.nameTextField.text;
	
	// icon
	
	self.category.iid = @"system_0_4"; // TMP
	
	if (self.countableSwitch.on) {
	
		// minium
		
		NSString *minimumString = self.minimumTextField.text != nil ? self.minimumTextField.text : self.minimumTextField.placeholder;
		NSNumber *minimum = [[NSNumber alloc] initWithInteger:[minimumString integerValue]];
		self.category.minimum = minimum;
		[minimum release];
		
		// maximum
		
		NSString *maximumString = self.maximumTextField.text != nil ? self.maximumTextField.text : self.maximumTextField.placeholder;
		NSNumber *maximum = [[NSNumber alloc] initWithInteger:[maximumString integerValue]];
		self.category.maximum = maximum;
		[maximum release];
		
		// decimals
		
		if (self.decimalsSegmentedControl.selectedSegmentIndex > 0) {
		
			NSNumber *decimals = [[NSNumber alloc] initWithInteger:self.decimalsSegmentedControl.selectedSegmentIndex];
			self.category.decimals = decimals;
			[decimals release];
		}
	}
	
	// datatype (only if not already set)
	
	if (self.category.datatype == nil) {
		
		if (self.countableSwitch.on && self.decimalsSegmentedControl.selectedSegmentIndex > 0)
			self.category.did = FCKeyDIDDecimal;
		
		else if (self.countableSwitch.on && self.decimalsSegmentedControl.selectedSegmentIndex == 0)
			self.category.did = FCKeyDIDInteger;
	}
	
	// * Save the category
	
	[self.category save];
	
	// dismiss
	[self dismiss];
}

-(void)cancel {
	
	// dismiss
	[self dismiss];
}

@end
