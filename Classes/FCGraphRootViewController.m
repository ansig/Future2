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
//  FCGraphRootViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 28/07/2010.
//

#import "FCGraphRootViewController.h"

#define kEndDateOffset	86400.0f	// for adding one day to the end date, since the graph works
									// between the two dates and does not wrap around them like
									// the log does





@implementation FCGraphRootViewController

@synthesize logDatesButton, logDateSelectorViewController;
@synthesize scrollView;
@synthesize graphControllers, graphHandles;
@synthesize entryInfoView;
@synthesize pullMenuViewController, pullMenuHandleView;

#pragma mark Instance

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
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationGraphSetsChanged object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FCNotificationGraphPreferencesChanged object:nil];

	[logDatesButton release];
	[logDateSelectorViewController release];
	
	[scrollView release];
	
	[graphControllers release];
	[graphHandles release];
	
	[entryInfoView release];
	
	[pullMenuViewController release];
	[pullMenuHandleView release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCGraphRootViewController -didReceiveMemoryWarning!");
}

#pragma mark Views

 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
	 
	 // * Main view
	 
	 CGRect frame = CGRectMake(0.0f, 0.0f, 480.0f, 320.0f); // flipping width/height for landscape view
	 UIView *view = [[UIView alloc] initWithFrame:frame];
	 view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackgroundPattern.png"]];
	 
	 self.view = view;
	 
	 [view release];
	 
	 // * Gesture recognizer
	 
	 UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
	 [self.view addGestureRecognizer:pinchGesture];
	 [pinchGesture release];
	 
	 // * Scroll view
	 
	 UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, kGraphAppHeader, 480.0f, 320.0f-kGraphAppHeader)];
	 newScrollView.backgroundColor = [UIColor clearColor];
	 newScrollView.canCancelContentTouches = NO;
	 
	 self.scrollView = newScrollView;
	 [self.view addSubview:newScrollView];
	 
	 [newScrollView release];
	 
	 // * Log dates button
	 
	 UIButton *newLogDatesButton = [UIButton buttonWithType:UIButtonTypeCustom];
	 newLogDatesButton.frame = CGRectMake(5.0f, 5.0f, 30.0f, 30.0f);
	 
	 [newLogDatesButton setImage:[UIImage imageNamed:@"calendarButton.png"] forState:UIControlStateNormal];
	 [newLogDatesButton addTarget:self action:@selector(loadLogDateSelectorViewController) forControlEvents:UIControlEventTouchUpInside];
	  
	  self.logDatesButton = newLogDatesButton;
	  [self.view addSubview:newLogDatesButton];
	
	 // * Load default state
	 
	 [self loadDefaultState];
	 
	 // * Pull menu
	 
	 // menu
	 FCGraphPullMenuViewController *newPullMenuViewController = [[FCGraphPullMenuViewController alloc] init];
	 
	 self.pullMenuViewController = newPullMenuViewController;
	 [self.view addSubview:newPullMenuViewController.view];
	 
	 [newPullMenuViewController release];
	 
	 // handle
	 CGFloat width = kGraphPullMenuHandleSize.width;
	 CGFloat height = kGraphPullMenuHandleSize.height;
	 CGFloat xPos = (480.0f/2) - (width/2);
	 CGFloat yPos = 0.0f;
	 
	 FCGraphHandleView *newHandle = [[FCGraphHandleView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
	 newHandle.delegate = self.pullMenuViewController;
	 newHandle.color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slantedBackgroundPattern.png"]];
	 newHandle.mode = FCGraphHandleModeTopDown;
	 newHandle.cornerRadius = 8.0f;
	 newHandle.range = kGraphPullMenuHandleRange;
	 newHandle.lowerThreshold = kGraphPullMenuHandleLowerThreshold;
	 newHandle.upperThreshold = kGraphPullMenuHandleUpperThreshold;
	 
	 [newHandle createNewLabel];
	 [newHandle createNewDirectionalArrow];
	 
	 self.pullMenuHandleView = newHandle;
	 [self.view addSubview:newHandle];
	 
	 [newHandle release];
	 
	 [self setLogDatesLabel];
	 
	 // * Notifications
	 
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGraphSetsChangedNotification) name:FCNotificationGraphSetsChanged object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGraphPreferencesChangedNotification) name:FCNotificationGraphPreferencesChanged object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGraphOptionsChangedNotification) name:FCNotificationGraphOptionsChanged object:nil];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGraphLogDateSelectorDismissedNotification) name:FCNotificationGraphLogDateSelectorDismissed object:nil];
 }

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 
	[super viewDidLoad];
 }
 */

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadLogDateSelectorViewController {
	
	FCGraphLogDateSelectorViewController *viewController = [[FCGraphLogDateSelectorViewController alloc] init];
	viewController.view.alpha = 0.0f;
	
	self.logDateSelectorViewController = viewController;
	[self.view addSubview:viewController.view];
	
	[viewController release];
	
	[UIView animateWithDuration:kViewAppearDuration 
					 animations:^ { self.logDateSelectorViewController.view.alpha = 0.75f; } 
					 completion:^ (BOOL finished) { [self.logDateSelectorViewController presentUIContent]; } ];
}

