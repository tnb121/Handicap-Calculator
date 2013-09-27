//
//  Courses.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/29/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tee.h"

@class Rounds;
@class Tee;

@interface Courses : NSManagedObject

@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSNumber * courseSlope;
@property (nonatomic, retain) NSNumber * courseRating;
@property (nonatomic, retain) Rounds *rounds;
@property (nonatomic, retain) Tee * tees;


@end
