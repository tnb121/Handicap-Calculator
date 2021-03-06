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

@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;

-(double)calculateCourseHandicap:(double)slope withPlayerHandicap:(double) playerHandicap;
-(int)roundCountCalculation;
-(double)scoringAverageCalculation;
-(double)handicapCalculation;
-(NSString*)handicapCalculationString;
@end
