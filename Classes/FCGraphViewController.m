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
//  FCGraphViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 22/09/2010.
//

#import "FCGraphViewController.h"


@implementation FCGraphViewController

@synthesize delegate;
@synthesize relatives, scrollRelatives;
@synthesize twin, scrollTwin;
@synthesize mode, key;
@synthesize yScale, yScaleView;
@synthesize xScale, xScaleView;
@synthesize graphView, scrollView;
@synthesize label, additionalLabels, baseColor, additionalColors;
@synthesize dataSets, addButton, removeButton;

#pragma mark Init

-(id)initWithFrame:(CGRect)theFrame {
	
	if (self = [super init]) {
		
		// create a main view which contains all other elements
		UIView *newView = [[UIView alloc] initWithFrame:theFrame];
		newView.backgroundColor = [UIColor clearColor];
		self.view = newView;
		[newView release];
		
		// create the data set array
		dataSets = [[NSMutableArray alloc] init];
		additionalLabels = [[NSMutableArray alloc] init];
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
	
	[key release];
	
	[relatives release];
	
	[twin release];
	
	[yScale release];
	[yScaleView release];
	
	[xScale release];
	[xScaleView release];
	
	[graphView release];
	[scrollView release];
	
	[label release];
	[additionalLabels release];
	[baseColor release];
	[additionalColors release];
	
	[dataSets release];
	[addButton release];
	[removeButton release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCGraphViewController -didReceiveMemoryWarning!");
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

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange {
	
	[self validateDataRange:theDataRange dateRange:theDateRange];
		
	// * Mode
	
	self.mode = FCGraphModeTimePlotHorizontal;
	
	// * Scales
	
	[self createXScaleWithDateRange:theDateRange];
	[self createYScaleWithDataRange:theDataRange];
	
	// * Views
	
	CGFloat requiredLength = [self.xScale requiredLength];
	CGFloat visibleLength = self.view.frame.size.width - kScaleViewSize;
	CGFloat actualLength = requiredLength > visibleLength ? requiredLength : visibleLength;
	
	CGFloat height = self.view.frame.size.height - kScaleViewSize; // allowing for a visible x scale view
	
	// graph view
	[self loadGraphViewWithLength:actualLength height:height];
	
	// x scale view
	[self loadXScaleViewWithLength:actualLength yOffset:height];
	
	// y scale view
	[self loadYScaleViewWithHeight:height];
	
	// scroll view
	CGFloat xPos = kScaleViewSize;
	CGFloat yPos = 0.0f;
	CGFloat width = visibleLength;
	height += kScaleViewSize;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	CGFloat contentWidth = requiredLength;
	CGFloat contentHeight = height;
	CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
	
	UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:frame];
	newScrollView.contentSize = contentSize;
	
	newScrollView.delegate = self;
	
	self.scrollView = newScrollView;
	[newScrollView release];
	
	// * Compose view hierarchy
	
	[self.scrollView addSubview:self.graphView];
	[self.scrollView addSubview:self.xScaleView];
	
	[self.view addSubview:self.scrollView];
	[self.view addSubview:self.yScaleView];
	
	// * Announce finished
	
	[self didFinishLoadingGraph];
}

-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange withAncestor:(FCGraphViewController *)theAncestor {
/*	Creates a graph with appropriate mode and displays it within main view. */
	
	[self validateDataRange:theDataRange dateRange:theDateRange];
	
	// * Mode
	
	self.mode = FCGraphModeDescendantTimePlotHorizontal;
	
	// * Add relationship
	
	// add self as new relative to ancestor
	if (theAncestor.relatives == nil)
		theAncestor.relatives = [[NSMutableArray alloc] init];
	
	[theAncestor.relatives addObject:self];
	
	// add ancestor as new relative to self
	NSMutableArray *newRelatives = [[NSMutableArray alloc] init];
	self.relatives = newRelatives;
	[newRelatives release];
	
	[self.relatives addObject:theAncestor];
	
	// * Scales
	
	[self createXScaleWithDateRange:theDateRange];
	[self createYScaleWithDataRange:theDataRange];
	
	// * Views
	
	CGFloat requiredLength = [self.xScale requiredLength];
	CGFloat visibleLength = self.view.frame.size.width - kScaleViewSize;
	CGFloat actualLength = requiredLength > visibleLength ? requiredLength : visibleLength;
	
	CGFloat height = self.view.frame.size.height - kScaleViewSize;
	
	// graph view
	[self loadGraphViewWithLength:actualLength height:height];
	
	// y scale view
	[self loadYScaleViewWithHeight:height];
	
	// x scale view
	[self loadXScaleViewWithLength:actualLength yOffset:height];
	
	// scroll view
	CGFloat xPos = kScaleViewSize;
	CGFloat yPos = 0.0f;
	CGFloat width = visibleLength;
	height += kScaleViewSize;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	CGFloat contentWidth = requiredLength;
	CGFloat contentHeight = height;
	CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
	
	UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:frame];
	newScrollView.contentSize = contentSize;
	
	newScrollView.delegate = self;
	
	self.scrollView = newScrollView;
	[newScrollView release];
	
	// * Compose view hierarchy
	
	[self.scrollView addSubview:self.graphView];
	[self.scrollView addSubview:self.xScaleView];
	
	[self.view addSubview:self.scrollView];
	[self.view addSubview:self.yScaleView];
	
	// * Scroll to same offset as relative
	
	self.scrollView.contentOffset = theAncestor.scrollView.contentOffset;
	
	// * Announce finished
	
	[self didFinishLoadingGraph];
}

-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange withTwin:(FCGraphViewController *)theTwin {
/*	Creates a graph with appropriate mode and displays it within main view. */
	
	[self validateDataRange:theDataRange dateRange:theDateRange];
	
	// * Mode
	
	self.mode = FCGraphModeTwinTimePlotHorizontal;
	
	// * Add relationship
	
	if (theTwin.twin == nil)
		theTwin.twin = self;
	
	self.twin = theTwin;
	self.delegate = theTwin;
	
	// * Scales
	
	[self createXScaleWithDateRange:theDateRange];
	[self createYScaleWithDataRange:theDataRange];
	
	// * Separator line
	
	self.view.backgroundColor = self.baseColor;
	CGFloat separation = 3.0f;
	
	// * Views
	
	CGFloat requiredLength = [self.xScale requiredLength];
	CGFloat visibleLength = self.view.frame.size.width - separation;
	CGFloat actualLength = requiredLength > visibleLength ? requiredLength : visibleLength;
	
	CGFloat height = self.view.frame.size.height - kScaleViewSize;
	
	// graph view
	[self loadGraphViewWithLength:actualLength height:height];
	
	// x scale view
	[self loadXScaleViewWithLength:actualLength yOffset:height];
	
	// scroll view
	CGFloat xPos = separation;
	CGFloat yPos = 0.0f;
	CGFloat width = visibleLength;
	height += kScaleViewSize;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	CGFloat contentWidth = requiredLength;
	CGFloat contentHeight = height;
	CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
	
	UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:frame];
	newScrollView.contentSize = contentSize;
	
	newScrollView.delegate = self;
	
	self.scrollView = newScrollView;
	[newScrollView release];
	
	// * Compose view hierarchy
	
	[self.scrollView addSubview:self.graphView];
	[self.scrollView addSubview:self.xScaleView];
	
	[self.view addSubview:self.scrollView];
	
	// * Scroll to same offset as twin
	
	self.scrollView.contentOffset = CGPointMake(self.twin.scrollView.contentOffset.x + self.twin.scrollView.frame.size.width, self.twin.scrollView.contentOffset.y);

	// * Announce finished
	
	[self didFinishLoadingGraph];
}

