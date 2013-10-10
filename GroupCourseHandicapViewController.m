//
//  GroupCourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "GroupCourseHandicapViewController.h"

@interface GroupCourseHandicapViewController ()
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@end

@implementation GroupCourseHandicapViewController
@synthesize hCapClass=_hCapClass;
@synthesize groupCourseSlope=_groupCourseSlope;
@synthesize scrollview;


@synthesize player2HandicapValue=_player2HandicapValue;
@synthesize player3HandicapValue=_player3HandicapValue;
@synthesize player4HandicapValue=_player4HandicapValue;

@synthesize myHandicapLabel=_myHandicapLabel;
@synthesize myCourseHandicap=_myCourseHandicap;
@synthesize player2CourseHandicap=_player2CourseHandicap;
@synthesize player3CourseHandicap=_player3CourseHandicap;
@synthesize player4CourseHandicap=_player4CourseHandicap;

bool scrollBOOL;


-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}

- (IBAction)calculateGroupCourseHandicap:(id)sender
{
	int myRoundedCourseHandicap = lround([self.hCapClass handicapCalculation]);
	int player2Handicap = lround([_player2HandicapValue.text doubleValue]);
	int player3Handicap = lround([_player3HandicapValue.text doubleValue]);
	int player4Handicap = lround([_player4HandicapValue.text doubleValue]);
	int courseSlope =[_groupCourseSlope.text doubleValue];

	_myCourseHandicap.text= [NSString stringWithFormat:@"%.1d",myRoundedCourseHandicap];
	if(!_player2HandicapValue.text)
		_player2CourseHandicap.text=@"-";
	else
		_player2CourseHandicap.text =[NSString stringWithFormat:@"%.1d",player2Handicap * courseSlope / 113];

	if(!_player3HandicapValue.text)
		_player3CourseHandicap.text=@"-";
	else
		_player3CourseHandicap.text =[NSString stringWithFormat:@"%.1d",player3Handicap * courseSlope / 113];

	if(!_player4HandicapValue.text)
		_player4CourseHandicap.text=@"-";
	else
		_player4CourseHandicap.text =[NSString stringWithFormat:@"%.1d",player4Handicap * courseSlope / 113];

	[self strokesGivenCalculation];

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
	
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate = self;
	self.groupCourseSlope.delegate=self;
	self.player2HandicapValue.delegate=self;
	self.player3HandicapValue.delegate=self;
	self.player4HandicapValue.delegate=self;
}
	-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	scrollBOOL=NO;
	_myHandicapLabel.text = [self.hCapClass handicapCalculationString];
	_player2HandicapValue.enabled=NO;
	_player3HandicapValue.enabled=NO;
	_player4HandicapValue.enabled=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) dismissKeyboard:(id)sender
{
	[_player2HandicapValue resignFirstResponder];
	[_player3HandicapValue resignFirstResponder];
	[_player4HandicapValue resignFirstResponder];
	[_groupCourseSlope resignFirstResponder];
}
- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}

- (void)nextDidTouchDown
{
	if (_groupCourseSlope.isFirstResponder)
		[self.player2HandicapValue becomeFirstResponder];
	else if (_player2HandicapValue.isFirstResponder)
		[self.player3HandicapValue becomeFirstResponder];
	else if (_player3HandicapValue.isFirstResponder)
		[self.player4HandicapValue becomeFirstResponder];
	else if (_player4HandicapValue.isFirstResponder)
		[self.groupCourseSlope becomeFirstResponder];
}

- (void)previousDidTouchDown
{
	if (_groupCourseSlope.isFirstResponder)
		[self.groupCourseSlope becomeFirstResponder];
	else if (_player2HandicapValue.isFirstResponder)
		[self.groupCourseSlope becomeFirstResponder];
	else if (_player3HandicapValue.isFirstResponder)
		[self.player2HandicapValue becomeFirstResponder];
	else if (_player4HandicapValue.isFirstResponder)
		[self.player3HandicapValue becomeFirstResponder];
}

