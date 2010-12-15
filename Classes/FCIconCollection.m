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
//  FCIconCollection.m
//  Future2
//
//  Created by Anders Sigfridsson on 14/12/2010.
//

#import "FCIconCollection.h"


static FCIconCollection *sharedIconCollection = nil;

@implementation FCIconCollection

@synthesize _systemIcons;

#pragma mark Class

+(id)sharedIconCollection {
	
	@synchronized (self) {
		
		if (sharedIconCollection == nil)
			sharedIconCollection = [[super allocWithZone:NULL] init];
	}
	
	return sharedIconCollection;
}

+(id)allocWithZone:(NSZone *)zone {
	
    return [[self sharedIconCollection] retain];
}

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSString *iconPlistPath = [mainBundle pathForResource:@"FCIcons" ofType:@"plist"];
		_systemIcons = [[NSDictionary alloc] initWithContentsOfFile:iconPlistPath];
	}
	
	return self;
}

#pragma mark Override

-(id)copyWithZone:(NSZone *)zone {
	
    return self;	
}

-(id)retain {
	
    return self;	
}

-(NSUInteger)retainCount {
	
    return NSUIntegerMax;  //denotes an object that cannot be released
}

-(void)release {
	
	//do nothing
}

-(id)autorelease {
	
    return self;
}

#pragma mark Custom

-(UIImage *)iconForIID:(NSString *)theIID {
	
	NSString *imageName = [_systemIcons objectForKey:theIID];
	
	if (imageName == nil)
		imageName = [self databaseIconNameForIID:theIID];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:[imageName stringByDeletingPathExtension] 
														  ofType:[imageName pathExtension]];
	
	if (imagePath == nil)
		return nil;
	
	return [UIImage imageWithContentsOfFile:imagePath];
}

-(NSString *)databaseIconNameForIID:(NSString *)theIID {
	
	// TODO
	
	return nil;
}

-(NSArray *)allIcons {

	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	
	// system icons
	
	for (NSString *key in [_systemIcons allKeys]) {
	
		NSDictionary *pair = [[NSDictionary alloc] initWithObjectsAndKeys:[_systemIcons objectForKey:key], @"Name", key, @"iid", nil];
		[mutableArray addObject:pair];
		[pair release];
	}
	
	// user icons
	
	// TODO
	
	NSRange range = NSMakeRange(0, [mutableArray count]);
	
	NSArray *sortedArray = [[mutableArray subarrayWithRange:range] sortedArrayUsingComparator:^ (id obj1, id obj2) {
		
		NSString *name1 = [obj1 objectForKey:@"Name"];
		NSString *name2 = [obj2 objectForKey:@"Name"];
		
		NSComparisonResult result = [name1 localizedCaseInsensitiveCompare:name2];
		
		return result;
	} ];
	
	[mutableArray release];
	
	return sortedArray;
}

@end