-(void)loadTimeBandHorizontalGraphForDataRange:(FCDataRange)theDataRange withingDateRange:(FCDateRange)theDateRange {
	
	[self validateDataRange:theDataRange dateRange:theDateRange];
	
	// * Mode
	
	self.mode = FCGraphModeDescendantTimeBandHorizontal;
	
	// * Scales
	
	[self createXScaleWithDateRange:theDateRange];
	[self createYScaleWithDataRange:theDataRange];
	
	// * Views
	
	CGFloat requiredLength = [self.xScale requiredLength];
	CGFloat visibleLength = self.view.frame.size.width - kScaleViewSize;
	CGFloat actualLength = requiredLength > visibleLength ? requiredLength : visibleLength;
	
	CGFloat height = self.view.frame.size.height - kScaleViewSize; // allowing for a visible x scale view
	
	// graph view
	[self loadGraphViewWithLength:actualLength height:height];
	
	// x scale view
	[self loadXScaleViewWithLength:actualLength yOffset:height];
	
	// scroll view
	CGFloat xPos = kScaleViewSize;
	CGFloat yPos = 0.0f;
	CGFloat width = visibleLength;
	height += kScaleViewSize;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	CGFloat contentWidth = requiredLength;
	CGFloat contentHeight = height;
	CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
	
	UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:frame];
	newScrollView.contentSize = contentSize;
	
	newScrollView.delegate = self;
	
	self.scrollView = newScrollView;
	[newScrollView release];
	
	// * Compose view hierarchy
	
	[self.scrollView addSubview:self.graphView];
	[self.scrollView addSubview:self.xScaleView];
	
	[self.view addSubview:self.scrollView];
	
	// * Announce finished
	
	[self didFinishLoadingGraph];
}

