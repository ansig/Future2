//
//  FCAppLogDateSelectorViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 21/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FCAppCustomViewController.h"
#import "TKCalendarMonthView.h"
#import "NSDate+TKCategory.h"

@interface FCAppLogDateSelectorViewController : FCAppCustomViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource> {

	TKCalendarMonthView *calendarMonthView;
	NSDate *lastSelectedDate;
	BOOL lastSetWasStartDate;
}

@property (nonatomic, retain) TKCalendarMonthView *calendarMonthView;

@property (nonatomic, retain) NSDate *lastSelectedDate;
@property (nonatomic) BOOL lastSetWasStartDate;

@end
