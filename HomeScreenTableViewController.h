//
//  HomeScreenTableViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/5/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>

#import "RoundCell.h"

@interface HomeScreenTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

-(void) reloadHomeTable;

@end