-(void)dismissLogDateSelectorViewController {
	
	[UIView animateWithDuration:kViewDisappearDuration 
					 animations:^ { self.logDateSelectorViewController.view.alpha = 0.0f; } 
					 completion:^ (BOOL finished) { [self.logDateSelectorViewController.view removeFromSuperview]; self.logDateSelectorViewController = nil; } ];
}

#pragma mark Orientation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    
	// Remove HUD from screen when the HUD was hidded
    [_progressHUD removeFromSuperview];
    [_progressHUD release];
}

#pragma mark FCGraphDelegate

-(BOOL)scrollRelativesForGraphViewController:(id)theViewController {
	
	return [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultGraphSettingScrollRelatives];
}

-(BOOL)drawLabelsInGraphForGraphViewController:(id)theGraphViewController {
	
	return [[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultGraphSettingLabelsInGraph];
}

-(BOOL)drawGridForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawGrid"] boolValue];
}

-(BOOL)drawAxesForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawAxes"] boolValue];
}

-(BOOL)drawXScaleForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawXScale"] boolValue];
}

-(BOOL)drawLinesForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawLines"] boolValue];
}

-(BOOL)drawAverageForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawAverage"] boolValue];
}

-(BOOL)drawMedianForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawMedian"] boolValue];
}

-(BOOL)drawIQRForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawIQR"] boolValue];
}

-(BOOL)drawReferencesForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"DrawReferences"] boolValue];
}