- (void)doneDidTouchDown
{
	[self dismissKeyboard:self];
	[self calculateGroupCourseHandicap:self];
	[self goToOrigin];
	[self strokesGivenCalculation];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (_groupCourseSlope.isFirstResponder)
		{
			[self goToOrigin];
		}
	else if (_player2HandicapValue.isFirstResponder && scrollBOOL==NO)
		{
			[self scrollDown100];
		}
	else if (_player3HandicapValue.isFirstResponder && scrollBOOL==NO)
		{
			[self scrollDown100];
		}
	else if (_player4HandicapValue.isFirstResponder && scrollBOOL==NO)
		{
			[self scrollDown100];
		}
	else
		return;
}

-(void)goToOrigin
{
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y = 0;
	[self.view setFrame:viewFrame];
	scrollBOOL=NO;
}

-(void)scrollDown100
{
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y = -100;
	[self.view setFrame:viewFrame];
	scrollBOOL=YES;
}


-(BOOL) GroupCourseSlopeCheck
{
	double slope = [_groupCourseSlope.text doubleValue];

	if(slope>=55 && slope<=155)
		return YES;
	else
		return NO;
}

-(IBAction)CheckGroupSlope:(id)sender
{
if([self GroupCourseSlopeCheck]==YES)
	{
		_player2HandicapValue.enabled=YES;
		_player3HandicapValue.enabled=YES;
		_player4HandicapValue.enabled=YES;

	}
else
	{
		_player2HandicapValue.enabled=NO;
		_player3HandicapValue.enabled=NO;
		_player4HandicapValue.enabled=NO;
	}
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
		[self.groupCourseSlope becomeFirstResponder];
}

-(void)strokesGivenCalculation
{
	if([self GroupCourseSlopeCheck] ==NO)
		return;

	NSNumber * player2Handicap = nil;
	NSNumber * player3Handicap = nil;
	NSNumber * player4Handicap = nil;

	NSNumber * myRoundedCourseHandicap = [NSNumber numberWithInt:lround([self.hCapClass handicapCalculation])];

	if(![_player2HandicapValue.text isEqualToString:@""])
		 {
			 player2Handicap = [NSNumber numberWithInt:lround([_player2HandicapValue.text doubleValue])];
		 }
	if(![_player3HandicapValue.text  isEqualToString:@""])
		 {
			 player3Handicap = [NSNumber numberWithInt:lround([_player3HandicapValue.text doubleValue])];
		 }
	if(![_player4HandicapValue.text  isEqualToString:@""])
		 {
			 player4Handicap = [NSNumber numberWithInt:lround([_player4HandicapValue.text doubleValue])];
		 }

	NSMutableArray * strokesGivenArray = [NSMutableArray new];
	[strokesGivenArray addObject:myRoundedCourseHandicap];


	if(player2Handicap != nil)
		[strokesGivenArray addObject:player2Handicap];
	if(player3Handicap!= nil)
		[strokesGivenArray addObject:player3Handicap];
	if(player4Handicap!= nil)
		[strokesGivenArray addObject:player4Handicap];

	int minCourseHandicap = [[strokesGivenArray valueForKeyPath:@"@min.intValue"] intValue];

	int strokesGivenMe = [myRoundedCourseHandicap integerValue]-minCourseHandicap;
		if(strokesGivenMe > 0)
			_strokesToGiveMy.text = [NSString stringWithFormat:@"%d",strokesGivenMe];
		else
			_strokesToGiveMy.text = @"-";

	int strokesGivenPlayer2 = [player2Handicap integerValue]-minCourseHandicap;
		if(strokesGivenPlayer2 > 0)
			_strokesToGive2.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer2];
		else
			_strokesToGive2.text = @"-";

	int strokesGivenPlayer3 = [player3Handicap integerValue]-minCourseHandicap;
		if(strokesGivenPlayer3 > 0)
			_strokesToGive3.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer3];
		else
			_strokesToGive3.text = @"-";

	int strokesGivenPlayer4 = [player4Handicap integerValue]-minCourseHandicap;
		if(strokesGivenPlayer4 > 0)
			_strokesToGive4.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer4];
		else
			_strokesToGive4.text = @"-";
}




@end