-(void)loadTimeBandHorizontalGraphForDataRange:(FCDataRange)theDataRange withingDateRange:(FCDateRange)theDateRange withAncestor:(FCGraphViewController *)theAncestor {
	
	[self validateDataRange:theDataRange dateRange:theDateRange];
	
	// * Mode
	
	self.mode = FCGraphModeDescendantTimeBandHorizontal;
	
	// * Add relationship
	
	// add self as new relative to ancestor
	if (theAncestor.relatives == nil)
		theAncestor.relatives = [[NSMutableArray alloc] init];
	
	[theAncestor.relatives addObject:self];
	
	// add ancestor as new relative to self
	NSMutableArray *newRelatives = [[NSMutableArray alloc] init];
	self.relatives = newRelatives;
	[newRelatives release];
	
	[self.relatives addObject:theAncestor];
	
	// * Create the graph
	
	[self loadTimeBandHorizontalGraphForDataRange:theDataRange withingDateRange:theDateRange];
	
	// * Scroll to same offset as relative
	
	self.scrollView.contentOffset = theAncestor.scrollView.contentOffset;
	
	// * Announce finished
	
	[self didFinishLoadingGraph];
}

-(void)loadGraphViewWithLength:(CGFloat)actualLength height:(CGFloat)height {
/*	Loads a graph view with the given length and height. */
	
	CGRect frame = CGRectMake(0.0f, 0.0f, actualLength, height);
	FCGraphView *newGraphView = [[FCGraphView alloc] initWithFrame:frame xScale:self.xScale yScale:self.yScale];
	
	self.graphView = newGraphView;
	[newGraphView release];
}

-(void)loadXScaleViewWithLength:(CGFloat)actualLength yOffset:(CGFloat)yOffset {
/*	Loads a view for the x scale with the given length and places it on left side at given y offset. */
	
	CGRect frame = CGRectMake(0.0f, yOffset, actualLength, kScaleViewSize);
	FCGraphScaleView *newXScaleView = [[FCGraphScaleView alloc] initWithFrame:frame scale:self.xScale orientation:FCGraphScaleViewOrientationHorizontal];
	
	self.xScaleView = newXScaleView;
	[newXScaleView release];
}

-(void)loadYScaleViewWithHeight:(CGFloat)height {
/*	Loads a view for the y scale with the given height and places it in the top-left corner. */
	
	CGRect frame = CGRectMake(0.0f, 0.0f, kScaleViewSize, height);
	FCGraphScaleView *newYScaleView = [[FCGraphScaleView alloc] initWithFrame:frame scale:self.yScale orientation:FCGraphScaleViewOrientationVertical];
	
	self.yScaleView = newYScaleView;
	[newYScaleView release];
}

-(void)loadReferenceRanges {
	
	
}

-(void)loadBaseLabel {
	
	[self loadLabelForDataSetWithIndex:0];
}

-(void)loadLabelForDataSetWithIndex:(NSInteger)index {
	
	UIColor *color;
	NSString *title = nil;
	UIImage *icon = nil;
	
	if (index == 0) {
		
		// base data set
	
		color = self.baseColor;
		
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(labelTitleForGraphViewController:)])
			title = [self.delegate labelTitleForGraphViewController:self];
		
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(labelIconForGraphViewController:)])
			icon = [self.delegate labelIconForGraphViewController:self];

	} else {
		
		// any other data set
	
		color = [self colorForDataSetWithIndex:index];
		
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(labelTitleForDataSetWithIndex:inGraphViewController:)])
			title = [self.delegate labelTitleForDataSetWithIndex:index inGraphViewController:self];
		
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(labelIconForDataSetWithIndex:inGraphViewController:)])
			icon = [self.delegate labelIconForDataSetWithIndex:index inGraphViewController:self];
	}
	
	CGFloat padding = 5.0f;
	
	CGFloat width = 140.0f;
	CGFloat height = 20.0f;
	
	CGFloat xPos = kScaleViewSize+(kGraphPadding/2);
	CGFloat yPos = (kGraphPadding/2)  + ((height+padding)*index);
	
	FCBorderedLabel *newLabel = [[FCBorderedLabel alloc] initWithFrame:CGRectMake(xPos, 
																			   yPos, 
																			   width, 
																			   height)];
	
	newLabel.backgroundColor = [color colorWithAlphaComponent:0.25f];
	
	newLabel.textColor = [UIColor whiteColor];
	newLabel.font = kGraphFont;
	newLabel.textAlignment = UITextAlignmentRight;
	
	if (icon != nil) {
		
		[newLabel loadImageView];
		newLabel.imageView.image = icon;
	}
	
	if (title != nil)
		newLabel.text = title;
	
	if (index == 0)
		self.label = newLabel;
	
	else
		[self.additionalLabels addObject:newLabel];
	
	[self.view addSubview:newLabel];
	
	[newLabel release]; 
}

