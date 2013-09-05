//  RoundCell.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/21/13.
//  Created by Todd Bohannon on 9/4/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "RoundCell.h"

@implementation RoundCell

@synthesize dateCell=_dateCell;
@synthesize courseNameCell=_courseNameCell;
@synthesize scoreCell=_scoreCell;
@synthesize differentialCell=_differentialCell;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		       // Initialization code
	}
	return self;
}

@end