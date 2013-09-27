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


@synthesize roundCountForHandicap=_roundCountForHandicap;


@synthesize x;
@synthesize differentialSum = _differentialSum;
@synthesize diffSumInstance=_diffSumInstance;
@synthesize handicapValue = _handicapValue;
@synthesize handicapValueRounded = _handicapValueRounded;

-(NSMutableArray*) fetchRoundResults
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
	[request setFetchLimit:20];
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

-(NSString*)roundCountCalculation
{
	NSArray* roundCountArray = [self fetchRoundResults];
	NSNumber *roundCount = [roundCountArray valueForKeyPath:@"@count"];
	NSString * countString = [roundCount stringValue];
	return countString;
}

-(void) setHandicapParameters
{
	_roundCountForHandicap=[self CalculateHCapRounds:(double) [[self roundCountCalculation] doubleValue]];

}

-(NSString*)scoringAverageCalculation
{
	NSArray* roundScoringArray = [self fetchRoundResults];
	NSLog(@"array: %@", roundScoringArray);
	NSSortDescriptor *sortByDiffs = [NSSortDescriptor sortDescriptorWithKey:@"roundDifferential" ascending:YES];
	[roundScoringArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDiffs]];
NSLog(@"array: %@", roundScoringArray);

	NSNumber*scoringAverage= [roundScoringArray valueForKeyPath:@"@avg.roundScore"];
	_scoringAverageCalc = [scoringAverage doubleValue];
	if(!_scoringAverageCalc) return @"N/A";
	NSString *scoringAverageString = [NSString stringWithFormat:@"%.1f",_scoringAverageCalc];
	return scoringAverageString;
}



-(double) calculateDifferentialSum
{
	NSMutableArray* roundCalculationArray = [self fetchRoundResults];

	_differentialSum = 0;

	for (x=1;x<=_roundCountForHandicap;x++)
	{
		NSNumber * differentialMostRecent= [roundCalculationArray lastObject];
		_diffSumInstance= [differentialMostRecent	valueForKey:@"roundDifferential"];
		_dSumInstanceDouble = [_diffSumInstance doubleValue];
		_differentialSum=_differentialSum + _dSumInstanceDouble;
		[roundCalculationArray removeLastObject];
	}
	return _differentialSum;
}

-(double)handicapCalculation
{
	_roundCountForHandicap=[self CalculateHCapRounds:(double) [[self roundCountCalculation] doubleValue]];

	double handicapValue = [self calculateDifferentialSum] / _roundCountForHandicap * 0.96*10;
	double handicapValueRounded = (floorf(handicapValue))/10;
	return handicapValueRounded;

}

-(NSString*)handicapCalculationString
{
	NSString* handicapString = [NSString stringWithFormat:@"%.1f",self.handicapCalculation];
	NSString* handicapStringNegative = [NSString stringWithFormat:@"%.1f",-(self.handicapCalculation)];
	if([[self roundCountCalculation]integerValue]<5)
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
