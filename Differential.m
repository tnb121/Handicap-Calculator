//
//  Differential.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/4/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "Differential.h"

@implementation Differential

@synthesize differentialCalculation=_differentialCalculation;

//- (void)someMethodWithFirstValue:(SomeType)value1 secondValue:(AnotherType)value2;
//+ (id)stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;

-(double) CalculateDifferential:(double) rating withslope:(double) slope withscore:(double) score
{
	double slopeConstant= 113.00;

	return (score - rating) * slopeConstant / slope;


}

@end