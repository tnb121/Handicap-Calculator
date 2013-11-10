//
//  HandicapHistory.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HandicapAppDelegate.h"


@interface HandicapHistory : NSManagedObject

@property (nonatomic, retain) NSDate * historyDate;
@property (nonatomic, retain) NSNumber * historyHCap;
@property (nonatomic, retain) NSNumber * historyScoringAverage;
@property (nonatomic, retain) NSNumber * historyRoundCount;

@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;

-(double)mostRecentHandicap;
@end
