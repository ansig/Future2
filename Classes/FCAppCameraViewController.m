/*
 
 TiY (tm) - an iPhone app that supports self-management of type 1 diabetes
 Copyright (C) 2010  Interaction Design Centre (University of Limerick, Ireland)
 
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
//  FCAppCameraViewController.m
//  Future2
//
//  Created by Anders Sigfridsson on 02/11/2010.
//

#import "FCAppCameraViewController.h"

#define SOURCETYPE UIImagePickerControllerSourceTypeCamera 
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation FCAppCameraViewController

@synthesize entry;

#pragma mark Init

-(id)initWithEntry:(FCEntry *)anEntry {

	if (self = [super init]) {
		
		// retain the entry
		entry = [anEntry retain];
		
		// setup up camera
		if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE]) 
			self.sourceType = SOURCETYPE;
		
		self.allowsEditing = NO;
		
		self.delegate = self;
	}
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark Dealloc

- (void)dealloc {
	
	[entry release];
	
    [super dealloc];
}

#pragma mark Memory warning

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
	NSLog(@"FCAppCameraViewController -didReceiveMemoryWarning!");
}

#pragma mark View

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Orientation

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
 
 NSLog(@"FCRootViewController -willAnimateRotationToInterfaceOrientation:duration:");
}

/*
 - (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 
 NSLog(@"FCRootViewController -willAnimateFirstHalfOfRotationToInterfaceOrientation:duration:");
 }
 
 - (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
 
 NSLog(@"FCRootViewController -willAnimateSecondHalfOfRotationFromInterfaceOrientation:duration:");
 }
 */

#pragma mark UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	// retrieving original image and resizing it
	UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	UIImage *image = [UIImage imageWithImage:originalImage scaledToScale:0.5f];
	
	// save image to unique path
	
	int i = 0; 
	NSString *imageName = @"TiY-0.png";
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:imageName]; 
	
	while ([[NSFileManager defaultManager] fileExistsAtPath:uniquePath]) {
		
		imageName = [NSString stringWithFormat:@"%@-%d.%@", @"TiY", ++i, @"png"];
		uniquePath = [NSString stringWithFormat:@"%@/%@", DOCSFOLDER, imageName];
	}
	
	[UIImagePNGRepresentation(image) writeToFile:uniquePath atomically:YES];
	
	// update the entry and send notification
	self.entry.string = imageName;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryObjectUpdated object:self];
	
	// dismiss the camera
	[[self parentViewController] dismissModalViewControllerAnimated:YES]; 
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	// make notification (so that FCAppNewEntryViewController updates its
	// UI content properly
	[[NSNotificationCenter defaultCenter] postNotificationName:FCNotificationEntryObjectUpdated object:self];
	
	// dismiss the camera
	[self dismissModalViewControllerAnimated:YES];
}

@end
