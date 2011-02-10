/*
 
 TiY (tm) - an iPhone app that supports self-management of type 1 diabetes
 Copyright (C) 2010  Interaction Design Centre (University of Limerick, Ireland)
 
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

@synthesize category, originalCategory;
@synthesize sections;
@synthesize tableView;
@synthesize nameTextField, colorButton, iconButton, countableSwitch;
@synthesize minimumTextField, maximumTextField, decimalsSegmentedControl, unitButton;
@synthesize beingEdited;

#pragma mark Init

-(id)initWithCategory:(FCCategory *)theCategory {

	if (self = [self init]) {
		
		if (category != nil)
			[category release];
		
		category = [theCategory copy];
		originalCategory = [theCategory retain];
	}
	
	return self;
}

-(id)init {
	
	if (self = [super init]) {
	
		// create empty category for saving
		category = [[FCCategory alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCategoryObjectUpdatedNotification) name:FCNotificationCategoryObjectUpdated object:nil];
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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[category release];
	[originalCategory release];
	
	[tableView release];
	
	[sections release];
	
	[nameTextField release];
	[colorButton release];
	[iconButton release];
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

-(void)loadIconSeclectionViewController {
	
	[self setCategoryProperties]; // ensures any changes are retained
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.shouldAnimateContent = YES;
	
	selectorViewController.title = @"Icon";
	selectorViewController.propertyToSelect = FCPropertyIcon;
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadColorSelectionViewController {
	
	[self setCategoryProperties]; // ensures any changes are retained
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.shouldAnimateContent = YES;
	
	selectorViewController.title = @"Color";
	selectorViewController.propertyToSelect = FCPropertyColor;
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadUnitQuantitySelectionViewController {
	
	[self setCategoryProperties]; // ensures any changes are retained
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.shouldAnimateContent = YES;
	
	selectorViewController.title = @"Quantity";
	selectorViewController.propertyToSelect = FCPropertyUnitQuantity;
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadUnitSystemSelectionViewController {
	
	[self setCategoryProperties]; // ensures any changes are retained
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.shouldAnimateContent = YES;
	
	FCUnit *unit = self.category.unit;
	selectorViewController.quantity = unit.quantity;
	
	selectorViewController.propertyToSelect = FCPropertyUnitSystem;
	
	selectorViewController.title = @"System";
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)loadUnitSelectionViewController {
	
	[self setCategoryProperties]; // ensures any changes are retained
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.shouldAnimateContent = YES;
	
	FCUnit *unit = self.category.unit;
	
	selectorViewController.system = unit.system;
	selectorViewController.quantity = unit.quantity;
	selectorViewController.propertyToSelect = FCPropertyUnit;
	
	selectorViewController.title = FCUnitQuantityAsString(unit.quantity);
	
	[self presentOverlayViewController:selectorViewController];
	
	[selectorViewController release];
}

-(void)pushUnitSelectionViewController {
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.parent = self;
	selectorViewController.shouldAnimateContent = YES;
	
	FCUnit *unit = self.category.unit;
	
	selectorViewController.system = unit.system;
	selectorViewController.quantity = unit.quantity;
	selectorViewController.propertyToSelect = FCPropertyUnit;
	
	selectorViewController.title = FCUnitQuantityAsString(unit.quantity);
	
	[selectorViewController createUIContent];
	[selectorViewController showUIContent];
	
	[self.overlaidNavigationController pushViewController:selectorViewController animated:YES];
	
	[selectorViewController release];
}

-(void)pushUnitSystemSelectionViewController {
	
	FCAppPropertySelectorViewController *selectorViewController = [[FCAppPropertySelectorViewController alloc] initWithCategory:self.category];
	selectorViewController.parent = self;
	
	FCUnit *unit = self.category.unit;
	selectorViewController.quantity = unit.quantity;
	
	selectorViewController.propertyToSelect = FCPropertyUnitSystem;
	
	selectorViewController.title = @"System";
	
	[selectorViewController createUIContent];
	[selectorViewController showUIContent];
	
	[self.overlaidNavigationController pushViewController:selectorViewController animated:YES];
	
	[selectorViewController release];
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
	UIBarButtonItem *newLeftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
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
	
	// icon button
	
	UIButton *newIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newIconButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
	
	[newIconButton setImage:[UIImage imageNamed:@"wrench1Icon.png"] forState:UIControlStateNormal];
	
	[newIconButton addTarget:self action:@selector(iconButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
	self.iconButton	= newIconButton;
	
	// color button
	
	UIButton *newColorButton = [UIButton buttonWithType:UIButtonTypeCustom];
	newColorButton.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
	
	[newColorButton addTarget:self action:@selector(colorButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		
	FCBorderedLabel *colorButtonLabel = [[FCBorderedLabel alloc] initWithFrame:newColorButton.bounds];
	colorButtonLabel.tag = 1;
	
	colorButtonLabel.backgroundColor = [[FCColorCollection sharedColorCollection] colorForIndex:0];
	
	[newColorButton addSubview:colorButtonLabel];
	
	self.colorButton = newColorButton;
	
	// countable switch
	
	UISwitch *newCountableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 94.0f, 27.0f)];
	
	[newCountableSwitch addTarget:self action:@selector(countableSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
	
	self.countableSwitch = newCountableSwitch;
	
	[newCountableSwitch release];
	
	// minimum text field
	
	UITextField *newMinimumTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 22.0f)];
	newMinimumTextField.delegate = self;
	newMinimumTextField.placeholder = @"1";
	[newMinimumTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	newMinimumTextField.textAlignment = UITextAlignmentRight;
	newMinimumTextField.font = [UIFont boldSystemFontOfSize:18.0f];
	
	self.minimumTextField = newMinimumTextField;
	
	[newMinimumTextField release];
	
	// maximum text field
	
	UITextField *newMaximumTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 220.0f, 22.0f)];
	newMaximumTextField.delegate = self;
	newMaximumTextField.placeholder = @"10";
	[newMaximumTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
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
	
	UILabel *unitButtonLabel = [[UILabel alloc] initWithFrame:newUnitButton.bounds];
	unitButtonLabel.tag = 1;
	unitButtonLabel.textAlignment = UITextAlignmentRight;
	unitButtonLabel.textColor = [UIColor lightGrayColor];
	unitButtonLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	
	unitButtonLabel.text = @"Click to select unit";
	
	[newUnitButton addSubview:unitButtonLabel];
	
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
	
	if (self.category.uid != nil) {
	
		FCUnit *unit = self.category.unit;
		
		UILabel *buttonLabel = (UILabel *)[self.unitButton viewWithTag:1];
		buttonLabel.textColor = [UIColor blackColor];
		buttonLabel.text = unit.name;
	
	} else if (self.category.uid == nil) {
	
		UILabel *buttonLabel = (UILabel *)[self.unitButton viewWithTag:1];
		buttonLabel.textColor = [UIColor lightGrayColor];
		buttonLabel.text = @"Click to select unit";
	}
	
	if (self.category.colorIndex != nil) {
		
		NSInteger colorIndex = [self.category.colorIndex integerValue];
		UILabel *label = (UILabel *)[self.colorButton viewWithTag:1];
		[label setBackgroundColor:[[FCColorCollection sharedColorCollection] colorForIndex:colorIndex]];
	}
	
	if (self.category.iid != nil) {
		
		UIImage *icon = self.category.icon;
		[self.iconButton setImage:icon forState:UIControlStateNormal];
	}
	
	if (self.category.cid != nil) {
		
		self.nameTextField.text = self.category.name;
		
		if (self.category.minimum != nil && self.category.maximum != nil) {
			
			self.countableSwitch.on = YES;
			
			self.minimumTextField.text = [self.category.minimum stringValue];
			self.maximumTextField.text = [self.category.maximum stringValue];
			self.decimalsSegmentedControl.selectedSegmentIndex = [self.category.decimals integerValue];
		}
	}
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
	
	if (self.category.cid == nil)
		[self loadSectionsAndRowsForNewCategory];
	
	else
		[self loadSectionsAndRowsForExistingCategory];
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
	
	cell.accessoryView = [item objectForKey:@"ControlObject"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark FCCategoryView

-(void)onCategoryCreatedNotification {
	
}

-(void)onCategoryUpdatedNotification {
	
}

-(void)onCategoryObjectUpdatedNotification {
	
	[self updateUIContent];
}

-(void)onCategoryDeletedNotification {
	
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
	self.iconButton.enabled = NO;
	self.colorButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField == self.minimumTextField || textField == self.maximumTextField) {
	
		self.minimumTextField.text = [self.minimumTextField.text numberString];
		self.maximumTextField.text = [self.maximumTextField.text numberString];
		
		[self ensureMinMaxRelationship];
	}
	
	// exit edit mode
	
	self.beingEdited = NO;
	
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	self.countableSwitch.enabled = YES;
	self.decimalsSegmentedControl.enabled = YES;
	self.unitButton.enabled = YES;
	self.iconButton.enabled = YES;
	self.colorButton.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

#pragma mark Events

-(void)countableSwitchValueChanged {
	
	if (self.countableSwitch.on) {
	
		// create new rows and add to section
		
		[self createCountableRows];
		
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

	if (self.category.cid == nil) {
	
		[self loadUnitQuantitySelectionViewController];
		
		if (self.category.uid != nil) {
			
			FCUnit *unit = self.category.unit;
			if (unit.quantity == FCUnitQuantityWeight || unit.quantity == FCUnitQuantityLength || unit.quantity == FCUnitQuantityVolume) {
				
				[self performSelector:@selector(pushUnitSystemSelectionViewController) withObject:nil afterDelay:kViewAppearDuration+kAppearDuration];
				[self performSelector:@selector(pushUnitSelectionViewController) withObject:nil afterDelay:kViewAppearDuration+kAppearDuration+0.5f];
				
			} else {
				
				[self performSelector:@selector(pushUnitSelectionViewController) withObject:nil afterDelay:kViewAppearDuration+kAppearDuration];
			}
		}
	
	} else if (self.category.uid == nil) {
		
		[self loadUnitQuantitySelectionViewController];
		
	} else {
		
		FCUnit *unit = self.category.unit;
		if (unit.quantity == FCUnitQuantityWeight || unit.quantity == FCUnitQuantityLength || unit.quantity == FCUnitQuantityVolume) {
			
			[self loadUnitSystemSelectionViewController];
			
			[self performSelector:@selector(pushUnitSelectionViewController) withObject:nil afterDelay:kViewAppearDuration+kAppearDuration];
			
		} else {
			
			[self loadUnitSelectionViewController];
		}
	}

}

-(void)iconButtonPressed {

	[self loadIconSeclectionViewController];
}

-(void)colorButtonPressed {
	
	[self loadColorSelectionViewController];
}

#pragma mark Custom

-(void)save {
	
	if (self.nameTextField.text != nil && [self.nameTextField.text length] > 0) {
	
		[self setCategoryProperties];
	
		[self.category save];
	
		[self dismiss];
		
	} else {
		
		[self displayNameAlert];
	}
}

-(void)cancel {
	
	[self dismiss];
}

-(void)displayNameAlert {
	
	NSString *title = @"Name your tag!";
	NSString *message = @"Please enter a name for your tag.";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];	
	[alert show];
	
	[alert release];
}

-(void)setCategoryProperties {
/*	Sets all category's properties taken from filled in form. */
	
	// name
	
	if (self.nameTextField.text != nil)
		self.nameTextField.text = [self.nameTextField.text sqlite3String];
	
	self.category.name = self.nameTextField.text;
	
	// icon
	
	if (self.category.iid == nil)
		self.category.iid = @"system_0_49"; // default = wrench1Icon.png
	
	// color
	
	if (self.category.colorIndex == nil) {
	
		NSNumber *color = [[NSNumber alloc] initWithInteger:0];
		self.category.colorIndex = color;
		[color release];
	}
	
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
	
	// datatype
	
	if (self.countableSwitch.on && self.decimalsSegmentedControl.selectedSegmentIndex > 0)
		self.category.did = FCKeyDIDDecimal;
	
	else if (self.countableSwitch.on && self.decimalsSegmentedControl.selectedSegmentIndex == 0)
		self.category.did = FCKeyDIDInteger;
}

