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
//  FCGraphEntryInfoView.h
//  Future2
//
//  Created by Anders Sigfridsson on 01/10/2010.
//


#import "TKGlobal.h"
#import "FCEntry.h"

@interface FCGraphEntryInfoView : UIView <UIScrollViewDelegate> {
	
	FCEntry *entry;
	
	UILabel *categoryLabel;
	UILabel *timestampLabel;
	
	UIImageView *icon;
	UILabel *descriptionLabel;
	
	UIImageView *imageView;
	UIScrollView *scrollView;
	
	UITextView *textView;
	
	UIButton *closeButton;
	
	CGAffineTransform _originTransform;
}

@property (nonatomic, retain) FCEntry *entry;

@property (nonatomic, retain) UILabel *categoryLabel;
@property (nonatomic, retain) UILabel *timestampLabel;

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *descriptionLabel;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) UITextView *textView;

@property (nonatomic, retain) UIButton *closeButton;

// Init

-(id)initWithFrame:(CGRect)frame entry:(FCEntry*)theEntry;

// Animate

-(void)animateAppearence;
-(void)animateDisappearence;

// Custom

-(void)prepareToAnimateAppearanceFromPoint:(CGPoint)thePoint;
-(void)createAndDisplayCloseButton;

@end
