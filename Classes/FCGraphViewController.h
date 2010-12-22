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
//  FCGraphViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 22/09/2010.
//


#import "FCViewFramework.h"

#import "FCGraphView.h"
#import "FCGraphScaleView.h"
#import "FCGraphEntryView.h"
#import "FCGraphScale.h"
#import "FCGraphDataSet.h"
#import "FCGraphReferenceRange.h"

@interface FCGraphViewController : UIViewController <FCGraphDelegate, FCGraphEntryViewDelegate, FCGraphHandleViewDelegate, UIScrollViewDelegate> {
	
	id <FCGraphDelegate> delegate;
	
	NSMutableArray *relatives;
	BOOL scrollRelatives;
	
	FCGraphViewController *twin;
	BOOL scrollTwin;
	
	FCGraphMode mode;
	NSString *key;
	
	FCGraphScale *yScale;
	FCGraphScaleView *yScaleView;
	
	FCGraphScale *xScale;
	FCGraphScaleView *xScaleView;

	FCGraphView *graphView;
	UIScrollView *scrollView;
	
	FCBorderedLabel *label;
	NSMutableArray *additionalLabels;
	UIColor *baseColor;
	NSArray *additionalColors;

	NSMutableArray *dataSets;
}

@property (assign) id <FCGraphDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *relatives;
@property (nonatomic) BOOL scrollRelatives;

@property (nonatomic, retain) FCGraphViewController *twin;
@property (nonatomic) BOOL scrollTwin;

@property (nonatomic) FCGraphMode mode;
@property (nonatomic, retain) NSString *key;

@property (nonatomic, retain) FCGraphScale *yScale;
@property (nonatomic, retain) FCGraphScaleView *yScaleView;

@property (nonatomic, retain) FCGraphScale *xScale;
@property (nonatomic, retain) FCGraphScaleView *xScaleView;

@property (nonatomic, retain) FCGraphView *graphView;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) FCBorderedLabel *label;
@property (nonatomic, retain) NSMutableArray *additionalLabels;
@property (nonatomic, retain) UIColor *baseColor;
@property (nonatomic, retain) NSArray *additionalColors;

@property (nonatomic, retain) NSMutableArray *dataSets;

// Init

-(id)initWithFrame:(CGRect)theFrame;

// View

-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange;
-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange withAncestor:(FCGraphViewController *)theAncestor;
-(void)loadTimePlotHorizontalGraphForDataRange:(FCDataRange)theDataRange withinDateRange:(FCDateRange)theDateRange withTwin:(FCGraphViewController *)theTwin;
-(void)loadTimeBandHorizontalGraphForDataRange:(FCDataRange)theDataRange withingDateRange:(FCDateRange)theDateRange;
-(void)loadTimeBandHorizontalGraphForDataRange:(FCDataRange)theDataRange withingDateRange:(FCDateRange)theDateRange withAncestor:(FCGraphViewController *)theAncestor;

-(void)loadGraphViewWithLength:(CGFloat)actualLength height:(CGFloat)height;

-(void)loadXScaleViewWithLength:(CGFloat)actualLength yOffset:(CGFloat)yOffset;
-(void)loadYScaleViewWithHeight:(CGFloat)height;

-(void)loadReferenceRanges;

-(void)loadBaseLabel;
-(void)loadLabelForDataSetWithIndex:(NSInteger)index;

-(void)didFinishLoadingGraph;

// Animation

-(void)animatePulseForAllEntryViewsInDataSet:(NSArray *)theDataSet;

// Custom

-(void)loadTwin;
-(void)unloadTwin;

-(UIColor *)colorForDataSetWithIndex:(NSInteger)index;

-(void)createXScaleWithDataRange:(FCDataRange)theDataRange;
-(void)createYScaleWithDataRange:(FCDataRange)theDataRange;

-(void)createXScaleWithDateRange:(FCDateRange)theDateRange;
-(void)createYScaleWithDateRange:(FCDateRange)theDateRange;

-(void)loadPreferences;
-(void)reloadPreferences;

-(void)addDataSet:(FCGraphDataSet *)theDataSet;

-(void)scrollToLastEntryInDataSet:(FCGraphDataSet *)theDataSet;
-(void)scrollToEntryView:(FCGraphEntryView *)theEntryView;

-(void)validateDataRange:(FCDataRange)theDataRange dateRange:(FCDateRange)theDateRange;
-(BOOL)evaluateDataRange:(FCDataRange)theDataRange;
-(BOOL)evaluateDateRange:(FCDateRange)theDateRange;

@end