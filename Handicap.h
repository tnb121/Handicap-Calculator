//
//  Handicap.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Handicap : NSObject

@property (nonatomic,strong) NSArray * roundInfo;
@property (strong,nonatomic) Handicap * hCapClass;
@property double roundCountForHandicap;


@property int x;

@property double differentialSum;
@property (strong,nonatomic)NSNumber * diffSumInstance;
@property double dSumInstanceDouble;

@property double scoringAverageCalc;
@property double handicapValue;
@property double handicapValueRounded;

@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;

-(double) CalculateHCapRounds:(double) rounds;
-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap;
-(NSString*)roundCountCalculation;
-(NSString*)scoringAverageCalculation;
-(NSString*)handicapCalculation;
@end
