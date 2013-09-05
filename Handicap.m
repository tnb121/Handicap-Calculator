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
	[request setEntity:entityDescription];

	NSError *error;

	NSMutableArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
	if (array == nil)
	{
		// Deal with error...
	}

	NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"roundDate" ascending:YES];
	[array sortUsingDescriptors:[NSArray arrayWithObject:sort]];

	NSLog(@"array: %@", array);

	return array;
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

-(NSString*)handicapCalculation
{

	_roundCountForHandicap=[self CalculateHCapRounds:(double) [[self roundCountCalculation] doubleValue]];

	_handicapValue = [self calculateDifferentialSum] / _roundCountForHandicap * 0.96*10;
	_handicapValueRounded = (floorf(_handicapValue))/10;
	NSString* handicapString = [NSString stringWithFormat:@"%.1f", _handicapValueRounded];
	if([handicapString isEqual:@"0.0"]) handicapString = @"N/A";
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