-(void)ensureMinMaxRelationship {

	NSInteger minimum = [self.minimumTextField.text integerValue];
	NSInteger maximum = [self.maximumTextField.text integerValue];
	
	if (minimum > maximum) {
		
		maximum = minimum + 10;
		self.maximumTextField.text = [NSString stringWithFormat:@"%d", maximum];
	}
}

-(void)loadSectionsAndRowsForNewCategory {
	
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
	
	// icon
	
	objects = [[NSArray alloc] initWithObjects:@"Icon", self.iconButton, nil];
	NSDictionary *iconPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// color
	
	objects = [[NSArray alloc] initWithObjects:@"Color", self.colorButton, nil];
	NSDictionary *colorPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// compose the section
	
	NSMutableArray *basicSection = [[NSMutableArray alloc] initWithObjects:namePair, countablePair, iconPair, colorPair, nil];
	
	[iconPair release];
	[colorPair release];
	[countablePair release];
	[namePair release];
	
	[keys release];
	
	[newSections addObject:basicSection];
	[basicSection release];
	
	self.sections = newSections;
	[newSections release];
}

-(void)loadSectionsAndRowsForExistingCategory {
	
	NSMutableArray *newSections = [[NSMutableArray alloc] init];
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"ControlObject", nil];
	NSArray *objects;
	
	// name
	
	objects = [[NSArray alloc] initWithObjects:@"Name", self.nameTextField, nil];
	NSDictionary *namePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// icon
	
	objects = [[NSArray alloc] initWithObjects:@"Icon", self.iconButton, nil];
	NSDictionary *iconPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// color
	
	objects = [[NSArray alloc] initWithObjects:@"Color", self.colorButton, nil];
	NSDictionary *colorPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	// compose the section
	
	NSMutableArray *basicSection = [[NSMutableArray alloc] initWithObjects:namePair, iconPair, colorPair, nil];
	
	[iconPair release];
	[colorPair release];
	[namePair release];
	[keys release];
	
	[newSections addObject:basicSection];
	
	[basicSection release];
	
	self.sections = newSections;
	[newSections release];
	
	if (self.category.minimum != nil && self.category.maximum != nil) {
		
		[self createCountableRows];
	}
	
	// update UI content
	[self updateUIContent];
}

