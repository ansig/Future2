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
//  Future2AppDelegate.m
//  Future2
//
//  Created by Anders Sigfridsson on 04/02/2010.
//

#import "Future2AppDelegate.h"

@implementation Future2AppDelegate

@synthesize window;

@synthesize rootViewController;

@synthesize locationManager, bestLocation;

#pragma mark Launch

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// * Root view controller
	FCRootViewController *aViewController = [[FCRootViewController alloc] init];
	
	self.rootViewController = aViewController;
	[aViewController release];
	
	[window addSubview:self.rootViewController.view];
	
	// Override point for customization after application launch
    [window makeKeyAndVisible];
	
	// * Location manager
	[self setupLocationManager];
	
	// * Database
	[self setupDatabase];
	
	// * Load application...
	[self.rootViewController loadApplication];
}

#pragma mark Dealloc

- (void)dealloc {
	
	[bestLocation release];
	[locationManager release];
	
	[rootViewController release];
	
    [window release];
	
    [super dealloc];
}

#pragma mark Database

-(void)setupDatabase {
	
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:FCDatabaseName];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:FCDatabaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

#pragma mark Location

-(void)setupLocationManager {
	
	CLLocationManager *aLocationManager = [[CLLocationManager alloc] init];
	
	if (![CLLocationManager locationServicesEnabled]) {
		
		[aLocationManager release];
		NSLog(@"Future2AppDelegate -(void)createLocationManager || User has not enabled location services!");
		
	} else {
	
		aLocationManager.delegate = self;
		aLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		aLocationManager.distanceFilter = 5.0f; // (Meters)
		
		[aLocationManager startUpdatingLocation];
		
		self.locationManager = aLocationManager;
		
		[aLocationManager release];
	}
}

#pragma mark Location manager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Future2AppDelegate || Location manager error: '%@'", [error description]);
	
	[locationManager stopUpdatingLocation];
	[locationManager release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	// Test that this is not likely to be a cashed location
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) 
		return;
	
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) 
		return;
	
	// Test the measurement to see if it is more or equally accurate to the previous measurement
    if (bestLocation == nil || bestLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
		
		// Test the measurement to see if it meets the desired accuracy
		if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
		
			self.bestLocation = newLocation;
			NSLog(@"Future2AppDelegate || New best location: %@", [newLocation description]);
		}
    }
}


@end
