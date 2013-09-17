//
//  Rounds.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/29/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Rounds.h"
#import "Courses.h"
#import "Tee.h"


@implementation Rounds

@dynamic roundDate;
@dynamic roundDifferential;
@dynamic roundScore;
@dynamic courses;

@synthesize managedObjectContext=_managedObjectContext;


+(NSNumber *)aggregateOperation:(NSString *)function onAttribute:(NSString *)attributeName withPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSExpression *ex = [NSExpression expressionForFunction:function
												 arguments:[NSArray arrayWithObject:[NSExpression expressionForKeyPath:attributeName]]];

    NSExpressionDescription *ed = [[NSExpressionDescription alloc] init];
    [ed setName:@"result"];
    [ed setExpression:ex];
    [ed setExpressionResultType:NSInteger64AttributeType];

    NSArray *properties = [NSArray arrayWithObject:ed];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPropertiesToFetch:properties];
    [request setResultType:NSDictionaryResultType];

    if (predicate != nil)
        [request setPredicate:predicate];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Rounds"
											  inManagedObjectContext:context];
    [request setEntity:entity];

    NSArray *results = [context executeFetchRequest:request error:nil];
    NSDictionary *resultsDictionary = [results objectAtIndex:0];
    NSNumber *resultValue = [resultsDictionary objectForKey:@"result"];
    return resultValue;
	
}



@end
