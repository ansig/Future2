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
//  FCDateFormatterHelper.m
//  Future2
//
//  Created by Anders Sigfridsson on 11/08/2010.
//

#import "FCDateFormatterHelper.h"


@implementation NSDateFormatter (FCDateFormatterHelper)

+(NSDateFormatter *)fc_dateFormatterGMT {
/* Returns an NSDateFormatter with en_US_POSIX locale and set to GMT */
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// locale
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	[formatter setLocale:locale];
	[locale release];
	
	// timezone
	[formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	[formatter autorelease];
	return formatter;
}

+(NSDateFormatter *)fc_dateFormatterLocal {
/* Returns an NSDateFormatter with en_US_POSIX locale */
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// locale
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	[formatter setLocale:locale];
	[locale release];
	
	[formatter autorelease];
	return formatter;
}

@end
