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
//  FCAppOverlayViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//


#import "FCAppViewController.h" // superclass

@interface FCAppOverlayViewController : FCAppViewController {

	FCAppViewController *parent;
	
	BOOL isOpaque;
	BOOL navigationControllerFadesInOut;
	BOOL shouldAnimateContent;
	BOOL shouldAnimateToCoverTabBar;
}

@property (assign) FCAppViewController *parent;

@property (nonatomic) BOOL isOpaque;
@property (nonatomic) BOOL navigationControllerFadesInOut;
@property (nonatomic) BOOL shouldAnimateContent;
@property (nonatomic) BOOL shouldAnimateToCoverTabBar;

// Animation
-(void)animateFadeIn;
-(void)animateFadeOut;
-(void)animateFadeInAndCover;
-(void)animateFadeOutAndUncover;

// Custom
-(void)present;
-(void)transitionTo:(FCAppOverlayViewController *)anotherOverlayViewController;
-(void)dismiss;

// Placeholders
-(void)createUIContent;
-(void)showUIContent;
-(void)presentUIContent;
-(void)updateUIContent;
-(void)dismissUIContent;
-(void)removeUIContent;

@end
