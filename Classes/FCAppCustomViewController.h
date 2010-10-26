//
//  FCAppCustomViewController.h
//  Future2
//
//  Created by Anders Sigfridsson on 13/09/2010.
//  Copyright 2010 University of Limerick. All rights reserved.
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
