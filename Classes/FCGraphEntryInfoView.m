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
@synthesize categoryLabel, timestampLabel;
@synthesize icon, descriptionLabel;
@synthesize imageView, scrollView;
@synthesize textView;
@synthesize closeButton;

#pragma mark Init

-(id)initWithFrame:(CGRect)frame entry:(FCEntry*)theEntry {

	if (self = [self initWithFrame:frame]) {
		
		// retain the entry
		
		entry = [theEntry retain];
		
		// get the category
		
		FCCategory *category = self.entry.category;
		
		// setup looks
		
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBackgroundPattern.png"]];
		
		self.layer.shadowOffset = CGSizeMake(0.0f, -3.0f);
		self.layer.shadowOpacity = 1.0f;
		
		// header
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 30.0f)];
		headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slantedBackgroundPattern.png"]];
		
		[self addSubview:headerView];
		
		[headerView release];
		
		UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 29.0f, self.frame.size.width, 1.0f)];
		separatorView.backgroundColor = kDarkColor;
		
		[self addSubview:separatorView];
		
		[separatorView release];
		
		// common labels
		
		CGFloat padding = 5.0f;
		
		UILabel *newCategoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, self.frame.size.width-(padding*2), 20.0f)];
		newCategoryLabel.backgroundColor = [UIColor clearColor];
		newCategoryLabel.font = kGraphLabelFont;
		newCategoryLabel.textColor = kDarkColor;
		
		newCategoryLabel.text = category.name;
		
		self.categoryLabel = newCategoryLabel;
		[self addSubview:newCategoryLabel];
		
		[newCategoryLabel release];
		
		UILabel *newTimestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, self.frame.size.width-(padding*2), 20.0f)];
		newTimestampLabel.backgroundColor = [UIColor clearColor];
		newTimestampLabel.font = kGraphLabelFont;
		newTimestampLabel.textAlignment = UITextAlignmentRight;
		newTimestampLabel.textColor = kDarkColor;
		
		newTimestampLabel.text = self.entry.timestampDescription;
		
		self.timestampLabel = newTimestampLabel;
		[self addSubview:newTimestampLabel];
		
		[newTimestampLabel release];
		
		if ([category.datatypeName isEqualToString:@"string"]) {
			
			// text view
			
			UITextView *newTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, self.frame.size.width, self.frame.size.height-31.0f)];
			newTextView.backgroundColor = [UIColor clearColor];
			newTextView.font = kGraphLargeFont;
			newTextView.textColor = kDarkColor;
			newTextView.editable = NO;
			
			newTextView.text = self.entry.string;
			
			self.textView = newTextView;
			[self addSubview:newTextView];
			[newTextView release];
			
			// close button
			
			[self createAndDisplayCloseButton];
			
		} else if ([category.datatypeName isEqualToString:@"photo"]) {
			
			// image
			
			UIImage *image = [UIImage imageWithContentsOfFile:self.entry.filePath];
			
			if (image != nil) {
				
				// scroll view
				
				UIScrollView *newScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, self.frame.size.width, self.frame.size.height-31.0f)];
				
				CGFloat minimumScale = image.size.height > image.size.width ? newScrollView.frame.size.height / image.size.height : newScrollView.frame.size.width / image.size.width;
				newScrollView.minimumZoomScale = minimumScale;
				newScrollView.maximumZoomScale = 2.0;
				
				newScrollView.contentSize = image.size;
				
				newScrollView.delegate = self;
				
				self.scrollView = newScrollView;
				[self addSubview:newScrollView];
				
				[newScrollView release];
				
				// image view
				
				UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
				newImageView.image = image;
				
				self.imageView = newImageView;
				
				[newImageView release];
				
				// add image view to scroll view
				
				[self.scrollView addSubview:self.imageView];
				self.scrollView.zoomScale = minimumScale; // zoom all the way out
				
				// close button
				
				[self createAndDisplayCloseButton];
			}
			
		} else {
			
			// description label
			
			UILabel *newDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f+(padding*2), 31.0f+padding+5.0f, self.frame.size.width-30.0f, 20.0f)];
			newDescriptionLabel.backgroundColor = [UIColor clearColor];
			newDescriptionLabel.font = kGraphLargeFont;
			newDescriptionLabel.textColor = kDarkColor;
			
			if ([[NSUserDefaults standardUserDefaults] boolForKey:FCDefaultConvertLog])
				newDescriptionLabel.text = self.entry.convertedFullDescription;
			else
				newDescriptionLabel.text = self.entry.fullDescription;
			
			self.descriptionLabel = newDescriptionLabel;
			[self addSubview:newDescriptionLabel];
			
			[newDescriptionLabel release];
			
			// icon
			
			UIImageView *newIcon = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 31.0f+padding, 30.0f, 30.0f)];
			newIcon.image = category.icon;
			
			self.icon = newIcon;
			[self addSubview:newIcon];
			
			[newIcon release];
		}
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		
        // background
		self.backgroundColor = [UIColor grayColor];
    }
	
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[entry release];
	
	[categoryLabel release];
	[timestampLabel release];
	
	[icon release];
	[descriptionLabel release];
	
	[imageView release];
	[scrollView release];
	
	[textView release];
	
	[closeButton release];
 
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
					animations:^{ self.transform = CGAffineTransformIdentity; } ];
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

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView {
	
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
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

-(void)createAndDisplayCloseButton {
/*	Creates a close-button and adds it as subview. */
	
	// close button
	
	UIButton *newCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	UIImage *image = [UIImage imageNamed:@"closeButton.png"];
	
	newCloseButton.frame = CGRectMake(self.frame.size.width - 35.0f, 36.0f, image.size.width, image.size.height);
	
	[newCloseButton setImage:image forState:UIControlStateNormal];
	[newCloseButton addTarget:self action:@selector(animateDisappearence) forControlEvents:UIControlEventTouchUpInside];
	
	self.closeButton = newCloseButton;
	[self addSubview:newCloseButton];
}

@end
