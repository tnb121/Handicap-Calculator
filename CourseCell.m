//
//  CourseCell.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/15/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseCell.h"

@implementation CourseCell

@synthesize courseHCapLabel=_courseHCapLabel;
@synthesize courseNameLabel=_courseNameLabel;
@synthesize courseRatingLabel=_courseRatingLabel;
@synthesize CourseSlopeLabel=_CourseSlopeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
