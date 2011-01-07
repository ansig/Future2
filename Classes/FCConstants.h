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
//  FCConstants.h
//  Future2
//
//  Created by Anders Sigfridsson on 01/06/2010.
//

/* SIMPLE */

#define kAppCommonLabelFont		[UIFont fontWithName:@"Helvetica" size:18.0f]
#define kAppBoldCommonLabelFont	[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]
#define kAppLargeLabelFont		[UIFont fontWithName:@"Helvetica-Bold" size:36.0f]
#define kAppSmallLabelFont		[UIFont fontWithName:@"Helvetica" size:14.0f]

#define kGraphFont				[UIFont fontWithName:@"Helvetica" size:12.0f]
#define kGraphLabelFont			[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]

#define kAppSpacing				15.0f // standard distance between any UI element (button, label, text view, image, etc) and any other UI element and screen edge
#define kAppAdjacentSpacing		10.0f  // distance between any UI element and another UI element to which it is visually associated (e.g. a timestamp label and its edit-button)
#define kAppHeaderHeight		60.0f // distance between navigation bar and body content (often contains icon, timestamp and edit-button)

#define kGraphPadding		12.5f // minimum distance to all edges in the graph view (should be about half kGraphEntryViewDiameter)
#define kGraphSpacing		50.0f // minimum distance between date-time units in the graph

#define kGraphGridAlpha		0.5f // level of opaqueness for graph grid
#define kGraphAxisAlpha		1.0f // level of opaqueness for graph axis lines

#define kGraphLinesAlpha	1.0f // level of opaqueness for data set lines
#define kGraphLinesWidth	2.0f // thickness of data set lines

#define kGraphAverageAlpha	0.5f // level of opaqueness for data set average lines
#define kGraphAverageWidth	1.0f // thickness of data set average lines

#define kGraphMedianAlpha	0.5f // level of opaqueness for data set median lines
#define kGraphMedianWidth	1.0f // thickness of data set median lines

#define kGraphZoneAlpha		0.25f // level of opaqueness for background zones in graphs (e.g. common and IQR range)

#define kGraphLabelSpacing	250.0f // distance between each in-graph label that is drawn along the same line

#define kScaleViewSize		20.0f // height/width of horizontal/vertical graph scale views

#define kGraphAppHeader		40.0f // space between top of screen and graphs in the graph application
#define kGraphAppPadding	2.0f // space between each visible graph and the edges
#define kGraphBandHeight	(kGraphPadding * 2) + kGraphEntryViewDiameter + kScaleViewSize // height of a graph in band mode

#define kGraphEntryViewDiameter		25.0f // diameter of graph entry views (should be about twice the size of kGraphPadding)
#define kGraphEntryViewGrowthScale	1.5f // the scale size which an entry view grows eg. when pulsing or on touch

#define kGraphHandleSize			CGSizeMake(80.0f, 20.0f) // width and height of a standard graph handle
#define kGraphHandleRange			240.0f // the distance which the graph handles can move
#define kGraphHandleLowerThreshold	FCGraphHandleThresholdQuarter; // the fractional distance from the starting point at which the handle locks to the side
#define kGraphHandleUpperThreshold	FCGraphHandleThresholdNone; // the fractional distance from the end point at which the handle locks to the side

#define kGraphEntryInfoViewSize		CGSizeMake(300.0f, 120.0f) // the size of the box which contains entry info in the graph application
#define kGraphEntryInfoViewPadding	10.0f // the minimum distance between any edge of the info box to any side of the screen as well as the entry object itself

#define kGraphPullMenuSize			CGSizeMake(320.0f, 280.0f) // size of the pull down menu in the graph application
#define kGraphPullMenuHandleSize	CGSizeMake(250.0f, 30.0f) // size of the pull down menus handle
#define kGraphPullMenuHandleRange	280.0f // the distance which the pull down menu handle can be moved (should correspond to height of kGraphPullMenuSize)
#define kGraphPullMenuHandleLowerThreshold	FCGraphHandleThresholdQuarter; // the fractional distance from the starting point at which the handle locks to the side
#define kGraphPullMenuHandleUpperThreshold	FCGraphHandleThresholdOpposite;	// the fractional distance from the end point at which the handle locks to the side
																			// ("Opposite" means that the reverse threshold is used (e.g. lower for upper and vice versa)

