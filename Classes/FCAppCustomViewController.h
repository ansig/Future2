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
//  FCAppCustomViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 13/09/2010.
//

#import <UIKit/UIKit.h>

#import "FCEntry.h"

@interface FCAppCustomViewController : UIViewController {

	FCEntry *entry;
	
	BOOL cancelled;
	BOOL opaque;
	BOOL navigationControllerFadesOut;
}

@property (nonatomic, retain) FCEntry *entry;

@property (nonatomic) BOOL cancelled;
@property (nonatomic) BOOL opaque;
@property (nonatomic) BOOL navigationControllerFadesOut;

// Init
-(id)initWithEntry:(FCEntry *)theEntry;

// Animation
-(void)animateFadeIn;
-(void)animateFadeOut;
-(void)animateFadeInAndCover;
-(void)animateFadeOutAndUncover;

// Custom
-(void)dismiss;
-(void)dismissUIElements;

@end
