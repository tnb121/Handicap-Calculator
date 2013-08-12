//
//  Rounds.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/3/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rounds : NSManagedObject

@property (nonatomic, retain) NSNumber * roundDifferential;
@property (nonatomic, retain) NSNumber * roundRating;
@property (nonatomic, retain) NSNumber * roundScore;
@property (nonatomic, retain) NSNumber * roundSlope;
@property (nonatomic, retain) NSString * roundCourseName;
@property (nonatomic,retain) NSDate * roundDate;

@end
