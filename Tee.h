//
//  Tee.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/29/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Courses;

@interface Tee : NSManagedObject

@property (nonatomic, retain) NSString * teeColor;
@property (nonatomic, retain) Courses *courses;

@end
