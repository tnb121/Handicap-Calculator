//
//  Handicap.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Handicap.h"
#import "HandicapAppDelegate.h"

@implementation Handicap

double roundCountForHandicap;
int x;

-(NSMutableArray*) fetchRoundResultsRecent20
{
	if (_managedObjectContext == nil)
	{
		_managedObjectContext = [(HandicapAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}

	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Rounds" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor *sortbyDate=[NSSortDescriptor sortDescriptorWithKey:@"roundDate" ascending:YES];
	NSArray *sortDescriptors = @[sortbyDate];
	[request setEntity:entityDescription];
	[request setSortDescriptors:sortDescriptors];

	NSError *error;

	NSMutableArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
	if (array == nil)
	{
		// Deal with error...
	}

NSLog(@"array: %@",array);

	NSSortDescriptor *sortByDiff=[NSSortDescriptor sortDescriptorWithKey:@"roundDifferential" ascending:NO];
	NSArray * sortDescriptorsByDiff = @[sortByDiff];
	NSArray* immutableArrayByDiff =[array sortedArrayUsingDescriptors:sortDescriptorsByDiff];
	NSMutableArray * mutableArrayByDiff = [NSMutableArray arrayWithArray:immutableArrayByDiff];

	NSLog(@"array: %@",mutableArrayByDiff);

	return mutableArrayByDiff;
}

-(NSArray*) fetchRoundResults
{
	if (_managedObjectContext == nil)
	{
		_managedObjectContext = [(HandicapAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}

	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Rounds" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor *sortbyDate=[NSSortDescriptor sortDescriptorWithKey:@"roundDate" ascending:YES];
	NSArray *sortDescriptors = @[sortbyDate];
	[request setEntity:entityDescription];
	[request setSortDescriptors:sortDescriptors];

	NSError *error;

	NSArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
	if (array == nil)
	{
		// Deal with error...
	}

	return array;
}

-(int)roundCountCalculation
{
	NSArray* roundCountArray = [self fetchRoundResults];
	NSNumber * roundCount = [roundCountArray valueForKeyPath:@"@count"];
	return [roundCount integerValue];
}

-(void) setHandicapParameters
{
	roundCountForHandicap=[self CalculateHCapRounds:(double) [self roundCountCalculation]];

}

-(double)scoringAverageCalculation
{
	NSArray* roundScoringArray = [self fetchRoundResults];
	NSLog(@"array: %@", roundScoringArray);
	NSSortDescriptor *sortByDiffs = [NSSortDescriptor sortDescriptorWithKey:@"roundDifferential" ascending:YES];
	[roundScoringArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDiffs]];
NSLog(@"array: %@", roundScoringArray);

	double scoringAverage= [[roundScoringArray valueForKeyPath:@"@avg.roundScore"]doubleValue];
	return scoringAverage;
}



-(double) calculateDifferentialSum
{
	double differentialSum = 0;
	int x = 1;
	[self setHandicapParameters];
	NSMutableArray* roundCalculationArray = [self fetchRoundResultsRecent20];

	for (x=1;x<=roundCountForHandicap;x++)
	{
		differentialSum=differentialSum + [[[roundCalculationArray lastObject]	valueForKey:@"roundDifferential"] doubleValue];
		[roundCalculationArray removeLastObject];
	}
	return differentialSum;
}

-(double)handicapCalculation
{
	double roundCountForHandicap=[self CalculateHCapRounds:(double) [self roundCountCalculation]];

	double handicapValueRounded = (floorf([self calculateDifferentialSum] / roundCountForHandicap * 0.96*10))/10;
	return handicapValueRounded;

}

-(NSString*)handicapCalculationString
{
	NSString* handicapString = [NSString stringWithFormat:@"%.1f",self.handicapCalculation];
	NSString* handicapStringNegative = [NSString stringWithFormat:@"%.1f",-(self.handicapCalculation)];
	if([self roundCountCalculation]<5)
		return @" - ";
	else if (self.handicapCalculation <0)
		return [@"+"stringByAppendingString:handicapStringNegative];
	else
		return handicapString;
}

-(double) CalculateHCapRounds:(double) rounds
{
	if (rounds <=6)
	{
		return 1;
	}
	else if (rounds <=16)
	{
		float roundcountx  = (rounds - 3)/2;
		int roundcount = roundcountx;
		return roundcount;
	}
	else if (rounds <=19)
	{
		float roundcountx = (rounds-10);
		int roundcount = roundcountx;
		return roundcount;
	}
	else if (rounds >= 20)
	{
		return 10;
	}

	return 0;
}

-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap
{
	return slope / 113 * playerHandicap;
}



@end
