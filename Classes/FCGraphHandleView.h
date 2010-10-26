//
//  FCGraphHandleView.h
//  Future2
//
//  Created by Anders Sigfridsson on 06/10/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
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