#define kGraphHandleLockDuration	0.25f // duration of the animation when handle views lock to a side

#define kTintColor				[UIColor colorWithRed:0.54509f green:0.81568f blue:0.6666667f alpha:1.0f]
#define kDarkColor				[UIColor colorWithRed:0.12156f green:0.12156f blue:0.12156f alpha:1.0f]
#define kButtonTitleColor		kTintColor

#define kViewAppearDuration		0.5f // duration of view appearance animations
#define kViewDisappearDuration	0.5f // duration of view disappearance animations
#define kViewDisappearDelay		0.25f // delay before views animated disappearance that allows for UI elements to be dismissed (should correspond roughly to kDisappearDuration)

#define kAppearDuration		0.25f // duration for UI elements (eg date pickers) to animate onto screen
#define kDisappearDuration	0.25f // duration for UI elements (eg date pickers) to animate off screen

#define kGrowthDuration		0.1f // duration of the growth animation for views in both app and graph (should be related to kShrinkDuration)
#define kShrinkDuration		0.3f // duration of the shrink animation for views in both app and graph (should be related to kGrowthDuration)
#define kGrowthScale		1.5f // default scale to which views grow eg when pulsating

#define kPerceptionDelay	0.5f // delay until animations that the user should be made aware of are executed (makes sure they see it)

#define kProfilePageHealth				@"Health"
#define kProfilePagePersonal			@"Personal"

#define kProfileSectionDiabetes			@"Diabetes info"
#define kProfileSectionInsulin			@"Insulin info"
#define kProfileSectionHealth			@"Health info"
#define kProfileSectionPersonal			@"Personal info"
#define kProfileSectionContact			@"Contact info"

#define kProfileItemDiabetesType		@"Type"
#define kProfileItemDiabetesDiagnosed	@"Date diagnosed"

#define kProfileItemInsulinRapid		@"Rapid insulin"
#define kProfileItemInsulinBasal		@"Basal insulin"
#define kProfileItemInjectionPen		@"Insulin pen"
#define kProfileItemInjectionPump		@"Insulin pump"

#define kProfileItemDateOfBirth			@"Date of birth"
#define kProfileItemAge					@"Age"
#define kProfileItemHeight				@"Height"
#define kProfileItemWeight				@"Weight"

#define kProfileItemFirstName			@"First name"
#define kProfileItemSurname				@"Surname"
#define kProfileItemEmail				@"Email"

#define kProfileItemPersonalContact		@"Personal"
#define kProfileItemGPContact			@"GP"
#define kProfileItemEmergencyContact	@"Emergency"

#define kSettingsSectionProfile			@"Profile"
#define kSettingsSectionGeneral			@"General"
#define kSettingsSectionAbout			@"About TiY"

#define kSettingsItemHeightWeightSystem	@"Height/weight"
#define kSettingsItemConvertLog			@"Auto convert"
#define kSettingsItemRearrangeProfile	@"Rearrange profile page"
#define kSettingsItemUsernamePassword	@"Username/Password"
#define kSettingsItemAgeDisplay			@"Age display"

#define kSettingsItemDefaultTab			@"Startup tab"

#define kSettingsItemProjectInfo		@"Project"
#define kSettingsItemLicenseInfo		@"Code license"
#define kSettingsItemSourceInfo			@"Source code"

#define kSettingsItemDateLevel			@"View"
#define kSettingsItemScrollRelatives	@"Lock scroll"
#define kSettingsItemLabelsInGraph		@"Labels in graph"

#define kSettingsItemDrawGrid			@"Grid"
#define kSettingsItemDrawAxes			@"Axes"
#define kSettingsItemDrawXScale			@"Timescale"
#define kSettingsItemDrawLines			@"Lines"
#define kSettingsItemDrawCurves			@"Curves"
#define kSettingsItemDrawAverage		@"Average"
#define kSettingsItemDrawMedian			@"Median"
#define kSettingsItemDrawIQR			@"IQR range"
#define kSettingsItemDrawReferences		@"Reference ranges"
#define kSettingsItemEntryViewMode		@"Show"

/* MACROS */

#define degreesToRadian(x)		(M_PI * x / 180.0)

/* COMPLEX */

@interface FCConstants

// * Keys

extern NSString * const FCKeyCIDGlucose;
extern NSString * const FCKeyCIDRapidInsulin;
extern NSString * const FCKeyCIDBasalInsulin;

