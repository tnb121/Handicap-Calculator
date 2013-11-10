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

@synthesize parseDataFetch=_parseDataFetch;

-(ParseDataFetch*)parseDataFetch
{
	if(!_parseDataFetch) _parseDataFetch=[[ParseDataFetch alloc]init];
	return _parseDataFetch;
}

-(NSMutableArray*) fetchRoundResultsRecent20
{

	NSMutableArray* mutableArrayByDiff = [self.parseDataFetch.roundsRecent20FromParse mutableCopy];
	return mutableArrayByDiff;
}

-(NSArray*) fetchRoundResults
{
	NSArray * array = self.parseDataFetch.roundsFromParse;
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
	NSSortDescriptor *sortByDiffs = [NSSortDescriptor sortDescriptorWithKey:@"roundDifferential" ascending:YES];
	[roundScoringArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDiffs]];

	double scoringAverage= [[roundScoringArray valueForKeyPath:@"@avg.roundScore"]doubleValue];
	return scoringAverage;
}
-(double)slopeAverage
{
	NSArray* slopeAverageArray = [self fetchRoundResults];

	int slopeAverage= [[slopeAverageArray valueForKeyPath:@"@avg.roundSlope"]integerValue];
	return slopeAverage;
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