-(void)loadButtonsForDataSetWithIndex:(NSInteger)index {
	
	CGFloat padding = 5.0f;
	
	CGFloat width = 140.0f; // corresponds to label width/height
	CGFloat height = 20.0f; // in -loadLabelForDataSetWithIndex:
	
	CGFloat xPos = kScaleViewSize+(kGraphPadding/2);
	CGFloat yPos = (kGraphPadding/2)  + ((height+padding)*index);
	
	if (self.mode == FCGraphModeTimePlotHorizontal || self.mode == FCGraphModeDescendantTimePlotHorizontal) {
		
		if (index == 0) {
			
			UIButton *newAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
			newAddButton.frame = CGRectMake(xPos+width+padding, 
											yPos, 
											20.0f, 
											20.0f);
			
			[newAddButton setImage:[UIImage imageNamed:@"plusButton"] forState:UIControlStateNormal];
			[newAddButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			self.addButton = newAddButton;
			
			[self.view addSubview:newAddButton];
			
		} else {
			
			UIButton *newRemoveButton = [UIButton buttonWithType:UIButtonTypeCustom];
			newRemoveButton.frame = CGRectMake(xPos+width+padding, 
											   yPos, 
											   20.0f, 
											   20.0f);
			
			[newRemoveButton setImage:[UIImage imageNamed:@"minusButton"] forState:UIControlStateNormal];
			[newRemoveButton addTarget:self action:@selector(removeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			
			[self.removeButton removeFromSuperview];
			
			self.removeButton = newRemoveButton;
			[self.view addSubview:newRemoveButton];
		}
	}
}

-(void)didFinishLoadingGraph {
/*	Sets up a label and loads preferences. */
	
	[self loadPreferences];
	
	if (self.twin == nil) {
		
		[self loadBaseLabel];
		[self.view addSubview:self.label];
	}
}

#pragma mark Animation

-(void)animatePulseForAllEntryViewsInDataSet:(NSArray *)theDataSet {
/*	Calls -animatePulse on each entry view within the data set with a certain interval. */
	
	int i = 0;
	for (FCGraphEntryView *entryView in theDataSet) {
	
		NSTimeInterval delay = 0.05f*i;
		[entryView performSelector:@selector(animatePulse) withObject:nil afterDelay:delay];
		
		i++;
	}
}

#pragma mark Events

-(void)addButtonPressed:(UIButton *)theButton {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addAdditionalGraphSetToGraphViewController:)])
		[self.delegate addAdditionalGraphSetToGraphViewController:self];
}

-(void)removeButtonPressed:(UIButton *)theButton {
	
	// remove the entries and data set
	
	for (FCGraphEntryView *entryView in [self.dataSets lastObject])
		[entryView removeFromSuperview];
	
	[self.dataSets removeLastObject];
	
	// remove label and move or delete remove button
	
	FCBorderedLabel *theLabel = [self.additionalLabels lastObject];
	[theLabel removeFromSuperview];
	[self.additionalLabels removeObject:theLabel];
	
	NSInteger lastIndex = [self.dataSets count]-1;
	if (lastIndex > 0) {
		
		[self loadButtonsForDataSetWithIndex:lastIndex];
	
	} else {
		
		[self.removeButton removeFromSuperview];
		self.removeButton = nil;
	}
	
	// make sure add button is in correct state
	if ([self.dataSets count] < 3)
		self.addButton.enabled = YES;
	
	// redraw graph view
	
	[self.graphView setNeedsDisplay];
}

#pragma mark Get

-(UIColor *)baseColor {

	if (baseColor == nil) {
	
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(baseColorForGraphViewController:)])
			self.baseColor = [self.delegate baseColorForGraphViewController:self];
		
		else {
		
			self.baseColor = [UIColor purpleColor]; // DEFAULT BASE COLOR
		}
	}
	
	return baseColor;
}

