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
//  FCGraphLogDateSelectorViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 06/01/2011.
//


#import "TKGlobal.h"
#import "FCCalendarDelegate.h"
#import "TKCalendarMonthView.h"
#import "NSDate+TKCategory.h"

@interface FCGraphLogDateSelectorViewController : UIViewController {

	TKCalendarMonthView *calendarMonthView;
	FCCalendarDelegate *calendarDelegate;
	
	UIButton *doneButton;
}

@property (nonatomic, retain) TKCalendarMonthView *calendarMonthView;
@property (nonatomic, retain) FCCalendarDelegate *calendarDelegate;

@property (nonatomic, retain) UIButton *doneButton;

-(void)presentUIContent;
-(void)dismissUIContent;

-(void)save;

@end
