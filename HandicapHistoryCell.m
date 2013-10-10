//
//  HandicapHistoryCell.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapHistoryCell.h"

@implementation HandicapHistoryCell

@synthesize historyCellDateLabel=_historyCellDateLabel;
@synthesize historyCellHandicapLabel=_historyCellHandicapLabel;
@synthesize historyCellRoundLabel=_historyCellRoundLabel;
@synthesize historyCellScoreAvgLabel=_historyCellScoreAvgLabel;

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
