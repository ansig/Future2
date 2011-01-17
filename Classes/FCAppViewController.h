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
//  FCAppViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//


#import "MBProgressHUD.h"

@interface FCAppViewController : UIViewController <MBProgressHUDDelegate> {

	UINavigationController *overlaidNavigationController;
	
	MBProgressHUD *_progressHUD;
}

@property (nonatomic, retain) UINavigationController *overlaidNavigationController;

// Custom

-(void)presentOverlayViewController:(id)anOverlayViewController;
-(void)replaceOverlayViewControllerWith:(id)anotherOverlayViewController;
-(void)dismissOverlayViewController;

-(void)performTask:(SEL)task;
-(void)performTask:(SEL)task withMessage:(NSString *)message;
-(void)performTask:(SEL)task withObject:(id)object;
-(void)performTask:(SEL)task withObject:(id)object message:(NSString *)message;

@end