-(NSArray *)additionalColors {

	if (additionalColors == nil) {
	
		NSArray *defaultColors = [[NSArray alloc] initWithObjects:	// DEFAULT ADDITIONAL COLORS
								  [UIColor orangeColor],
								  [UIColor blueColor],
								  [UIColor brownColor],
								  [UIColor redColor],
								  nil];
		
		self.additionalColors = defaultColors;
		
		[defaultColors release];
	}
	
	return additionalColors;
}

#pragma mark FCGraphEntryViewDelegate

-(CGSize)sizeForEntryViewWithAnchor:(CGPoint)theAnchor {

	if (self.graphView != nil)
		return [self.graphView sizeForPosition:theAnchor];
	
	return CGSizeMake(0.0f, 0.0f);
}

-(void)touchOnEntryWithAnchorPoint:(CGPoint)theAnchor superview:(UIView *)theSuperview key:(NSString *)theKey {
	
	// inform delegate
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(touchOnEntryWithAnchorPoint:superview:key:)])
		[self.delegate touchOnEntryWithAnchorPoint:theAnchor superview:theSuperview key:theKey];
}

-(UIImage *)iconForEntryViewWithKey:(NSString *)theKey {

	// inform delegate
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(iconForEntryViewWithKey:)])
		return [self.delegate iconForEntryViewWithKey:theKey];
	
	return nil;
}

#pragma mark FCGraphDelegate

// OBS! FCGraphViewController implements the FCGraphDelegate protocol for the purpose of
// acting as a twin and simply tries to pass on any calls to its own delegate.

-(UIColor *)baseColorForGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(baseColorForGraphViewController:)])
		return [self.delegate baseColorForGraphViewController:self];
	
	return nil;
}

-(UIColor *)colorForDataSetWithIndex:(NSInteger)index inGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(colorForDataSetWithIndex:inGraphViewController:)])
		return [self.delegate colorForDataSetWithIndex:index inGraphViewController:self];
	
	return nil;
}

-(FCGraphScaleDateLevel)dateLevelForGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dateLevelForGraphViewController:)])
		return [self.delegate dateLevelForGraphViewController:self];
	
	return FCGraphScaleDateLevelHours;
}

-(FCGraphEntryViewMode)entryViewModeForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(entryViewModeForGraphViewController:)])
		return [self.delegate entryViewModeForGraphViewController:self];
	
	return FCGraphEntryViewModeCircle;
}

-(NSArray *)referenceRangesForGraphSet:(id)theGraphSet inGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(referenceRangesForGraphSet:inGraphViewController:)])
		return [self.delegate referenceRangesForGraphSet:theGraphSet inGraphViewController:self];
	
	return nil;
}

-(BOOL)scrollRelativesForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(scrollRelativesForGraphViewController:)])
		return [self.delegate scrollRelativesForGraphViewController:self];
	
	return NO;
}

-(BOOL)scrollTwinForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(scrollTwinForGraphViewController:)])
		return [self.delegate scrollTwinForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawGridForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawGridForGraphViewController:)])
		return [self.delegate drawGridForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawAxesForGraphViewController:(id)theGraphViewController  {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawAxesForGraphViewController:)])
		return [self.delegate drawAxesForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawXScaleForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawXScaleForGraphViewController:)])
		return [self.delegate drawXScaleForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawCurvesForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawCurvesForGraphViewController:)])
		return [self.delegate drawCurvesForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawLinesForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawLinesForGraphViewController:)])
		return [self.delegate drawLinesForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawAverageForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawAverageForGraphViewController:)])
		return [self.delegate drawAverageForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawMedianForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawMedianForGraphViewController:)])
		return [self.delegate drawMedianForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawIQRForGraphViewController:(id)theGraphViewController {
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawIQRForGraphViewController:)])
		return [self.delegate drawIQRForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawReferencesForGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawReferencesForGraphViewController:)])
		return [self.delegate drawReferencesForGraphViewController:self];
	
	return NO;
}

-(BOOL)drawLabelsInGraphForGraphViewController:(id)theGraphViewController {

	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(drawLabelsInGraphForGraphViewController:)])
		return [self.delegate drawLabelsInGraphForGraphViewController:self];
	
	return NO;
}

#pragma mark Scroll view

-(void)scrollViewDidScroll:(UIScrollView *)theScrollView {
	
	// relatives
	if (self.relatives != nil && self.scrollRelatives) {
	
		for (FCGraphViewController *relative in self.relatives)
			[relative.scrollView setContentOffset:theScrollView.contentOffset];
	}
	
	// twin
	if (self.twin != nil && self.scrollTwin) {
		
		if (self.scrollTwin)
			[twin.scrollView setContentOffset:theScrollView.contentOffset];
	}
}

