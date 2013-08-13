//
//  HandicapCell.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/12/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapCell.h"

@implementation HandicapCell
@synthesize dateLabel = _dateLabel;
@synthesize courseNameLabel = _courseNameLabel;
@synthesize scoreLabel = _scoreLabel;
@synthesize differentialLabel = _differentialLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
