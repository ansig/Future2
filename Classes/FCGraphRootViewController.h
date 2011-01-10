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
//  FCGraphRootViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 28/07/2010.
//


#import <QuartzCore/QuartzCore.h>

#import "FCGraphViewController.h"
#import "FCGraphPullMenuViewController.h"
#import "FCGraphLogDateSelectorViewController.h"
#import "FCGraphEntryInfoView.h"
#import "FCGraphHandleView.h"
#import "FCIOFramework.h"
#import "FCFunctionsFramework.h"
#import "FCViewFramework.h"
#import "FCModelsFramework.h"
#import "MBProgressHUD.h"

@interface FCGraphRootViewController : UIViewController <FCGraphDelegate, MBProgressHUDDelegate> {
	
	UIButton *logDatesButton;
	FCGraphLogDateSelectorViewController *logDateSelectorViewController;
	
	UIScrollView *scrollView;
	
	NSMutableArray *graphControllers;
	NSMutableArray *graphHandles;
	
	FCGraphEntryInfoView *entryInfoView;
	
	FCGraphPullMenuViewController *pullMenuViewController;
	FCGraphHandleView *pullMenuHandleView;
	
	CGFloat _initialScale;
	CGFloat _changedScale;
	
	MBProgressHUD *_progressHUD;
}

@property (nonatomic, retain) UIButton *logDatesButton;
@property (nonatomic, retain) FCGraphLogDateSelectorViewController *logDateSelectorViewController;

@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *graphControllers;
@property (nonatomic, retain) NSMutableArray *graphHandles;

@property (nonatomic, retain) FCGraphEntryInfoView *entryInfoView;

@property (nonatomic, retain) FCGraphPullMenuViewController *pullMenuViewController;
@property (nonatomic, retain) FCGraphHandleView *pullMenuHandleView;

// View

-(void)loadLogDateSelectorViewController;
-(void)dismissLogDateSelectorViewController;

// Notifications

-(void)onGraphSetsChangedNotification;
-(void)onGraphPreferencesChangedNotification;
-(void)onGraphOptionsChangedNotification;
-(void)onGraphLogDateSelectorDismissedNotification;

// Gestures

- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;

// Custom

-(void)loadDefaultStateWithProgressHUD;
-(void)loadDefaultState;
-(void)unloadCurrentState;

-(void)createDefaultGraph;

-(FCGraphViewController *)createGraphControllerWithFrame:(CGRect)frame
													mode:(FCGraphMode)theMode
													 key:(NSString *)theKey
											   startDate:(NSDate *)theStartDate
												 endDate:(NSDate *)theEndDate
										  ancestorOrTwin:(FCGraphViewController *)theRelative;

-(FCGraphHandleView *)createHandleForGraphController:(FCGraphViewController *)theGraphController;

-(NSArray *)loadEntriesWithCID:(NSString *)theCID betweenStartDate:(NSDate *)theStartDate endDate:(NSDate *)theEndDate;
-(NSDictionary *)findMinMaxAmong:(NSArray *)entries;

-(void)setLogDatesLabel;

@end
