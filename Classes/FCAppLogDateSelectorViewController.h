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

@interface FCAppLogDateSelectorViewController : FCAppCustomViewController {

	UIDatePicker *datePickerView;
	UILabel *startDateLabel;
	UILabel *endDateLabel;
	UILabel *separatorLabel;
}

@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) UILabel *startDateLabel;
@property (nonatomic, retain) UILabel *endDateLabel;
@property (nonatomic, retain) UILabel *separatorLabel;

// Custom

-(void)setLabels;

@end
