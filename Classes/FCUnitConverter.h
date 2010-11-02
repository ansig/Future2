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
//  FCUnitConverter.h
//  Future2
//
//  Created by Anders Sigfridsson on 14/09/2010.
//


#import "FCUnit.h"

@interface FCUnitConverter : NSObject {

	FCUnit *target;
}

@property (nonatomic, retain) FCUnit *target;

// Init

-(id)initWithTarget:(FCUnit *)theTarget;

// Custom

-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit;
-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit roundedToScale:(NSInteger)scale;
-(NSNumber *)convertNumber:(NSNumber *)aNumber withUnit:(FCUnit *)aUnit roundedToScale:(NSInteger)scale withMode:(NSRoundingMode)mode;

@end