#pragma mark FCGraphHandleViewDelegate

-(void)handleDidAddOffset:(CGFloat)addend withAnimation:(BOOL)animated {
	
	// resize the view and scroll view frames according to the addend
	
	CGRect viewFrame = self.view.frame;
	CGRect newViewFrame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width - addend, viewFrame.size.height);
	
	CGRect scrollViewFrame = self.scrollView.frame;
	CGRect newScrollViewFrame = CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width - addend, scrollViewFrame.size.height);
	
	if (animated) {
		
		[UIView 
					animateWithDuration:kGraphHandleLockDuration 
						animations:^ { self.view.frame = newViewFrame; self.scrollView.frame = newScrollViewFrame; } ];
		
	} else {
	
		self.view.frame = newViewFrame;
		self.scrollView.frame = newScrollViewFrame;
	}
	
	// if there is a twin, also move and resize it
	
	if (self.twin != nil) {
	
		CGRect twinViewFrame = self.twin.view.frame;
		CGRect newTwinViewFrame = CGRectMake(twinViewFrame.origin.x - addend, twinViewFrame.origin.y, twinViewFrame.size.width + addend, twinViewFrame.size.height);
		
		CGRect twinScrollViewFrame = self.twin.scrollView.frame;
		CGRect newTwinScrollViewFrame = CGRectMake(twinScrollViewFrame.origin.x, twinScrollViewFrame.origin.y, twinScrollViewFrame.size.width + addend, twinScrollViewFrame.size.height);
		
		if (animated) {
			
			[UIView 
						animateWithDuration:kGraphHandleLockDuration 
							animations:^ { self.twin.view.frame = newTwinViewFrame; self.twin.scrollView.frame = newTwinScrollViewFrame; } ];
			
		} else {
		
			self.twin.view.frame = newTwinViewFrame;
			self.twin.scrollView.frame = newTwinScrollViewFrame;
		}
	}
}

-(void)handleReleasedBelowLowerThreshold {
	
	[self unloadTwin];
}

-(void)handleReleasedAboveLowerThreshold {
	
	[self loadTwin];
}

-(void)handleDidTapScrollToBottom {
	
	[self unloadTwin];
}

-(void)handleDidTapScrollToTop {
	
	[self loadTwin];
}

#pragma mark Custom

-(void)loadTwin {
	
	if (self.twin == nil) {
		
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(twinForGraphViewController:)]) {
			
			// get the twin from the delegate
			id candidate = [self.delegate twinForGraphViewController:self];
			if ([candidate isKindOfClass:[FCGraphViewController class]]) {
				
				self.twin = (FCGraphViewController *)candidate;
			
				[self disableButtons];
			}
		}
	}
}

-(void)unloadTwin {
	
	if (self.twin != nil) {
		
		[self.twin.view removeFromSuperview];
		self.twin = nil;
		
		[self enableButtons];
	}
}

-(void)enableButtons {

	if (self.addButton != nil && [self.dataSets count] < 3)
		self.addButton.enabled = YES;
	
	if (self.removeButton != nil)
		self.removeButton.enabled = YES;
}

-(void)disableButtons {
	
	if (self.addButton != nil)
		self.addButton.enabled = NO;
	
	if (self.removeButton != nil)
		self.removeButton.enabled = NO;
}

-(UIColor *)colorForDataSetWithIndex:(NSInteger)index {
	
	if (index == 0)
		return self.baseColor;
	
	UIColor *color = nil;
	
	if (self.delegate != nil &&
		[self.delegate respondsToSelector:@selector(colorForDataSetWithIndex:inGraphViewController:)]) {
	
		color = [self.delegate colorForDataSetWithIndex:index inGraphViewController:self];
	}
	
	if (color == nil) {
	
		NSArray *defaultColors = self.additionalColors;
		
		if (0 < index && index < [defaultColors count]) {
			
			color = [defaultColors objectAtIndex:index];
		
		} else {
			
			srand(time(0));
			NSInteger randomIndex = random() % [defaultColors count];
			color = [defaultColors objectAtIndex:randomIndex];
		}
	}
	
	return color;
}

-(void)createXScaleWithDataRange:(FCDataRange)theDataRange {
/*	Creates a new y scale with the given data range. */
	
	FCGraphScale *newXScale = [[FCGraphScale alloc] initWithDataRange:theDataRange padding:kGraphPadding];
	self.xScale = newXScale;
	[newXScale release];
}

