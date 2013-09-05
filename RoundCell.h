//
//  RoundCell.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/21/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *dateCell;
@property (nonatomic,strong)IBOutlet UILabel *courseNameCell;
@property (nonatomic,strong)IBOutlet UILabel *scoreCell;
@property (nonatomic,strong)IBOutlet UILabel *differentialCell;

@end