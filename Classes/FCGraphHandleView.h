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
//  FCGraphHandleView.h
//  Future2
//
//  Created by Anders Sigfridsson on 06/10/2010.
//

#import <UIKit/UIKit.h>


@interface FCGraphHandleView : UIView {

	id <FCGraphHandleViewDelegate> delegate;
	
	FCGraphHandleMode mode;
	
	CGFloat range;
	CGFloat offset;
	FCGraphHandleThreshold lowerThreshold;
	FCGraphHandleThreshold upperThreshold;

	CGFloat cornerRadius;
	
	UIColor *color;
	UILabel *label;
}

@property (assign) id <FCGraphHandleViewDelegate> delegate;

@property (nonatomic) FCGraphHandleMode mode;

@property (nonatomic) CGFloat range;
@property (nonatomic) CGFloat offset;
@property (nonatomic) FCGraphHandleThreshold lowerThreshold;
@property (nonatomic) FCGraphHandleThreshold upperThreshold;

@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UILabel *label;

// Animation

-(void)animateToNewFrame:(CGRect)newFrame;

// Custom

-(void)addOffset:(CGFloat)addend withAnimation:(BOOL)animated;

-(BOOL)isBelowLowerThreshold;
-(BOOL)isAboveUpperThreshold;

-(void)createNewLabelWithText:(NSString *)text;

@end
