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
//  FCProfileHealthInfoDataSource.m
//  Future2
//
//  Created by Anders Sigfridsson on 19/08/2010.
//

#import "FCProfileHealthInfoDataSource.h"


@implementation FCProfileHealthInfoDataSource

@synthesize sections, sectionTitles;

#pragma mark Init

-(id)init {
	
	if (self = [super init]) {
		
		[self loadSectionsAndRows];
	}
	
	return self;
}

#pragma mark Dealloc

- (void)dealloc {
	
	[sections release];
	[sectionTitles release];
	
    [super dealloc];
}

#pragma mark Protocol

-(void)loadSectionsAndRows {
	
	/*
		OBS!
			There were plans of storing the sectionTitles and sections in the user defaults
			so that the tables could be rearranged by the user, but because of time restrictions
			this has not been implemented. The code commented out below retrieves and stores in the user
			defaults - what remains would be to actually implement the table editing in
			FCAppProfileViewController and some necessary changes in a few places (e.g. in
			FCAppProfileInputViewController, which uses == instead of isEqualTo to compare
			the default constant strings [see FCConstants]). /Anders
	*/
	
	// * Section titles
	if (self.sectionTitles != nil)
		self.sectionTitles = nil;
	
	// get the default profile section titles
	/*
	NSArray *defaultSectionTitles = [[NSUserDefaults standardUserDefaults] arrayForKey:FCDefaultProfileHealthSectionTitles];
	if (defaultSectionTitles == nil) {
	*/
	
		// create a new section titles mutable array
		NSMutableArray *newTitles = [[NSMutableArray alloc] init];
		self.sectionTitles = newTitles;
		[newTitles release];
		
		// diabetes section
		[self.sectionTitles addObject:kProfileSectionDiabetes];
		
		// insulin section
		[self.sectionTitles addObject:kProfileSectionInsulin];
		
		// health section
		[self.sectionTitles addObject:kProfileSectionHealth];
		
	/*
		// also save this to the defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSRange range = NSMakeRange(0, [self.sectionTitles count]);
		NSArray *titlesArray = [NSArray arrayWithArray:[self.sectionTitles subarrayWithRange:range]];
		[defaults setObject:titlesArray forKey:FCDefaultProfileHealthSectionTitles];
		[defaults synchronize];
		
	} else {
		
		// simply take the user default titles
		self.sectionTitles = [NSMutableArray arrayWithArray:defaultSectionTitles];
	}
	*/
	
	// * Rows in sections
	if (self.sections != nil)
		self.sections = nil;
	
	// get the default sections
	/*
	NSArray *defaultSections = [[NSUserDefaults standardUserDefaults] arrayForKey:FCDefaultProfileHealthSections];
	if (defaultSections == nil) {
	*/
	
		NSArray *keys = [[NSArray alloc] initWithObjects:@"DefaultKey", @"Title", nil]; 
		NSArray *objects;
		
		// create a new sections mutable array
		NSMutableArray *newSections = [[NSMutableArray alloc] init];
		self.sections = newSections;
		[newSections release];
		
		// diabetes info
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileDiabetesType, kProfileItemDiabetesType, nil];
		NSDictionary *diabetesTypePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileDiabetesDateDiagnosed, kProfileItemDiabetesDiagnosed, nil];
		NSDictionary *diabetesDiagnosedPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		NSArray *diabetesInfoArray = [[NSArray alloc] initWithObjects:diabetesTypePair, diabetesDiagnosedPair, nil];
		[self.sections addObject:diabetesInfoArray];
		
		[diabetesTypePair release];
		[diabetesDiagnosedPair release];
		[diabetesInfoArray release];
		
		// insulin
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileRapidInsulin, kProfileItemInsulinRapid, nil];
		NSDictionary *insulinRapidPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileBasalInsulin, kProfileItemInsulinBasal, nil];
		NSDictionary *insulinBasalPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileInjectionPen, kProfileItemInjectionPen, nil];
		NSDictionary *injectionPenPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileInjectionPump, kProfileItemInjectionPump, nil];
		NSDictionary *injectionPumpPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		NSArray *insulinInfoArray = [[NSArray alloc] initWithObjects:insulinRapidPair, insulinBasalPair, injectionPenPair, injectionPumpPair, nil];
		[self.sections addObject:insulinInfoArray];
		
		[insulinRapidPair release];
		[insulinBasalPair release];
		[injectionPenPair release];
		[injectionPumpPair release];
		[insulinInfoArray release];
		
		// health
	
		// check if user wants age or date
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileDateOfBirth, kProfileItemDateOfBirth, nil];
		NSDictionary *agePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileHeight, kProfileItemHeight, nil];
		NSDictionary *heightPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCKeyCIDWeight, kProfileItemWeight, nil];
		NSDictionary *weightPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		NSArray *healthInfoArray = [[NSArray alloc] initWithObjects:agePair, heightPair, weightPair, nil];
		[self.sections addObject:healthInfoArray];
		
		[agePair release];
		[heightPair release];
		[weightPair release];
		[healthInfoArray release];
		
		[keys release];
		
	/*
		// also save this to the defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSRange range = NSMakeRange(0, [self.sections count]);
		NSArray *sectionsArray = [NSArray arrayWithArray:[self.sections subarrayWithRange:range]];
		[defaults setObject:sectionsArray forKey:FCDefaultProfileHealthSections];
		[defaults synchronize];
		
	} else {
		
		//simply take default sections
		self.sections = [NSMutableArray arrayWithArray:defaultSections];
	}
	*/
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [[self.sections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // cell
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		// title label
		UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 12.0f, 100.0f, 20.0f)];
		leftLabel.tag = 1;
		leftLabel.font = [UIFont systemFontOfSize:14.0f];
		[cell addSubview:leftLabel];
		[leftLabel release];
		
		// content label
		UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(180.0f, 12.0f, 120.0f, 20.0f)];
		rightLabel.tag = 2;
		rightLabel.textAlignment = UITextAlignmentRight;
		[cell addSubview:rightLabel];
		[rightLabel release];
	}
	
	// variables
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSDictionary *item = [[sections objectAtIndex:section] objectAtIndex:row];
    
	// * title
	UILabel *theLeftLabel = (UILabel *)[cell viewWithTag:1];
	theLeftLabel.text = [item objectForKey:@"Title"];
	
	// * content
	UILabel *theRightLabel = (UILabel *)[cell viewWithTag:2];
	theRightLabel.font = [UIFont boldSystemFontOfSize:18.0f];
	theRightLabel.textColor = [UIColor blackColor];
	
	NSString *defaultKey = [item objectForKey:@"DefaultKey"];
	if (defaultKey == FCKeyCIDWeight) {
		
		// * weight 
		
		FCEntry *lastWeightEntry = [FCEntry lastEntryWithCID:FCKeyCIDWeight];
		
		if (lastWeightEntry != nil) {
		
			NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
			FCUnit *targetUnit = system == FCUnitSystemMetric ? [FCUnit unitWithUID:FCKeyUIDKilogram] : [FCUnit unitWithUID:FCKeyUIDPound];
		
			[lastWeightEntry convertToNewUnit:targetUnit];
		
			NSString *contentString = [[NSString alloc] initWithString:[lastWeightEntry fullDescription]];
			theRightLabel.text = contentString;
			[contentString release];
		
		} else {
			
			theRightLabel.font = [UIFont systemFontOfSize:18.0f];
			theRightLabel.textColor = [UIColor lightGrayColor];
			
			NSString *contentString = [[NSString alloc] initWithString:@"not entered"];
			theRightLabel.text = contentString;
			[contentString release];
		}
		
	} else {
	
		id object = [[NSUserDefaults standardUserDefaults] objectForKey:defaultKey];
		if ([object isKindOfClass:[NSString class]]) {
			
			// * strings
			
			NSString *contentString = [[NSString alloc] initWithString:(NSString *)object];
			theRightLabel.text = contentString;
			[contentString release];
			
		} else if ([object isKindOfClass:[NSDate class]]) {
			
			// * dates
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSInteger display = [defaults integerForKey:FCDefaultAgeDisplay];
			
			if (defaultKey == FCDefaultProfileDateOfBirth && display == FCDateDisplayYears) {
				
				// special case if the user wants to see age in years rather
				// than date (a user defaults setting)
				
				// change left label
				theLeftLabel.text = kProfileItemAge;
				
				// show age in years
				NSDate *birthDate = [(NSDate *)object copy];
				NSDate *now = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
				
				NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
				NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:birthDate toDate:now options:0];
				[gregorian release];
				[now release];
				[birthDate release];
				
				NSInteger years = [components year];
				
				NSString *contentString = [[NSString alloc] initWithFormat:@"%d years", years];
				theRightLabel.text = contentString;
				[contentString release];
				
			} else { 
				
				NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
				[formatter setDateStyle:NSDateFormatterMediumStyle];
				
				NSString *contentString = [[NSString alloc] initWithString:[formatter stringFromDate:(NSDate *)object]];
				theRightLabel.text = contentString;
				[contentString release];
				
				[formatter release];
			}
			
		} else if ([object isKindOfClass:[NSNumber class]]) {
			
			// * numbers
			
			NSNumber *number = [object copy];
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			
			NSInteger system = [[NSUserDefaults standardUserDefaults] integerForKey:FCDefaultHeightWeigthSystem];
			if (system == FCUnitSystemMetric) {
				
				// metric system
				
				if ([defaultKey isEqualToString:FCDefaultProfileHeight]) {
					
					// height
					NSString *contentString = [[NSString alloc] initWithFormat:@"%@ cm", [formatter stringFromNumber:number]];
					theRightLabel.text = contentString;
					[contentString release];
				}
				
			} else {
				
				// imperial or customary
				
				if ([defaultKey isEqualToString:FCDefaultProfileHeight]) {
					
					// height
					
					FCUnit *targetUnit = [FCUnit unitWithUID:FCKeyUIDInch];
					FCUnitConverter *converter = [[FCUnitConverter alloc] initWithTarget:targetUnit];
					
					FCUnit *originUnit = [FCUnit unitWithUID:FCKeyUIDCentimetre];
					
					NSNumber *convertedNumber = [converter convertNumber:number withUnit:originUnit roundedToScale:0];
					
					NSInteger inches = (NSInteger)[convertedNumber doubleValue];
					NSInteger remainingInches = inches % 12;
					NSInteger feet = (NSInteger)inches / 12;
					
					NSString *contentString = [[NSString alloc] initWithFormat:@"%d ft %d in", feet, remainingInches];
					theRightLabel.text = contentString;
					[contentString release];
					
					[converter release];
					
				}
			}
			
			[number release];
			[formatter release];
			
		} else {
			
			theRightLabel.font = [UIFont systemFontOfSize:18.0f];
			theRightLabel.textColor = [UIColor lightGrayColor];
			
			NSString *contentString = [[NSString alloc] initWithString:@"not entered"];
			theRightLabel.text = contentString;
			[contentString release];
		}
	}
		
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// We simply pass on the call to the parent view, who handles row selections
	}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
