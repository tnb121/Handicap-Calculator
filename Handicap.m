//
//  Handicap.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Handicap.h"
#import "ParseData.h"

@interface Handicap()


@end

@implementation Handicap


-(double)handicapCalculation
{
	double roundCountParse = [[[ParseData sharedParseData]roundCount]doubleValue];
	double roundCountForHandicap=[self CalculateHCapRounds:(double) roundCountParse];

	double differentialSum = 0;
	int x = 1;
	
	NSMutableArray* roundCalculationArray = [[[ParseData sharedParseData]roundsRecent20FromParse]mutableCopy];

	for (x=1;x<=roundCountForHandicap;x++)
	{
		differentialSum=differentialSum + [[[roundCalculationArray lastObject]	valueForKey:@"roundDifferential"] doubleValue];
		[roundCalculationArray removeLastObject];
	}

	double handicapValueRounded = (floorf(differentialSum / roundCountForHandicap * 0.96*10))/10;
	return handicapValueRounded;

}


-(NSString*)handicapCalculationString
{
	NSString* handicapString = [NSString stringWithFormat:@"%.1f",self.handicapCalculation];
	NSString* handicapStringNegative = [NSString stringWithFormat:@"%.1f",-(self.handicapCalculation)];
	if([[[ParseData sharedParseData]roundCount]integerValue]<5)
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

-(double) mostRecentHandicap
{
	NSMutableArray *array= [[[ParseData sharedParseData]handicapHistoryFromParse]mutableCopy];

	if (array == nil)
	{
		return 0;
	}

	double lastHandicap =[[[array lastObject]	valueForKey:@"historyHandicap"] doubleValue];

	return lastHandicap;
}



@end