-(FCGraphScaleDateLevel)dateLevelForGraphViewController:(id)theViewController {

	return [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
}

-(FCGraphEntryViewMode)entryViewModeForGraphViewController:(id)theGraphViewController {
	
	NSInteger indexOfGraphController = [self.graphControllers indexOfObject:(FCGraphViewController *)theGraphViewController];	
	NSDictionary *graphSet = [[[NSUserDefaults standardUserDefaults] objectForKey:FCDefaultGraphs] objectAtIndex:indexOfGraphController];
	
	return [[graphSet objectForKey:@"EntryViewMode"] integerValue];
}

-(NSArray *)referenceRangesForGraphSet:(id)theGraphSet inGraphViewController:(id)theGraphViewController {
	
	// TMP SOLUTION: manually adds a reference range for glucose. This will be
	// made dynamic in future version. The plan is to create a new data structure
	// to the database which can store reference ranges for any category.
	
	FCGraphViewController *typedGraphViewController = (FCGraphViewController *)theGraphViewController;
	NSString *key = typedGraphViewController.key;
	
	if ([key isEqualToString:FCKeyCIDGlucose]) {
		
		//FCGraphDataSet *typedGraphSet = (FCGraphDataSet *)theGraphSet;
		
		FCCategory *category = [FCCategory categoryWithCID:key];
		
		FCGraphReferenceRange *newRange;
		
		if ([category.uid isEqualToString:FCKeyUIDGlucoseMillimolesPerLitre]) {
			
			newRange = [[FCGraphReferenceRange alloc] initWithName:@"Normal glucose" 
														upperLimit:[NSNumber numberWithDouble:8.0] 
														lowerLimit:[NSNumber numberWithDouble:5.0]];
			
		} else {
			
			newRange = [[FCGraphReferenceRange alloc] initWithName:@"Normal glucose" 
														upperLimit:[NSNumber numberWithDouble:144.0] 
														lowerLimit:[NSNumber numberWithDouble:90.0]];
		}
		
		NSArray *ranges = [NSArray arrayWithObjects:newRange, nil];
		
		[newRange release];
		
		return ranges;
	}
	
	return nil;
}

-(UIColor *)baseColorForGraphViewController:(id)theGraphViewController {
	
	FCGraphViewController *typedGraphViewController = (FCGraphViewController *)theGraphViewController;
	
	UIColor *color = [[FCColorCollection sharedColorCollection] colorForCID:typedGraphViewController.key];
	
	if (color == nil) {
		
		FCCategory *category = [FCCategory categoryWithCID:typedGraphViewController.key];
		
		NSInteger colorIndex = [category.colorIndex integerValue];
		color = [[FCColorCollection sharedColorCollection] colorForIndex:colorIndex];
	}
	
	return color;
}

-(UIImage *)labelIconForGraphViewController:(id)theGraphViewController {

	FCGraphViewController *typedGraphViewController = (FCGraphViewController *)theGraphViewController;
	
	FCCategory *category = [FCCategory categoryWithCID:typedGraphViewController.key];
	
	return [[FCIconCollection sharedIconCollection] iconForIID:category.iid];
}

-(NSString *)labelTitleForGraphViewController:(id)theGraphViewController {
	
	FCGraphViewController *typedGraphViewController = (FCGraphViewController *)theGraphViewController;
	
	FCCategory *category = [FCCategory categoryWithCID:typedGraphViewController.key];
	
	return category.name;
}

-(UIImage *)iconForEntryViewWithKey:(NSString *)theKey {

	FCEntry *anEntry = [FCEntry entryWithEID:theKey];
		
	return anEntry.category.icon;
}

-(id)twinForGraphViewController:(id)theController {
	
	// create a new controller with info derived from the sibling
	
	FCGraphViewController *theSibling = (FCGraphViewController *)theController;
	
	CGFloat width = 480.0f - theSibling.view.frame.size.width;
	CGFloat height = theSibling.view.frame.size.height;
	CGFloat xPos = theSibling.view.frame.size.width;
	CGFloat yPos = theSibling.view.frame.origin.y;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSArray *defaultGraphs = [defaults objectForKey:FCDefaultGraphs];
	NSDictionary *siblingInfo = [defaultGraphs objectAtIndex:[self.graphControllers indexOfObject:theSibling]];
	
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	NSDate *startDate = [logDates objectForKey:@"StartDate"];
	NSDate *endDate = [NSDate dateWithTimeInterval:kEndDateOffset sinceDate:[logDates objectForKey:@"EndDate"]];
	
	NSNumber *mode = [[NSNumber alloc] initWithInteger:FCGraphModeTwinTimePlotHorizontal];
	
	FCGraphViewController *newGraphViewController = [self createGraphControllerWithFrame:frame 
																					mode:[mode integerValue] 
																					 key:[siblingInfo objectForKey:@"Key"]
																			   startDate:startDate 
																				 endDate:endDate 
																		  ancestorOrTwin:theSibling];
	
	[self.scrollView addSubview:newGraphViewController.view];
	
	// return the controller
	
	return newGraphViewController;
}

-(void)touchOnEntryWithAnchorPoint:(CGPoint)theAnchor superview:(UIView *)theSuperview key:(NSString *)theKey; {
	
	// remove any present info views
	
	if (self.entryInfoView != nil)
		[self.entryInfoView animateDisappearence], self.entryInfoView = nil;
	
	// load the entry with the given key
	 
	FCEntry *entry = [FCEntry entryWithEID:theKey];
	
	// variables
	
	CGFloat superviewWidth = self.view.frame.size.height;
	CGFloat superviewHeight = self.view.frame.size.width;
	
	CGFloat width = superviewWidth; // default size: full view
	CGFloat height = superviewHeight;
	
	CGFloat xPos = 0.0f; // default position: top left corner
	CGFloat yPos = 0.0f; 
	
	CGFloat padding = kGraphEntryInfoViewPadding;
	
	// get and convert origin point
	
	CGPoint anchorInSelf = [self.view convertPoint:theAnchor fromView:theSuperview];
	CGFloat xAnchor = anchorInSelf.x;
	CGFloat yAnchor = anchorInSelf.y;
	
	// find corrent size and position for entries with integer or decimal values
	
	NSString *datatype = entry.category.datatypeName;
	if (![datatype isEqualToString:@"string"] && ![datatype isEqualToString:@"photo"]) {
	
		// set width and height to constant values
		
		width = kGraphEntryInfoViewSize.width;
		height = kGraphEntryInfoViewSize.height;
		
		// find a centre point for the entry info view where any edge of the view is not nearer 
		// to the edge of the screen or the entry view object pressed than a specified limit
		
		/*
		 OBS! The solution for calculating the position below is not great right now! It would be better
		 to rotate around a circle and try at different radians until a suitable one is found or
		 default to start position.
		 
		 /Anders
		 */
		
		// begin at top left of touched entry
		
		xPos = xAnchor - (kGraphEntryViewDiameter/2) - padding - width;
		yPos = yAnchor - (kGraphEntryViewDiameter/2) - padding - height;
		
		// adjust horizontally
		
		BOOL adjustedRight = NO;
		
		if (xPos < padding) {
			
			// move right
			xPos = padding;
			adjustedRight = YES;
			
		} else if ((xPos + width) > (superviewWidth-padding)) {
			
			// move left
			xPos = superviewWidth - padding - width;
		}
		
		// adjust vertically
		
		if (yPos < padding) {
			
			if (adjustedRight) {
				
				// try to place underneath instead
				yPos = yAnchor + (kGraphEntryViewDiameter/2) + padding;
				
				if ((yPos + height) > (superviewHeight-padding)) {
					
					// try to change to right side
					xPos = xAnchor + (kGraphEntryViewDiameter/2) + padding;
					yPos = padding;
					
					// default to top left corner
					if ((xPos + width) > (superviewWidth - padding))
						xPos = padding;
				}
				
			} else {
				
				yPos = padding;
			}
		}
	}
	
	// create and display the info view
	FCGraphEntryInfoView *newEntryInfoView = [[FCGraphEntryInfoView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height) entry:entry];
	[newEntryInfoView prepareToAnimateAppearanceFromPoint:anchorInSelf];
	
	self.entryInfoView = newEntryInfoView;
	[self.view addSubview:newEntryInfoView];
	
	[newEntryInfoView release];
	
	[newEntryInfoView animateAppearence];
}

#pragma mark Notifications

-(void)onGraphSetsChangedNotification {
	
	[self loadDefaultStateWithProgressHUD];
}

-(void)onGraphPreferencesChangedNotification {
	
	for (FCGraphViewController *graphController in self.graphControllers)
		[graphController reloadPreferences];
}

-(void)onGraphOptionsChangedNotification {
	
	// update log dates for the current date level
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	NSDate *endDate = [logDates objectForKey:@"EndDate"];
	
	NSDate *newStartDate;
	
	FCGraphScaleDateLevel level = [defaults integerForKey:FCDefaultGraphSettingDateLevel];
	
	switch (level) {
			
		case FCGraphScaleDateLevelHours:
			newStartDate = [NSDate dateWithTimeInterval:-518400 sinceDate:endDate]; // week
			break;
			
		default:
			newStartDate = [NSDate dateWithTimeInterval:-2505600 sinceDate:endDate]; // month
			break;
	}
	
	NSDictionary *newLogDates = [[NSDictionary alloc] initWithObjectsAndKeys:newStartDate, @"StartDate", endDate, @"EndDate", nil];
	[defaults setObject:newLogDates forKey:FCDefaultLogDates];
	[newLogDates release];
	
	[self setLogDatesLabel];
	
	[self loadDefaultStateWithProgressHUD];
}

-(void)onGraphLogDateSelectorDismissedNotification {

	[self dismissLogDateSelectorViewController];
}

#pragma mark Gestures

- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender {
	
    CGFloat scale = [(UIPinchGestureRecognizer *)sender scale];
	UIGestureRecognizerState state = [(UIPinchGestureRecognizer *)sender state];
	
	if (state == UIGestureRecognizerStateBegan) {
		
		_initialScale = scale;
		
	} else if (state == UIGestureRecognizerStateChanged) {
		
		_changedScale = scale;
		
	} else if (state == UIGestureRecognizerStateEnded) {
		
		NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultGraphSettingDateLevel];
		
		if (_changedScale > _initialScale) {
			
			level++;
	
		} else {
		
			level--;
		}
		
		if (level > -1 && level < 3) {
			
			[[NSUserDefaults standardUserDefaults] setInteger:level forKey:FCDefaultGraphSettingDateLevel];
		
			[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationGraphOptionsChanged object:self];
		}
	}
}

