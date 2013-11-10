//
//  ParseDataFetch.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/31/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "HandicapAppDelegate.h"

@interface ParseDataFetch : NSObject

@property (strong,nonatomic)	NSArray * roundsFromParse;
@property (strong,nonatomic)	NSArray * roundsRecent20FromParse;
@property (strong,nonatomic)	NSArray * handicapHistoryfromParse;


-(void)fetchParseRounds;
-(void)fetchParseHandicapHistory;
-(void)fetchParseRoundsRecent20;

-(NSArray*)roundsFromParse;
-(NSArray*)roundsRecent20FromParse;
-(NSArray*)handicapHistoryfromParse;

@end
