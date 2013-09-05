//
//  Rounds.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/29/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Courses;

@interface Rounds : NSManagedObject

@property (nonatomic, retain) NSDate * roundDate;
@property (nonatomic, retain) NSNumber * roundDifferential;
@property (nonatomic, retain) NSNumber * roundScore;
@property (nonatomic, retain) Courses *courses;


@property (nonatomic,retain) NSManagedObjectContext * managedObjectContext;

+(NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context;

@end