-(void)createCountableRows {
	
	NSArray *keys = [[NSArray alloc] initWithObjects:@"Title", @"ControlObject", nil];
	NSArray *objects;
	
	NSInteger index;
	
	// minimum
	
	objects = [[NSArray alloc] initWithObjects:@"Minimum", self.minimumTextField, nil];
	NSDictionary *minimumPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	index = self.category.cid != nil ? 1 : 2;
	
	[[self.sections objectAtIndex:0] insertObject:minimumPair atIndex:index];
	
	[minimumPair release];
	
	// maximum
	
	objects = [[NSArray alloc] initWithObjects:@"Maximum", self.maximumTextField, nil];
	NSDictionary *maximumPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	index = self.category.cid != nil ? 2 : 3;
	
	[[self.sections objectAtIndex:0] insertObject:maximumPair atIndex:index];
	
	[maximumPair release];
	
	// decimals
	
	objects = [[NSArray alloc] initWithObjects:@"Decimals", self.decimalsSegmentedControl, nil];
	NSDictionary *decimalsPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	index = self.category.cid != nil ? 3 : 4;
	
	[[self.sections objectAtIndex:0] insertObject:decimalsPair atIndex:index];
	
	[decimalsPair release];
	
	// unit
	
	objects = [[NSArray alloc] initWithObjects:@"Unit", self.unitButton, nil];
	NSDictionary *unitPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
	[objects release];
	
	index = self.category.cid != nil ? 4 : 5;
	
	[[self.sections objectAtIndex:0] insertObject:unitPair atIndex:index];
	
	[unitPair release];
	
	[keys release];
}

@end
