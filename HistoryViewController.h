//
//  HistoryViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/9/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>
#import "Handicap.h"
#import "HandicapHistoryCell.h"

@interface HistoryViewController : PFQueryTableViewController
@property (strong, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong,nonatomic) Handicap * hCapClass;@end
