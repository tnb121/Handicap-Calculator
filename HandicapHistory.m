//
//  HandicapHistory.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapHistory.h"


@implementation HandicapHistory

@dynamic historyDate;
@dynamic historyHCap;
@dynamic historyScoringAverage;
@dynamic historyRoundCount;

@synthesize managedObjectContext=_managedObjectContext;

-(double) mostRecentHandicap
{
		if (_managedObjectContext == nil)
		{
			_managedObjectContext = [(HandicapAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		}

		NSManagedObjectContext *moc = [self managedObjectContext];
		NSEntityDescription *entityDescription = [NSEntityDescription
												  entityForName:@"HandicapHistory" inManagedObjectContext:moc];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSSortDescriptor *sortbyDate=[NSSortDescriptor sortDescriptorWithKey:@"historyRoundCount" ascending:YES];
		NSArray *sortDescriptors = @[sortbyDate];
		[request setEntity:entityDescription];
		[request setSortDescriptors:sortDescriptors];

		NSError *error;

		NSMutableArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
		if (array == nil)
		{
			// Deal with error...
		}


		double lastHandicap =[[[array lastObject]	valueForKey:@"historyHCap"] doubleValue];

	return lastHandicap;
		
}






@end
