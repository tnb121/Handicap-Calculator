//
//  HandicapHistory.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapHistoryViewController.h"
#import "ParseData.h"

@interface HandicapHistoryViewController ()

@property (strong,nonatomic) Handicap * hCapClass;


@end

@implementation HandicapHistoryViewController

@synthesize hCapClass=_hCapClass;


-(Handicap*)hCapClass
{
	if(!_hCapClass)_hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[ParseData sharedParseData] updateParseHandicapHistory];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

}


@end
