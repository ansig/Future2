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

/*
 *  FCProtocols.h
 *  Future2
 *
 *  Created by Anders Sigfridsson on 07/02/2010.
 *
 */

@protocol FCGroupedTableDataSource <UITableViewDataSource>
/* For classes that act as a data source for table views with sections. */

@required
-(void)loadSectionsAndRows;

@end

@protocol FCGroupedTableSourceDelegate <UITableViewDelegate, UITableViewDataSource>
/* For classes that act as both delegte and data source for table views with sections. */

@required
-(void)loadSectionsAndRows;

@end

@protocol FCPlainTableSourceDelegate <UITableViewDelegate, UITableViewDataSource>
/*	For classes that act as both delegate and data source for plain table views. */

@required
-(void)loadRows;

@end

@protocol FCEntryList
/* For view controller classes that display a list of entries of different categories. */

@required
-(void)onEntryCreatedNotification;
-(void)onEntryUpdatedNotification;
-(void)onEntryDeletedNotification;
-(void)onAttachmentAddedNotification;
-(void)onAttachmentRemovedNotification;
-(void)onCategoryUpdatedNotification;

@end

@protocol FCEntryView
/* For view controller classes that display a single entry. */

@optional
-(void)onEntryObjectUpdatedNotification;
-(void)onEntryUpdatedNotification;
-(void)onCategoryUpdatedNotification;
-(void)onAttachmentAddedNotification;
-(void)onAttachmentObjectAddedNotification;
-(void)onAttachmentRemovedNotification;
-(void)onAttachmentObjectRemovedNotification;

@end

@protocol FCCategoryList
/* For view controller classes that display a list with categories sorted by owner */

@required
-(void)onCategoryCreatedNotification;
-(void)onCategoryUpdatedNotification;
-(void)onCategoryObjectUpdatedNotification;
-(void)onCategoryDeletedNotification;

@optional
-(void)onEntryCreatedNotification;
-(void)onEntryUpdatedNotification;
-(void)onEntryDeletedNotification;

@end

@protocol FCCategoryView
/* For view controller classes that display a single category. */

@required
-(void)onCategoryUpdatedNotification;

@end


@protocol FCAttachmentsDisplay
/* For view controller classes that display a single entry with a list of attachments (entries of different categories). */

@required
-(void)onAttachmentAddedNotification;
-(void)onAttachmentRemovedNotification;

@end

@protocol FCProfileDisplay <UITableViewDelegate, UIScrollViewDelegate>
/* For view controllers that display info from the default user profile */

@required
-(void)onUserDefaultsUpdate;

@end

@protocol FCGraphDelegate <NSObject>
/* For classes which act as delegates to graph view controllers. */

@optional

// Appearance
-(NSString *)labelTitleForGraphViewController:(id)theGraphViewController;
-(UIImage *)labelIconForGraphViewController:(id)theGraphViewController;
-(UIColor *)baseColorForGraphViewController:(id)theGraphViewController;
-(UIColor *)colorForDataSetWithIndex:(NSInteger)index inGraphViewController:(id)theGraphViewController;
-(NSString *)labelTitleForDataSetWithIndex:(NSInteger)index inGraphViewController:(id)theGraphViewController;
-(UIImage *)labelIconForDataSetWithIndex:(NSInteger)index inGraphViewController:(id)theGraphViewController;
-(UIImage *)iconForEntryViewWithKey:(NSString *)theKey;

// Graph
-(FCGraphScaleDateLevel)dateLevelForGraphViewController:(id)theGraphViewController;
-(FCGraphEntryViewMode)entryViewModeForGraphViewController:(id)theGraphViewController;
-(NSArray *)referenceRangesForGraphSet:(id)theGraphSet inGraphViewController:(id)theGraphViewController;
-(id)twinForGraphViewController:(id)theController;

// Preferences
-(BOOL)scrollRelativesForGraphViewController:(id)theGraphViewController;
-(BOOL)scrollTwinForGraphViewController:(id)theGraphViewController;
-(BOOL)drawGridForGraphViewController:(id)theGraphViewController;
-(BOOL)drawAxesForGraphViewController:(id)theGraphViewController;
-(BOOL)drawXScaleForGraphViewController:(id)theGraphViewController;
-(BOOL)drawCurvesForGraphViewController:(id)theGraphViewController;
-(BOOL)drawLinesForGraphViewController:(id)theGraphViewController;
-(BOOL)drawAverageForGraphViewController:(id)theGraphViewController;
-(BOOL)drawMedianForGraphViewController:(id)theGraphViewController;
-(BOOL)drawIQRForGraphViewController:(id)theGraphViewController;
-(BOOL)drawReferencesForGraphViewController:(id)theGraphViewController;
-(BOOL)drawLabelsInGraphForGraphViewController:(id)theGraphViewController;

// Interaction
-(void)touchOnEntryWithAnchorPoint:(CGPoint)theAnchor superview:(UIView *)theSuperview key:(NSString *)theKey;

@end

@protocol FCGraphEntryViewDelegate <NSObject>
/* For classes that act as delegates for entry info views. */

@required
-(void)touchOnEntryWithAnchorPoint:(CGPoint)theAnchor superview:(UIView *)theSuperview key:(NSString *)theKey;
-(CGSize)sizeForEntryViewWithAnchor:(CGPoint)theAnchor;
-(UIImage *)iconForEntryViewWithKey:(NSString *)theKey;

@end

@protocol FCGraphHandleViewDelegate <NSObject>
/* For classes that act as delegates for handle views. */

@optional
-(void)handleWillAddOffset:(CGFloat)addend withAnimation:(BOOL)animated;
-(void)handleDidAddOffset:(CGFloat)addend withAnimation:(BOOL)animated;
-(void)handleReleasedBelowLowerThreshold;
-(void)handleReleasedAboveLowerThreshold;
-(void)handleReleasedBelowUpperThreshold;
-(void)handleReleasedAboveUpperThreshold;
-(void)handleDidTapScrollToBottom;
-(void)handleDidTapScrollToTop;

@end