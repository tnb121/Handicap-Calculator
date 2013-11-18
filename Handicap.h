//
//  Handicap.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/17/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@interface Handicap : NSObject


-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap;
-(double)handicapCalculation;
-(NSString*)handicapCalculationString;
-(double)mostRecentHandicap;



@end