#pragma mark Custom

-(void)loadDefaultStateWithProgressHUD {

	// The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:_progressHUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    _progressHUD.delegate = self;
	
    _progressHUD.labelText = @"Loading";
	
    // Show the HUD while the provided method executes in a new thread
    [_progressHUD showWhileExecuting:@selector(loadDefaultState) onTarget:self withObject:nil animated:YES];
}

-(void)loadDefaultState {
	
	// unload any present graphs
	if (self.graphControllers != nil || self.graphHandles != nil)		
		[self unloadCurrentState];
	
	NSMutableArray *newGraphControllers = [[NSMutableArray alloc] init];
	self.graphControllers = newGraphControllers;
	[newGraphControllers release];
	
	NSMutableArray *newGraphHandles = [[NSMutableArray alloc] init];
	self.graphHandles = newGraphHandles;
	[newGraphHandles release];

	// get date range from user defaults
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	NSDate *startDate = [logDates objectForKey:@"StartDate"];
	NSDate *endDate = [NSDate dateWithTimeInterval:kEndDateOffset sinceDate:[logDates objectForKey:@"EndDate"]];
	
	// get the graphs stored in the user defaults
	
	NSArray *defaultGraphs = [defaults objectForKey:FCDefaultGraphs];
	if (defaultGraphs != nil) {
		
		// * create the graphs
		
		// heights
		CGFloat fullHeight = [defaultGraphs count] > 1 ? (320.0f - kGraphAppHeader) / 2 : 320.0f - kGraphAppHeader;
		CGFloat bandHeight = kGraphBandHeight;
		
		// counts
		int fullGraphs = 0;
		int bands = 0;
		
		for (NSDictionary *graphSet in defaultGraphs) {
			
			// * Mode
		
			// default mode
			FCGraphMode mode = FCGraphModeTimePlotHorizontal;
			
			// use the first graph as a relative if there is one and make all 
			// subsequent graphs descendants of that
			FCGraphViewController *theRelative = nil;
			if ([self.graphControllers count] > 0) {
			
				mode = FCGraphModeDescendantTimePlotHorizontal;
				theRelative = [self.graphControllers objectAtIndex:0];
			}
			
			// set mode to band if the entry view mode is icons
			NSInteger entryViewMode = [[graphSet objectForKey:@"EntryViewMode"] integerValue];
			if (entryViewMode == FCGraphEntryViewModeIcon)
				mode = FCGraphModeTimeBandHorizontal;
			
			// * Frame
			
			CGFloat width = 480.0f - kGraphAppPadding;
			CGFloat height = (mode == FCGraphModeTimeBandHorizontal ? bandHeight : fullHeight) - kGraphAppPadding;
			CGFloat xPos = 0.0f + kGraphAppPadding;
			CGFloat yPos = 0.0f + (fullHeight * fullGraphs) + (bandHeight * bands);
			
			CGRect frame = CGRectMake(xPos, yPos, width, height);
			
			// * Key and create graph controller
			
			NSString *key = [graphSet objectForKey:@"Key"];
		
			FCGraphViewController *newGraphController = [self createGraphControllerWithFrame:frame 
																						mode:mode
																						 key:key 
																				   startDate:startDate 
																					 endDate:endDate 
																			  ancestorOrTwin:theRelative];
			
			[self.scrollView addSubview:newGraphController.view];
			[self.view sendSubviewToBack:self.scrollView]; // fix: makes sure pull down menu is always on top
			
			// * Handle and cound full/band graphs
			
			if (mode == FCGraphModeTimeBandHorizontal) {
				
				bands++;
				
			} else {
			
				FCGraphHandleView *newHandle = [self createHandleForGraphController:newGraphController];
			
				[self.scrollView addSubview:newHandle];
				[self.graphHandles addObject:newHandle];
		
				fullGraphs++;
			}
		}
		
		// set content size for scroll view
		CGFloat contentHeight = (fullHeight * fullGraphs) + (bandHeight * bands);
		self.scrollView.contentSize = CGSizeMake(480.0f, contentHeight);
		
	} else {
	
		// create a default graph if there were none in the defaults
		
		[self createDefaultGraph];
	}
}

