//
//  ESCViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/5/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "ESCViewController.h"

@interface ESCViewController ()

@property (strong, nonatomic) IBOutlet UILabel *escTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *escCourseHCapLabel;
@property (strong, nonatomic) IBOutlet UILabel *escMaxScoreLabel;

@end

@implementation ESCViewController

@synthesize escCourseHCapLabel;
@synthesize escMaxScoreLabel;
@synthesize escTitleLabel;

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
	[self underlineLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)underlineLabels
{
	NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	//escTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Equitable Stroke Control"attributes:underlineAttribute];
	escCourseHCapLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Course Handicap"
																   attributes:underlineAttribute];
	escMaxScoreLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Max Score on Hole"
																   attributes:underlineAttribute];
}

@end
