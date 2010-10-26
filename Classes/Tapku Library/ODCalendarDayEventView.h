//
//  ODCalendarDayEventView.h
//  Created by Anthony Mittaz on 20/10/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TapDetectingView.h"
#import <QuartzCore/QuartzCore.h> // Anders added this import

#define VERTICAL_DIFF 50.0

@interface ODCalendarDayEventView : TapDetectingView {
	NSNumber *_id;
	NSDate *_startDate;
	NSDate *_endDate;
	NSString *_title;
	NSString *_location;
}

@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location;

- (void)setupCustomInitialisation;

+ (id)eventViewWithFrame:(CGRect)frame id:(NSNumber *)id startDate:(NSDate *)startDate endDate:(NSDate *)endDate title:(NSString *)title location:(NSString *)location;

@end