-(void)unloadCurrentState {
/*	Removes and releases any currently loaded graphs and handles */
	
	if (self.graphControllers != nil) {
	
		for (FCGraphViewController *graphViewController in self.graphControllers)
			[graphViewController.view removeFromSuperview];
		
		self.graphControllers = nil;
	}
	
	if (self.graphHandles != nil) {
	
		for (FCGraphHandleView *handleView in self.graphHandles)
			[handleView removeFromSuperview];
		
		self.graphHandles = nil;
	}
}

-(void)createDefaultGraph {
/*	Creates a default graph set for glucose entries. */
	
	// compose the default graph
	
	NSDictionary *graphSet = [[FCCategory categoryWithCID:FCKeyCIDGlucose] generateDefaultGraphSet];
	
	// save the default graph set in user defaults
	
	NSArray *defaultGraphs = [[NSArray alloc] initWithObjects:graphSet, nil];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:defaultGraphs forKey:FCDefaultGraphs];
	
	[defaultGraphs release];
	
	// load default state again to create the default graph
	
	[self loadDefaultState];
}

-(FCGraphViewController *)createGraphControllerWithFrame:(CGRect)frame
													mode:(FCGraphMode)theMode
													 key:(NSString *)theKey
											   startDate:(NSDate *)theStartDate
												 endDate:(NSDate *)theEndDate
										  ancestorOrTwin:(FCGraphViewController *)theRelative; {
	
/*	Returns a new graph view controller composed with the given information.
	Creates an empty graph with a scale derived from the entry's category if there are no entries for the key in the graph set. */
	
	// the category we are working with
	FCCategory *category = [[FCCategory categoryWithCID:theKey] retain];
	
	// create the graph controller object with the given frame
	
	FCGraphViewController *newGraphViewController = [[FCGraphViewController alloc] initWithFrame:frame];
	
	newGraphViewController.delegate = self;
	newGraphViewController.key = theKey;
	
	// add it to the array (necessary because the callback methods for FCGraphDelegegate will be called when preferences are loaded below)
	[self.graphControllers addObject:newGraphViewController];
	
	// create date range with given start and end dates
	
	FCDateRange dateRange = FCDateRangeMake([theStartDate timeIntervalSinceReferenceDate], [theEndDate timeIntervalSinceReferenceDate]);
	
	// get all entries and create data range
	
	NSArray *entries = [self loadEntriesWithCID:theKey betweenStartDate:theStartDate endDate:theEndDate];
	
	FCDataRange dataRange;
	if (theMode == FCGraphModeTimeBandHorizontal) {
		
		// If we are dealing with a timeband, the only possible values are 0 or 1.
		// To deal with this, make a data range between 0 and 2 so that entries
		// end up in the middle of the scale.
		dataRange = FCDataRangeMake(0.0, 2.0);
	
	} else if (entries == nil) {
		
		// if there were no entries, use the category's minimum and maximum values for the range
		dataRange = FCDataRangeMake([category.minimum doubleValue], [category.maximum doubleValue]);
	
	} else {
		
		// otherwise, find the maximum value among the entries and use that to create the data range
		NSDictionary *dictionary = [self findMinMaxAmong:entries];
		dataRange = FCDataRangeMake(0.0, [[dictionary objectForKey:@"Maximum"] doubleValue]);
	}
	
	// load the correct graph for the mode
	
	switch (theMode) {
			
		case FCGraphModeTimePlotHorizontal:
			[newGraphViewController loadTimePlotHorizontalGraphForDataRange:dataRange withinDateRange:dateRange];
			break;
			
		case FCGraphModeDescendantTimePlotHorizontal:
			[newGraphViewController loadTimePlotHorizontalGraphForDataRange:dataRange withinDateRange:dateRange withAncestor:theRelative];
			break;
			
		case FCGraphModeTwinTimePlotHorizontal:
			[newGraphViewController loadTimePlotHorizontalGraphForDataRange:dataRange withinDateRange:dateRange withTwin:theRelative];
			break;
			
		case FCGraphModeTimeBandHorizontal:
			if (theRelative == nil)
				[newGraphViewController loadTimeBandHorizontalGraphForDataRange:dataRange withingDateRange:dateRange];
			
			else
				[newGraphViewController loadTimeBandHorizontalGraphForDataRange:dataRange withingDateRange:dateRange withAncestor:theRelative];
			break;
			
		default:
			NSAssert1(0, @"FCGraphRootViewController createGraphForViewControllerWithFrame:mode:key:startDate:endDate:ancestorOrTwin: || %@", @"Failed to swtich according to mode since mode was not among listed!");
			break;
	}
	
	// create graph entry objects for the entries and add them to the graph
	
	if (entries != nil) {
	
		// formatter for the entry view labels
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setMinimumIntegerDigits:1];
		
		[formatter setMinimumFractionDigits:[category.decimals intValue]];
		[formatter setMaximumFractionDigits:[category.decimals intValue]];
		
		FCGraphDataSet *dataSet = [[FCGraphDataSet alloc] init];
		for (FCEntry *entry in entries) {
			
			NSNumber *yValue;
			if (theMode == FCGraphModeTimeBandHorizontal)
				yValue = [NSNumber numberWithDouble:1.0];
			else
				yValue = entry.integer != nil ? entry.integer : entry.decimal;
			
			NSNumber *xValue = [NSNumber numberWithDouble:[entry.timestamp timeIntervalSinceDate:theStartDate]];
			
			FCGraphEntryView *entryView = [[FCGraphEntryView alloc] initWithXValue:xValue yValue:yValue key:entry.eid];
			
			if (theMode != FCGraphModeTimeBandHorizontal)
				[entryView showLabelForYValueUsingNumberFormatter:formatter]; // show correctly formatted label for the y value
			
			[dataSet addObject:entryView];
			[entryView release];
		}
		
		[formatter release];
		
		[dataSet autorelease];
		
		[newGraphViewController addDataSet:dataSet];
	}
	
	// autorelease and return the new graph controller
	
	[newGraphViewController autorelease];
	
	return newGraphViewController;
}

