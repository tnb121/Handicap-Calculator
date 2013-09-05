//
//  GroupCourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "GroupCourseHandicapViewController.h"

@interface GroupCourseHandicapViewController ()

@end

@implementation GroupCourseHandicapViewController
@synthesize hCapClass=_hCapClass;
@synthesize groupCourseSlope=_groupCourseSlope;

@synthesize player2HandicapValue=_player2HandicapValue;
@synthesize player3HandicapValue=_player3HandicapValue;
@synthesize player4HandicapValue=_player4HandicapValue;

@synthesize myCourseHandicap=_myCourseHandicap;
@synthesize player2CourseHandicap=_player2CourseHandicap;
@synthesize player3CourseHandicap=_player3CourseHandicap;
@synthesize player4CourseHandicap=_player4CourseHandicap;

-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}

- (IBAction)calculateGroupCourseHandicap:(id)sender
{

	double myHandicap = [[self.hCapClass handicapCalculation]doubleValue];
	double player2Handicap = [_player2HandicapValue.text doubleValue];
	double player3Handicap = [_player3HandicapValue.text doubleValue];
	double player4Handicap = [_player4HandicapValue.text doubleValue];
	double courseSlope =[_groupCourseSlope.text doubleValue];

	_myCourseHandicap.text= [NSString stringWithFormat:@"%.1f",myHandicap * courseSlope / 113];

	if(!_player2HandicapValue.text)
		_player2CourseHandicap.text=@"-";
	else
		_player2CourseHandicap.text =[NSString stringWithFormat:@"%.1f",player2Handicap * courseSlope / 113];

	if(!_player3HandicapValue.text)
		_player3CourseHandicap.text=@"-";
	else
		_player3CourseHandicap.text =[NSString stringWithFormat:@"%.1f",player3Handicap * courseSlope / 113];

	if(!_player4HandicapValue.text)
		_player4CourseHandicap.text=@"-";
	else
		_player4CourseHandicap.text =[NSString stringWithFormat:@"%.1f",player4Handicap * courseSlope / 113];

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
