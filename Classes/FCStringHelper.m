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
//  FCStringHelper.m
//  Future2
//
//  Created by Anders Sigfridsson on 12/11/2010.
//

#import "FCStringHelper.h"


@implementation NSString (FCStringHelper)

-(NSString *)noLettersString {
/*	Returns a new string with no characters belonging to the letter character set. */
	
	NSString *newString = [NSString stringWithString:@""];
	
	for (NSString *s in [self componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet]])
		newString = [newString stringByAppendingString:s];
	
	return newString;
}

-(NSString *)noSymbolsString {
/*	Returns a new string with no characters belonging to the symbol character set. */
	
	NSString *newString = [NSString stringWithString:@""];
	
	for (NSString *s in [self componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]])
		newString = [newString stringByAppendingString:s];
	
	return newString;
}

-(NSString *)noControlCharacterString {
/*	Returns a new string with no characters belonging to the control character set. */
	
	NSString *newString = [NSString stringWithString:@""];
	
	for (NSString *s in [self componentsSeparatedByCharactersInSet:[NSCharacterSet controlCharacterSet]])
		newString = [newString stringByAppendingString:s];
	
	return newString;
}

-(NSString *)noPunctuationString {
/*	Returns a new string with no characters belonging to the punctuation chracter set. */
	
	NSString *newString = [NSString stringWithString:@""];
	
	for (NSString *s in [self componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]])
		newString = [newString stringByAppendingString:s];
	
	return newString;
}

-(NSString *)sqlite3String {
/*	Returns a string encoded to be inserted into an sqlite3 database. */
	
	// replaces single quotes (') with two singles (''), which
	// is the encoding used by sqlite3
	
	return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}

-(NSString *)numberString {
/*	Returns a new string containing only numbers */
	
	NSString *newString = [[self copy] autorelease];
	
	newString = [newString noLettersString];
	newString = [newString noSymbolsString];
	newString = [newString noPunctuationString];
	
	return newString;
}

-(UIFont *)fontForText:(NSString *)text toFitWidth:(CGFloat)width usingOriginalFont:(UIFont *)originalFont {
	
	NSString *fontName = originalFont.fontName;
	CGFloat pointSize = originalFont.pointSize;
	
	UIFont *newFont = [UIFont fontWithName:fontName size:pointSize];
	
	CGSize requiredSize = [text sizeWithFont:newFont];
	
	while (requiredSize.width > width) {
		
		if (pointSize < 7)
			break;
		
		pointSize--;
		
		newFont = [UIFont fontWithName:fontName size:pointSize];
		
		requiredSize = [text sizeWithFont:newFont];
	}
	
	return newFont;
}

@end