-(void)createYScaleWithDataRange:(FCDataRange)theDataRange {
/*	Creates a new y scale with the given data range. */
	
	FCGraphScale *newYScale = [[FCGraphScale alloc] initWithDataRange:theDataRange padding:kGraphPadding];
	self.yScale = newYScale;
	[newYScale release];
}

-(void)createXScaleWithDateRange:(FCDateRange)theDateRange {
/*	Creates a new x scale with the given date range. 
	Takes date level from delegate or uses own default. */
	
	FCGraphScaleDateLevel level = FCGraphScaleDateLevelHours; // default
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dateLevelForGraphViewController:)])
		level = [self.delegate dateLevelForGraphViewController:self];
	
	FCGraphScale *newXScale = [[FCGraphScale alloc] initWithDateRange:theDateRange level:level padding:kGraphPadding spacing:kGraphSpacing];
	self.xScale = newXScale;
	[newXScale release];
}

-(void)createYScaleWithDateRange:(FCDateRange)theDateRange {
/*	Creates a new y scale with the given date range. 
	Takes date level from delegate or uses own default. */
	
	FCGraphScaleDateLevel level = FCGraphScaleDateLevelHours; // default
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(dateLevelForGraphViewController:)])
		level = [self.delegate dateLevelForGraphViewController:self];
	
	FCGraphScale *newYScale = [[FCGraphScale alloc] initWithDateRange:theDateRange level:FCGraphScaleDateLevelHours padding:kGraphPadding spacing:kGraphSpacing];
	self.xScale = newYScale;
	[newYScale release];
}

-(void)loadPreferences {
/*	Attempts to get all preferences from a delegate. */
	
	if (self.delegate != nil) {
	
		if (self.graphView != nil) {
			
			// grid (overrides x scale below)
			if ([self.delegate respondsToSelector:@selector(drawGridForGraphViewController:)])
				[self.graphView drawGrid:[self.delegate drawGridForGraphViewController:self]];
			
			// axes
			if ([self.delegate respondsToSelector:@selector(drawAxesForGraphViewController:)])
				[self.graphView drawAxes:[self.delegate drawAxesForGraphViewController:self]];
			
			// x scale (only if draw grid has not already been enabled)
			if (!self.graphView.drawXScale && !self.graphView.drawYScale) {
			
				if ([self.delegate respondsToSelector:@selector(drawXScaleForGraphViewController:)])
					[self.graphView setDrawXScale:[self.delegate drawXScaleForGraphViewController:self]];
			}
			
			// curves
			if ([self.delegate respondsToSelector:@selector(drawCurvesForGraphViewController:)])
				[self.graphView setDrawCurves:[self.delegate drawCurvesForGraphViewController:self]];
			
			// lines
			if ([self.delegate respondsToSelector:@selector(drawLinesForGraphViewController:)])
				[self.graphView setDrawLines:[self.delegate drawLinesForGraphViewController:self]];
			
			// average
			if ([self.delegate respondsToSelector:@selector(drawAverageForGraphViewController:)])
				[self.graphView setDrawAverage:[self.delegate drawAverageForGraphViewController:self]];
			
			// references
			if ([self.delegate respondsToSelector:@selector(drawReferencesForGraphViewController:)])
				[self.graphView setDrawReferenceRanges:[self.delegate drawReferencesForGraphViewController:self]];
				 
			// median
			if ([self.delegate respondsToSelector:@selector(drawMedianForGraphViewController:)])
				[self.graphView setDrawMedian:[self.delegate drawMedianForGraphViewController:self]];
			
			// IQR
			if ([self.delegate respondsToSelector:@selector(drawIQRForGraphViewController:)])
				[self.graphView setDrawIQR:[self.delegate drawIQRForGraphViewController:self]];
			
			// labels in graph
			if ([self.delegate respondsToSelector:@selector(drawLabelsInGraphForGraphViewController:)])
				[self.graphView setDrawText:[self.delegate drawLabelsInGraphForGraphViewController:self]];
		}
		
		// scroll relatives
		if ([self.delegate respondsToSelector:@selector(scrollRelativesForGraphViewController:)])
			self.scrollRelatives = [self.delegate scrollRelativesForGraphViewController:self];
		
		// scroll twin
		if ([self.delegate respondsToSelector:@selector(scrollTwinForGraphViewController:)])
			self.scrollTwin = [self.delegate scrollTwinForGraphViewController:self];
	}
}

