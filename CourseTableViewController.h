//
//  CourseTableViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/9/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>
#import "Handicap.h"

@interface CourseTableViewController : PFQueryTableViewController
@property (strong, nonatomic) IBOutlet UITableView *courseTableView;

@property (strong,nonatomic) Handicap * hCapClass;


@end
