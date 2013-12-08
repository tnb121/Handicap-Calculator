//
//  DefinitionViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/7/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "DefinitionViewController.h"

@interface DefinitionViewController ()

@property (strong, nonatomic) IBOutlet UILabel *definitionItem;
@property (strong, nonatomic) IBOutlet UITextView *definitionDetail;

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

	[self.definitionDetail setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];

}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self underlineDefinitionItemLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)underlineDefinitionItemLabel
{
	NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
	//escTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Equitable Stroke Control"attributes:underlineAttribute];
	_definitionItem.attributedText = [[NSAttributedString alloc] initWithString:self.definitionItemText
																		attributes:underlineAttribute];

}

@end
