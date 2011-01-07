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
//  FCRootViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 06/08/2010.
//

@interface FCRootViewController : UIViewController {

	UIActivityIndicatorView *activityIndicator;
	UILabel *statusLabel;
	
	BOOL rotationIsAllowed;
	BOOL isShowingLandscapeView;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic) BOOL rotationIsAllowed;
@property (nonatomic) BOOL isShowingLandscapeView;

// Views

-(void)loadApplication;
-(void)loadApplicationViewController;
-(void)loadGraphViewController;
-(void)loadRegistrationViewController;

// Orientation

-(void)onOrientationChangeNotification;
-(void)onRotationAllowedNotification;
-(void)onRotationNotAllowedNotification;
-(void)onRegistrationCompleteNotification;

-(void)setLogDatesToNow;

@end
