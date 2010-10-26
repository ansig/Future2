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
//  FCGraphEntryInfoView.m
//  Future2
//
//  Created by Anders Sigfridsson on 01/10/2010.
//

#import "FCGraphEntryInfoView.h"


@implementation FCGraphEntryInfoView

@synthesize entry;
@synthesize icon;
@synthesize categoryLabel, descriptionLabel, timestampLabel;

#pragma mark Init

-(id)initWithFrame:(CGRect)frame entry:(FCEntry*)theEntry {

	if (self = [self initWithFrame:frame]) {
		
		entry = [theEntry retain];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        // background
		self.backgroundColor = [UIColor grayColor];
		
		CGSize size = frame.size;
		
		// labels
		
		UILabel *newCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, 20.0f)];
		newCategoryLabel.backgroundColor = [UIColor darkGrayColor];
		newCategoryLabel.font = [UIFont systemFontOfSize:16.0f];
		newCategoryLabel.textColor = [UIColor whiteColor];
		
		self.categoryLabel = newCategoryLabel;
		[self addSubview:newCategoryLabel];
		
		[newCategoryLabel release];
		
		UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, 20.0f)];
		newTimestampLabel.backgroundColor = [UIColor clearColor];
		newTimestampLabel.font = [UIFont systemFontOfSize:16.0f];
		newTimestampLabel.textAlignment = UITextAlignmentRight;
		newTimestampLabel.textColor = [UIColor whiteColor];
		
		self.timestampLabel = newTimestampLabel;
		[self addSubview:newTimestampLabel];
		
		[newTimestampLabel release];
		
		UILabel *newDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 25.0f, size.width-30.0f, 20.0f)];
		newDescriptionLabel.backgroundColor = [UIColor clearColor];
		newDescriptionLabel.font = [UIFont boldSystemFontOfSize:18.0f];
		newDescriptionLabel.textColor = [UIColor whiteColor];
		
		self.descriptionLabel = newDescriptionLabel;
		[self addSubview:newDescriptionLabel];
		
		[newDescriptionLabel release];
		
		// icon
		
		UIImageView *newIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 25.0f, 20.0f, 20.0f)];
		
		self.icon = newIcon;
		[self addSubview:newIcon];
		
		[newIcon release];
    }
	
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[entry release];
	
	[icon release];
	
	[categoryLabel release];
	[descriptionLabel release];
	[timestampLabel release];
 
	[super dealloc];
}

#pragma mark Drawing

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark Animation

-(void)animateAppearence {
/*	Animates to transform identity and shows content.
	OBS! Assumes that -prepareToAnimateAppearanceFromPoint: has been called before. */
	
	[UIView		animateWithDuration:kAppearDuration 
					animations:^{ self.transform = CGAffineTransformIdentity; } 
						completion: ^(BOOL finished) { [self showContent]; } ];
}

-(void)animateDisappearence {
/*	Animates to the transform specified in -prepareToAnimateAppearanceFromPoint: and removes from superview on completion.
	OBS! Assumes that -prepareToAnimateAppearanceFromPoint: has been called before. */
	
	[UIView		animateWithDuration:kDisappearDuration 
					  animations:^{ self.transform = _originTransform; } 
					  completion: ^(BOOL finished) { [self removeFromSuperview]; } ];
}

#pragma mark Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// disappear
	[self animateDisappearence];
}

#pragma mark Custom

-(void)prepareToAnimateAppearanceFromPoint:(CGPoint)thePoint {
/*	Shrinks self to a dot and moves it to center on the given point. */

	// shrink
	CGAffineTransform scale = CGAffineTransformMakeScale(0.01f, 0.01f);
	
	// move
	CGFloat xOffset = thePoint.x - self.center.x;
	CGFloat yOffset = thePoint.y - self.center.y;
	CGAffineTransform translate = CGAffineTransformMakeTranslation(xOffset, yOffset);
	
	// store as origin transform
	_originTransform = CGAffineTransformConcat(scale, translate);
	
	// implement on self
	self.transform = _originTransform;
}

-(void)showContent {
/*	Fills in the labels with the entry's info. */
	
	if (self.entry != nil) {
	
		FCCategory *category = self.entry.category;
		
		// category
		self.categoryLabel.text = category.name;
		
		// timestamp
		self.timestampLabel.text = self.entry.timestampDescription;
		
		// description
		if ([[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog])
			self.descriptionLabel.text = self.entry.convertedFullDescription;
		else
			self.descriptionLabel.text = self.entry.fullDescription;
		
		// icon
		self.icon.image = [UIImage imageNamed:category.icon];
	}
}

@end
