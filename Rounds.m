//
//  Rounds.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/3/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Rounds.h"


@implementation Rounds

@dynamic roundDifferential;
@dynamic roundRating;
@dynamic roundScore;
@dynamic roundSlope;
@dynamic roundCourseName;
@dynamic roundDate;


-(NSNumber *) countOfRounds
{
	//total number of rounds
	return [Rounds valueForKeyPath: @"@count"];

}







@end
