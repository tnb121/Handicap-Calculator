//
//  DefinitionViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/7/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "DefinitionViewController.h"

@interface DefinitionViewController ()

@end

@implementation DefinitionViewController

@synthesize definitionItem=_definitionItem;
@synthesize definitionDetail=_definitionDetail;



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
	// Do any additional setup after loading the view.
	self.definitionItem.text = self.definitionItemText;
	self.definitionDetail.text=self.definitionDetalText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