-(FCGraphHandleView *)createHandleForGraphController:(FCGraphViewController *)theGraphController {
/*	Returns a new handle view with the graph controller as it's delegate */
	
	// create a handle for the graph controller
	CGRect frame = theGraphController.view.frame;
	
	CGFloat width = kGraphHandleSize.height; // (flipping height and width because this is a vertical handle)
	CGFloat height = kGraphHandleSize.width < frame.size.height ? kGraphHandleSize.width : frame.size.height;
	CGFloat xPos = frame.size.width - width + kGraphAppPadding;
	CGFloat yPos = frame.origin.y + ((frame.size.height/2) - (height/2));
	
	FCGraphHandleView *newHandle = [[FCGraphHandleView alloc] initWithFrame:CGRectMake(xPos, yPos, width, height)];
	newHandle.color = [self baseColorForGraphViewController:theGraphController];
	newHandle.mode = FCGraphHandleModeRightToLeft;
	newHandle.cornerRadius = 5.0f;
	newHandle.range = 220.0f;
	newHandle.lowerThreshold = FCGraphHandleThresholdQuarter;
	//newHandle.upperThreshold = FCGraphHandleThresholdOpposite;	// OBS! If the upper threshold is set the user can't 
																	// choose size on the twin
	
	newHandle.delegate = theGraphController;
	
	[newHandle createNewDirectionalArrow];
	
	[newHandle autorelease];
	
	return newHandle;
}

