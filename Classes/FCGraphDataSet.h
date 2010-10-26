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
//  FCGraphDataSet.h
//  Future2
//
//  Created by Anders Sigfridsson on 20/10/2010.
//

#import <Foundation/Foundation.h>


#import "FCGraphReferenceRange.h"
#import "FCGraphEntryView.h"

@interface FCGraphDataSet : NSMutableArray {

	NSMutableArray *data;
	
	NSMutableArray *xReferenceRanges;
	NSMutableArray *yReferenceRanges;
	
	NSMutableArray *xSerie;
	NSMutableArray *ySerie;
	
	FCBoxPlot xBoxPlot;
	FCBoxPlot yBoxPlot;
}

@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, retain) NSMutableArray *xReferenceRanges;
@property (nonatomic, retain) NSMutableArray *yReferenceRanges;

@property (nonatomic, retain) NSMutableArray *xSerie;
@property (nonatomic, retain) NSMutableArray *ySerie;

@property (nonatomic) FCBoxPlot xBoxPlot;
@property (nonatomic) FCBoxPlot yBoxPlot;

// Get

-(FCBoxPlot)xBoxPlot;
-(FCBoxPlot)yBoxPlot;

// Custom

-(double)averageY;

-(void)calculateBoxPlots;
-(FCBoxPlot)boxPlotForRankedSerie:(NSArray *)theSerie;
-(double)medianForRankedSerie:(NSArray *)theSerie;
-(NSRange)medianIndexRangeInRankedSerie:(NSArray *)theSerie;

-(void)addXReferenceRange:(FCGraphReferenceRange *)newReferenceRange;
-(void)addYReferenceRange:(FCGraphReferenceRange *)newReferenceRange;

@end
