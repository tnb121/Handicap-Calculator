//
//  ParseDataFetch.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/31/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "ParseDataFetch.h"

@implementation ParseDataFetch

@synthesize roundsFromParse=_roundsFromParse;
@synthesize handicapHistoryfromParse=_handicapHistoryfromParse;
@synthesize roundsRecent20FromParse=_roundsRecent20FromParse;

-(NSArray*)roundsFromParse
{
	if(!_roundsFromParse) [self fetchParseRounds];
	return _roundsFromParse;
}

-(NSArray*)handicapHistoryfromParse
{
	if(!_handicapHistoryfromParse) [self fetchParseHandicapHistory];
	return _handicapHistoryfromParse;
}

-(NSArray*)roundsRecent20FromParse
{
	if(!_roundsRecent20FromParse) [self fetchParseRoundsRecent20];
	return _roundsRecent20FromParse;
}

-(void)fetchParseRounds
{
	PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
	[roundQuery setLimit:(200)];
	[roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[roundQuery findObjectsInBackgroundWithBlock:^(NSArray *roundObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			_roundsFromParse=roundObjects;
			NSLog(@"%@",_roundsFromParse);

		}
		else NSLog(@"failed");
	}

	 ];
}
-(void)fetchParseHandicapHistory
{
	PFQuery *historyQuery = [PFQuery queryWithClassName:@"HandicapHistory"];
	[historyQuery setLimit:(200)];
	[historyQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[historyQuery findObjectsInBackgroundWithBlock:^(NSArray *historyObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			 _handicapHistoryfromParse = historyObjects;
			NSLog(@"%@",_handicapHistoryfromParse);
		}
		else NSLog(@"failed");
	}

	 ];
}
-(void)fetchParseRoundsRecent20
{
	PFQuery *round20Query = [PFQuery queryWithClassName:@"Rounds"];
	[round20Query orderByDescending:@"roundDate"];
	[round20Query setLimit:(20)];
	[round20Query whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[round20Query findObjectsInBackgroundWithBlock:^(NSArray *round20Objects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			_roundsRecent20FromParse=round20Objects;
			NSLog(@"%@",_roundsRecent20FromParse);

		}
		else NSLog(@"failed");
	}

	 ];}

@end
