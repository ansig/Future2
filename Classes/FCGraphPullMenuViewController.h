//
//  FCGraphPullMenuViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 08/10/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "FCDatabaseHandler.h"
#import "FCCategory.h"

@interface FCGraphPullMenuViewController : UIViewController <FCGraphHandleViewDelegate, FCGroupedTableSourceDelegate> {

	FCGraphMenuMode mode;
	
	NSMutableArray *sectionTitles;
	NSMutableArray *sections;
	
	UITableView *tableView;
	
	UIButton *selectButton;
	UIButton *reorderButton;
	UIButton *optionsButton;
	UIButton *doneButton;
	
	NSMutableArray *selectedIndexPaths;
	NSMutableArray *storedSections;
	
	BOOL pendingChanges;
}

@property (nonatomic) FCGraphMenuMode mode;

@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) NSMutableArray *sections;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) UIButton *selectButton;
@property (nonatomic, retain) UIButton *reorderButton;
@property (nonatomic, retain) UIButton *optionsButton;
@property (nonatomic, retain) UIButton *doneButton;

@property (nonatomic, retain) NSMutableArray *selectedIndexPaths;
@property (nonatomic, retain) NSMutableArray *storedSections;

@property (nonatomic) BOOL pendingChanges;

// View

-(void)loadDoneButtonForCurrentMode;
-(void)reloadVisibleRows;

// Notifications

-(void)onSwitchValueChanged;
-(void)onSegmentControlValueChanged;

// Custom

-(void)saveDefaultState;

-(void)loadNormalMode;

-(void)loadSelectionMode;
-(void)unloadSelectionMode;

-(void)loadGraphOptionsMode;
-(void)unloadGraphOptionsMode;

-(void)loadGeneralOptionsMode;
-(void)unloadGeneralOptionsMode;

-(void)loadReorderMode;
-(void)unloadReorderMode;

@end