-(NSArray *)loadEntriesWithCID:(NSString *)theCID betweenStartDate:(NSDate *)theStartDate endDate:(NSDate *)theEndDate {
/*	Loads entries from the database between the given start and end dates.
	Returns an array with FCEntry objects.
	Returns nil if no entries existed. */
	
	// database handler
	FCDatabaseHandler *dbh = [[FCDatabaseHandler alloc] init];
	
	// table and columns
	NSString *table = @"entries";
	NSString *columns = @"*";
	
	// date formatter for converting dates to/from strings
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = FCFormatDate;
	
	// filter for getting entries with a certain CID and only within the start and end dates
	
	// FIX: since graph works by not wrapping days but the databasehandler will, we need to
	// only use end dates that are LESS than the given end date in the query
	
	NSString *filters = [[NSString alloc] initWithFormat:@"cid = '%@' AND date(timestamp) >= '%@' AND date(timestamp) < '%@'", theCID, [formatter stringFromDate:theStartDate], [formatter stringFromDate:theEndDate]];
	
	[formatter release];
	
	// order by date
	NSString *option = @"ORDER BY timestamp";
	
	// get the result
	NSArray *result = [dbh getColumns:columns fromTable:table withFilters:filters options:option];
	
	[filters release];
	[dbh release];
	
	// if result is nil, return nil
	if (result == nil)
		return nil;
	
	// otherwise, compose an array with entries and return it...
	
	// get the unit for the category for converting all the entries to the same unit
	FCEntry *firstEntry = [[FCEntry alloc] initWithDictionary:[result objectAtIndex:0]];
	FCUnit *unit = firstEntry.category.unit;
	[firstEntry release];
	
	NSMutableArray *mutableArrayWithEntries = [[NSMutableArray alloc] init];
	for (NSDictionary *row in result) {
	
		FCEntry *entry = [[FCEntry alloc] initWithDictionary:row];
		
		// adjust to currently selected category unit
		[entry convertToNewUnit:unit];
		
		[mutableArrayWithEntries addObject:entry];
		[entry release];
	}
	
	NSRange range = NSMakeRange(0, [mutableArrayWithEntries count]);
	NSArray *arrayWithEntries = [[NSArray alloc] initWithArray:[mutableArrayWithEntries subarrayWithRange:range]];
	
	[mutableArrayWithEntries release];
	
	[arrayWithEntries autorelease];
	
	return arrayWithEntries;
}