-(void)reloadPreferences {
/*	First attempts to get all preferences from the delegate and then reloads, redraws or otherwise updates
	all views. */
	
	[self loadPreferences];
	
	// redraw graph view
	[self.graphView setNeedsDisplay];
	
	// update all the entries
	for (NSArray *dataSet in self.dataSets) {
	
		for (FCGraphEntryView *entry in dataSet) {
			
			// get mode from delegate (default is circles)
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(entryViewModeForGraphViewController:)])
				entry.mode = [self.delegate entryViewModeForGraphViewController:self];
			
			[entry position];
			
			[entry setNeedsDisplay];
		}
	}
}

-(void)addDataSet:(FCGraphDataSet *)theDataSet {
/*	Adds the given data set as a separate set and displays them in the graph view.
	The data set is an array of FCGraphEntryView objects. */
	
	// add set to the data sets array
	
	[dataSets addObject:theDataSet];
	
	NSInteger index = [self.dataSets count] - 1;
	
	// add reference ranges to the new data set
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(referenceRangesForGraphSet:inGraphViewController:)]) {
	
		NSArray *ranges = [self.delegate referenceRangesForGraphSet:theDataSet inGraphViewController:self];
		
		for (FCGraphReferenceRange *range in ranges)
			[theDataSet addYReferenceRange:range];
	}
	
	// get a color for the data set 
	
	UIColor *color = [self colorForDataSetWithIndex:index];
	
	// setup and display the new entry objects
	
	for (FCGraphEntryView *entry in theDataSet) {
		
		entry.delegate = self;
		
		// getting mode from delegate (default is circles)
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(entryViewModeForGraphViewController:)])
			entry.mode = [self.delegate entryViewModeForGraphViewController:self];
		
		entry.color = color;
		entry.anchor = [self.graphView positionForX:[entry.xValue doubleValue] y:[entry.yValue doubleValue]];
		
		[self.graphView addSubview:entry];
	}
	
	if (self.twin == nil) {
		
		// load and display a label (index of 0 corresponds to base label and that is already added by default)
		if (index > 0)
			[self loadLabelForDataSetWithIndex:index];
	
		// load add and remove buttons
		[self loadButtonsForDataSetWithIndex:index];
	}
	
	// make sure the graph view has a pointer reference
	
	if (self.graphView.dataSetsRef == nil)
		self.graphView.dataSetsRef = self.dataSets;
	
	// make sure graph view is redrawn to show correct elements
	// and that the add butotn is disabled if we reach the 
	// maximum allowed number of data sets
	
	if ([self.dataSets count] > 1) {
		
		[self.graphView setNeedsDisplay];
		
		if ([self.dataSets count] > 2)
			self.addButton.enabled = NO;
	}
	
	// if there are no relatives or any twin and this was the first added data set, then
	// scroll to the last entry in data set
	
	if (self.relatives == nil && self.twin == nil && [self.dataSets count] == 1)
		[self scrollToLastEntryInDataSet:theDataSet];
}

-(void)scrollToLastEntryInDataSet:(FCGraphDataSet *)theDataSet {

	[self scrollToEntryView:[theDataSet lastObject]];
}

-(void)scrollToEntryView:(FCGraphEntryView *)theEntryView {
	
	CGFloat targetPointX = theEntryView.center.x;
	
	CGFloat height = self.scrollView.frame.size.width;
	CGFloat width = self.scrollView.frame.size.width;
	
	CGFloat xPos = targetPointX - (width/4)*3; // one quarter of the visible area from the edge
	CGFloat yPos = 0.0f;
	
	CGRect frame = CGRectMake(xPos, yPos, width, height);
	
	[self.scrollView scrollRectToVisible:frame animated:YES];
}

-(void)validateDataRange:(FCDataRange)theDataRange dateRange:(FCDateRange)theDateRange {
	
	BOOL dataRangeIsValid = [self evaluateDataRange:theDataRange];
	NSAssert1(dataRangeIsValid, @"FCGraphViewController -validateDataRange:dateRange: || %@", @"Failed to load graph because data range is not valid!");
	
	BOOL dateRangeIsValid = [self evaluateDateRange:theDateRange];
	NSAssert1(dateRangeIsValid, @"FCGraphViewController -validateDataRange:dateRange: || %@", @"Failed to load graph because date range is not valid!");
}

-(BOOL)evaluateDataRange:(FCDataRange)theDataRange {

	if (theDataRange.minimum >= theDataRange.maximum)
		return NO;
	
	return YES;
}

-(BOOL)evaluateDateRange:(FCDateRange)theDateRange {
	
	if (theDateRange.interval <= 0)
		return NO;
	
	return YES;
}

@end