extern NSString * const FCKeyCIDNote;
extern NSString * const FCKeyCIDPhoto;

extern NSString * const FCKeyCIDWeight;

extern NSString * const FCKeyUIDGlucoseMillimolesPerLitre;
extern NSString * const FCKeyUIDGlucoseMilligramsPerDecilitre;

extern NSString * const FCKeyUIDKilogram;
extern NSString * const FCKeyUIDPound;

extern NSString * const FCKeyUIDCentimetre;
extern NSString * const FCKeyUIDInch;
extern NSString * const FCKeyUIDFoot;

extern NSString * const FCKeyUIDInsulinUnits;

extern NSString * const FCKeyUIDCarbohydrates;
extern NSString * const FCKeyUIDProtein;
extern NSString * const FCKeyUIDFat;

extern NSString * const FCKeyDIDString;
extern NSString * const FCKeyDIDInteger;
extern NSString * const FCKeyDIDDecimal;

// * Defaults

// profile

extern NSString * const FCDefaultProfileUsername; // string object
extern NSString * const FCDefaultProfileEmail; // string object

extern NSString * const FCDefaultProfileFirstName; // string object
extern NSString * const FCDefaultProfileSurname; // string object
extern NSString * const FCDefaultProfileDateOfBirth; // date object

extern NSString * const FCDefaultProfilePersonalContact; // string object
extern NSString * const FCDefaultProfileGPContact; // string object
extern NSString * const FCDefaultProfileEmergencyContact; // string object

extern NSString * const FCDefaultProfileDiabetesType; // string object
extern NSString * const FCDefaultProfileDiabetesDateDiagnosed; // date object

extern NSString * const FCDefaultProfileBasalInsulin; // string object
extern NSString * const FCDefaultProfileRapidInsulin; // string object
extern NSString * const FCDefaultProfileInjectionPen; // string object
extern NSString * const FCDefaultProfileInjectionPump; // string object

extern NSString * const FCDefaultProfileHeight; // number object (always saved in cm)

// settings

extern NSString * const FCDefaultHeightWeigthSystem; // integer
extern NSString * const FCDefaultConvertLog; // boolean
extern NSString * const FCDefaultTabBarIndex; // integer
extern NSString * const FCDefaultShowLog; // boolean
extern NSString * const FCDefaultAgeDisplay; // integer

// log/graph

extern NSString * const FCDefaultLogDates; // dictionary with date objects
extern NSString * const FCDefaultLogSortBy; // integer
extern NSString * const FCDefaultGraphs; // array of dictionary objects

extern NSString * const FCDefaultGraphSettingScrollRelatives; // boolean
extern NSString * const FCDefaultGraphSettingDateLevel; // integer
extern NSString * const FCDefaultGraphSettingLabelsInGraph; // boolean

// * Notifications

extern NSString * const FCNotificationRotationAllowed;
extern NSString * const FCNotificationRotationNotAllowed;

extern NSString * const FCNotificationRegistrationCompleted;

extern NSString * const FCNotificationUserDefaultsUpdated;

extern NSString * const FCNotificationConvertLogOrUnitChanged;

extern NSString * const FCNotificationGraphSetsChanged;
extern NSString * const FCNotificationGraphPreferencesChanged;
extern NSString * const FCNotificationGraphOptionsChanged;
extern NSString * const	FCNotificationGraphLogDateSelectorDismissed;

extern NSString * const FCNotificationLogDateChanged;

extern NSString * const FCNotificationEntryCreated;
extern NSString * const FCNotificationEntryUpdated;
extern NSString * const FCNotificationEntryObjectUpdated;
extern NSString * const FCNotificationEntryDeleted;

extern NSString * const FCNotificationCategoryCreated;
extern NSString * const FCNotificationCategoryUpdated;
extern NSString * const FCNotificationCategoryObjectUpdated;
extern NSString * const FCNotificationCategoryDeleted;

extern NSString * const FCNotificationAttachmentAdded;
extern NSString * const FCNotificationAttachmentObjectAdded;
extern NSString * const FCNotificationAttachmentRemoved;
extern NSString * const FCNotificationAttachmentObjectRemoved;

// * Formats

extern NSString * const FCFormatTimestamp;
extern NSString * const FCFormatDate;

// * Database

extern NSString * const FCDatabaseName;

@end
