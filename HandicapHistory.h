//
//  HandicapHistory.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HandicapHistory : NSManagedObject

@property (nonatomic, retain) NSDate * historyDate;
@property (nonatomic, retain) NSNumber * historyHCap;

@end
