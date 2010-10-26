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
//  FCProfilePersonalInfoTableDataSource.m
//  Future2
//
//  Created by Anders Sigfridsson on 19/08/2010.
//

#import "FCProfilePersonalInfoTableDataSource.h"


@implementation FCProfilePersonalInfoTableDataSource

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
	NSArray *defaultSectionTitles = [[NSUserDefaults standardUserDefaults] arrayForKey:FCDefaultProfilePersonalSectionTitles];
	if (defaultSectionTitles == nil) {
	*/
	
		// create a new section titles mutable array
		NSMutableArray *newTitles = [[NSMutableArray alloc] init];
		self.sectionTitles = newTitles;
		[newTitles release];
		
		// personal section
		[self.sectionTitles addObject:kProfileSectionPersonal];
		
		// contact section
		[self.sectionTitles addObject:kProfileSectionContact];
		
	/*
		// also save this to the defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSRange range = NSMakeRange(0, [self.sectionTitles count]);
		NSArray *titlesArray = [NSArray arrayWithArray:[self.sectionTitles subarrayWithRange:range]];
		[defaults setObject:titlesArray forKey:FCDefaultProfilePersonalSectionTitles];
		[defaults synchronize];
		
	} else {
		
		// simply take the user default titles
		self.sectionTitles = [NSMutableArray arrayWithArray:defaultSectionTitles];
	}
	*/
	
	// * Rows in sections
	if (self.sections != nil)
		self.sections = nil;
	
	/*
	// get the default sections
	NSArray *defaultSections = [[NSUserDefaults standardUserDefaults] arrayForKey:FCDefaultProfilePersonalSections];
	if (defaultSections == nil) {
	*/
	
		NSArray *keys = [[NSArray alloc] initWithObjects:@"DefaultKey", @"Title", nil]; 
		NSArray *objects;
		
		// create a new sections mutable array
		NSMutableArray *newSections = [[NSMutableArray alloc] init];
		self.sections = newSections;
		[newSections release];
		
		// personal info
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileFirstName, kProfileItemFirstName, nil];
		NSDictionary *firstNamePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileSurname, kProfileItemSurname, nil];
		NSDictionary *surnamePair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileEmail, kProfileItemEmail, nil];
		NSDictionary *emailPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		NSArray *personalInfoArray = [[NSArray alloc] initWithObjects:firstNamePair, surnamePair, emailPair, nil];
		[self.sections addObject:personalInfoArray];
		
		[firstNamePair release];
		[surnamePair release];
		[emailPair release];
		[personalInfoArray release];
		
		// contact
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfilePersonalContact, kProfileItemPersonalContact, nil];
		NSDictionary *personalContactPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileGPContact, kProfileItemGPContact, nil];
		NSDictionary *gpContactPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		objects = [[NSArray alloc] initWithObjects:FCDefaultProfileEmergencyContact, kProfileItemEmergencyContact, nil];
		NSDictionary *emergencyContactPair = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
		[objects release];
		
		NSArray *contactInfoArray = [[NSArray alloc] initWithObjects:personalContactPair, gpContactPair, emergencyContactPair, nil];
		[self.sections addObject:contactInfoArray];
		
		[personalContactPair release];
		[gpContactPair release];
		[emergencyContactPair release];
		[contactInfoArray release];
		
		[keys release];
		
	/*
		// also save this to the defaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSRange range = NSMakeRange(0, [self.sections count]);
		NSArray *sectionsArray = [NSArray arrayWithArray:[self.sections subarrayWithRange:range]];
		[defaults setObject:sectionsArray forKey:FCDefaultProfilePersonalSections];
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
		rightLabel.font = [UIFont boldSystemFontOfSize:18.0f];
		[cell addSubview:rightLabel];
		[rightLabel release];
	}
	
	// variables
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSDictionary *item = [[sections objectAtIndex:section] objectAtIndex:row];
    
	// title
	UILabel *theLeftLabel = (UILabel *)[cell viewWithTag:1];
	theLeftLabel.text = [item objectForKey:@"Title"];
	
	// content
	UILabel *theRightLabel = (UILabel *)[cell viewWithTag:2];
	
	NSString *contentString;
	id object = [[NSUserDefaults standardUserDefaults] objectForKey:[item objectForKey:@"DefaultKey"]];
	if ([object isKindOfClass:[NSString class]]) {
		
		contentString = [[NSString alloc] initWithString:(NSString *)object];
		
	} else if ([object isKindOfClass:[NSDate class]]) {
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		contentString = [[NSString alloc] initWithString:[formatter stringFromDate:(NSDate *)object]];
		[formatter release];
		
	} else {
		
		theRightLabel.font = [UIFont systemFontOfSize:18.0f];
		theRightLabel.textColor = [UIColor lightGrayColor];
		contentString = [[NSString alloc] initWithString:@"not entered"];
	}
	
	theRightLabel.text = contentString;
	[contentString release];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
