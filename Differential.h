//
//  Differential.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/4/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Differential : NSObject

@property (nonatomic) double differentialCalculation;

-(double)CalculateDifferential:(double)rating withslope:(double)slope withscore:(double)score;

//-(int) sum: (int) a andb: (int) b andc:(int)c;


@end
