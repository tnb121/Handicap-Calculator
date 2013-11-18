//
//  ParseData.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "ParseData.h"

@implementation ParseData

@synthesize slopeAverage;
@synthesize scoringAverage;
@synthesize roundCount;
@synthesize roundsFromParse;
@synthesize roundsRecent20FromParse;
@synthesize handicapHistoryFromParse;
@synthesize coursesFromParse;

+ (id)sharedParseData
{
    static ParseData *sharedParseDataManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParseDataManager = [[self alloc] init];
    });
    return sharedParseDataManager;
}

- (id)init
{
	if (self = [super init])
	{
		slopeAverage = [[NSNumber alloc]init];
		scoringAverage=[[NSNumber alloc]init];
		roundCount = [[NSNumber alloc]init];
		roundsFromParse = [[NSArray alloc]init];
		roundsRecent20FromParse= [[NSArray alloc]init];
		handicapHistoryFromParse= [[NSArray alloc]init];
		coursesFromParse= [[NSArray alloc]init];
	}
	return self;
}

-(void)updateParseRounds
{
	PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
	[roundQuery setLimit:(200)];
	[roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[roundQuery findObjectsInBackgroundWithBlock:^(NSArray *roundObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			roundsFromParse=roundObjects;
			roundCount = [NSNumber numberWithInteger:roundObjects.count];
			scoringAverage = [NSNumber numberWithDouble:[[roundObjects valueForKeyPath:@"@avg.roundScore"]doubleValue]];
			slopeAverage= [NSNumber numberWithInteger:[[roundObjects valueForKeyPath:@"@avg.roundSlope"]integerValue]];

			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		}
		else NSLog(@"failed");
	}

	 ];
}
-(void)updateParseHandicapHistory
{
	PFQuery *historyQuery = [PFQuery queryWithClassName:@"HandicapHistory"];
	[historyQuery setLimit:(200)];
	[historyQuery whereKey:@"historyUser" equalTo:[PFUser currentUser].username];
	[historyQuery findObjectsInBackgroundWithBlock:^(NSArray *historyObjects,NSError *error)
	 {
		 if(!error)
		 {
			 NSLog(@"Success");
			 handicapHistoryFromParse = historyObjects;
			 [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];
		 }
		 else NSLog(@"failed");
	 }];
}




-(void)updateParseRoundsRecent20
{
	PFQuery *round20Query = [PFQuery queryWithClassName:@"Rounds"];
	[round20Query orderByDescending:@"roundDate"];
	[round20Query setLimit:(20)];
	[round20Query whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[round20Query findObjectsInBackgroundWithBlock:^(NSArray *round20Objects,NSError *error)
	 {
		 if(!error)
		 {
			 NSLog(@"Success");
			 roundsRecent20FromParse=round20Objects;
			 [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		 }
		 else NSLog(@"failed");
	 }];
}

-(void)updateParseCourses
{
	PFQuery *courseQuery = [PFQuery queryWithClassName:@"Rounds"];
	[courseQuery selectKeys:@[@"roundUser",@"roundCourse",@"roundTee", @"roundRating",@"roundSlope",]];
	[courseQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];
	[courseQuery findObjectsInBackgroundWithBlock:^(NSArray *courseObjects,NSError *error){
		if(!error)
		{
			NSLog(@"Success");
			NSMutableArray* coursesFromParseNonUnique=[courseObjects mutableCopy];
			NSMutableArray *coursesFromParseUnique=[[NSMutableArray alloc]init];

			int x;
			for (x=1;x<=courseObjects.count;x++)
			{
				NSObject *currentObject = [coursesFromParseNonUnique lastObject];
				//NSLog(@"Object %d : %@",x,currentObject);
				if (![coursesFromParseUnique containsObject:currentObject])
				{
					[coursesFromParseUnique addObject:currentObject];
					//NSLog(@"%@",coursesFromParseUnique);
				}
				[coursesFromParseNonUnique removeLastObject];
			}

			coursesFromParse=coursesFromParseUnique;
			//

			[[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];

		}
		else NSLog(@"failed");
	}];
}







@end