-(NSDictionary *)findMinMaxAmong:(NSArray *)entries {
/*	Finds the maximum and minimum values among a set of entries.
	Returns a dictionary with the values as NSNumber with corresponding keys @"Maximum" and @"Minimum" */

	// get the initial minimum and maximum from the first entry
	
	FCEntry *entry = [entries objectAtIndex:0];
	
	NSNumber *value = entry.integer != nil ? entry.integer : entry.decimal;
	double maximum = [value doubleValue] > 0 ? [value doubleValue] : 1;
	double minimum = [value doubleValue] > 1 ? [value doubleValue] - 1 : 0;
	
	// loop through the rest and find the true min and max
	
	for (int i = 1; i < [entries count]; i++) {
	
		FCEntry *entry = [entries objectAtIndex:i];
		NSNumber *value = entry.integer != nil ? entry.integer : entry.decimal;
		
		double potentialMaximum = [value doubleValue];
		double potentialMinimum = [value doubleValue];
		
		if (maximum < potentialMaximum)
			maximum = potentialMaximum;
		
		if (minimum > potentialMinimum)
			minimum = potentialMinimum;
	}
	
	// compose result and return
	
	NSNumber *maximumNumber = [[NSNumber alloc] initWithDouble:maximum];
	NSNumber *minimumNumber = [[NSNumber alloc] initWithDouble:minimum];
	
	NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:maximumNumber, @"Maximum", minimumNumber, @"Minimum", nil];
	
	[maximumNumber release];
	[minimumNumber release];
	
	[dictionary autorelease];
	
	return dictionary;
}

-(void)setLogDatesLabel {
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *logDates = [defaults objectForKey:FCDefaultLogDates];
	
	NSDate *startDate = [logDates objectForKey:@"StartDate"];
	NSDate *endDate = [NSDate dateWithTimeInterval:kEndDateOffset sinceDate:[logDates objectForKey:@"EndDate"]];
	
	self.pullMenuHandleView.label.text = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
	self.pullMenuHandleView.label.textColor = kDarkColor;
	
	[formatter release];
}

@end
