//
//  GroupCourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "GroupCourseHandicapViewController.h"
#import "ParseData.h"

@interface GroupCourseHandicapViewController ()
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong,nonatomic) Handicap * hCapClass;


@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextField *player2HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player3HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player4HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *groupCourseSlope;

@property (strong, nonatomic) IBOutlet UILabel *myHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *myCourseHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *player2CourseHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *player3CourseHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *player4CourseHandicapLabel;

@property (strong, nonatomic) IBOutlet UILabel *strokesToGiveMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive2Label;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive3Label;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive4Label;

@end

@implementation GroupCourseHandicapViewController
@synthesize hCapClass=_hCapClass;
@synthesize groupCourseSlope=_groupCourseSlope;
@synthesize scrollview;


@synthesize player2HandicapValue=_player2HandicapValue;
@synthesize player3HandicapValue=_player3HandicapValue;
@synthesize player4HandicapValue=_player4HandicapValue;

@synthesize myHandicapLabel=_myHandicapLabel;
@synthesize myCourseHandicapLabel=_myCourseHandicapLabel;
@synthesize player2CourseHandicapLabel=_player2CourseHandicapLabel;
@synthesize player3CourseHandicapLabel=_player3CourseHandicapLabel;
@synthesize player4CourseHandicapLabel=_player4CourseHandicapLabel;

bool scrollBOOL;

double myHandicap;
double player2Handicap;
double player3Handicap;
double player4Handicap;

double myCourseHandicap;
double player2CourseHandicap;
double player3CourseHandicap;
double player4CourseHandicap;

int courseSlope;

-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}

- (IBAction)calculateGroupCourseHandicap:(id)sender
{
	myHandicap = [self.hCapClass handicapCalculation];
	player2Handicap = [_player2HandicapValue.text doubleValue];
	player3Handicap = [_player3HandicapValue.text doubleValue];
	player4Handicap = [_player4HandicapValue.text doubleValue];
	courseSlope =[_groupCourseSlope.text doubleValue];

	myCourseHandicap=lround(myHandicap*courseSlope/113);
	player2CourseHandicap=lround(player2Handicap*courseSlope/113);
	player3CourseHandicap=lround(player3Handicap*courseSlope/113);
	player4CourseHandicap=lround(player4Handicap*courseSlope/113);

	_myCourseHandicapLabel.text= [NSString stringWithFormat:@"%.0f",myCourseHandicap];
	if(!_player2HandicapValue.text)
		_player2CourseHandicapLabel.text=@"-";
	else
		_player2CourseHandicapLabel.text =[NSString stringWithFormat:@"%ld",lround(player2Handicap * courseSlope / 113)];

	if(!_player3HandicapValue.text)
		_player3CourseHandicapLabel.text=@"-";
	else
		_player3CourseHandicapLabel.text =[NSString stringWithFormat:@"%ld",lround(player3Handicap * courseSlope / 113)];

	if(!_player4HandicapValue.text)
		_player4CourseHandicapLabel.text=@"-";
	else
		_player4CourseHandicapLabel.text =[NSString stringWithFormat:@"%ld",lround(player4Handicap * courseSlope / 113)];

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetDataAfterParseFetch) name:@"ParseCommunicationComplete" object:nil];
}
	-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self goToOrigin];
	_myHandicapLabel.text = [self.hCapClass handicapCalculationString];
	_player2HandicapValue.enabled=NO;
	_player3HandicapValue.enabled=NO;
	_player4HandicapValue.enabled=NO;
	[self.groupCourseSlope becomeFirstResponder];
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

	[self CheckGroupSlope];
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

	[self CheckGroupSlope];
}

- (void)doneDidTouchDown
{
	[self dismissKeyboard:self];
	[self calculateGroupCourseHandicap:self];
	[self goToOrigin];
	[self strokesGivenCalculation];
	[self CheckGroupSlope];
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

-(void)CheckGroupSlope
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

	NSNumber * myCourseHandicapObject = [NSNumber numberWithInt:myCourseHandicap];
	NSNumber * player2CourseHandicapObject = nil;
	NSNumber * player3CourseHandicapObject = nil;
	NSNumber * player4CourseHandicapObject = nil;

	if(![_player2HandicapValue.text isEqualToString:@""]) player2CourseHandicapObject = [NSNumber numberWithInt:player2CourseHandicap];

	if(![_player3HandicapValue.text  isEqualToString:@""])player3CourseHandicapObject = [NSNumber numberWithInt:player3CourseHandicap];

	if(![_player4HandicapValue.text  isEqualToString:@""])player4CourseHandicapObject= [NSNumber numberWithInt:lround(player4CourseHandicap)];


	NSMutableArray * strokesGivenArray = [NSMutableArray new];
	[strokesGivenArray addObject:myCourseHandicapObject];

	if(player2CourseHandicapObject != nil)[strokesGivenArray addObject:player2CourseHandicapObject];
	if(player3CourseHandicapObject != nil)[strokesGivenArray addObject:player3CourseHandicapObject];
	if(player4CourseHandicapObject != nil)[strokesGivenArray addObject:player4CourseHandicapObject];

	int minCourseHandicap = [[strokesGivenArray valueForKeyPath:@"@min.intValue"] intValue];

	int strokesGivenMe = [myCourseHandicapObject integerValue]-minCourseHandicap;
		if(strokesGivenMe > 0) _strokesToGiveMeLabel.text = [NSString stringWithFormat:@"%d",strokesGivenMe];
		else _strokesToGiveMeLabel.text = @"-";

	int strokesGivenPlayer2 = [player2CourseHandicapObject integerValue]-minCourseHandicap;
		if(strokesGivenPlayer2 > 0) _strokesToGive2Label.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer2];
		else _strokesToGive2Label.text = @"-";

	int strokesGivenPlayer3 = [player3CourseHandicapObject integerValue]-minCourseHandicap;
		if(strokesGivenPlayer3 > 0) _strokesToGive3Label.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer3];
		else _strokesToGive3Label.text = @"-";

	int strokesGivenPlayer4 = [player4CourseHandicapObject integerValue]-minCourseHandicap;
		if(strokesGivenPlayer4 > 0) _strokesToGive4Label.text = [NSString stringWithFormat:@"%d",strokesGivenPlayer4];
		else _strokesToGive4Label.text = @"-";
}

- (IBAction)ShowSlopePicker:(id)sender
{
	UIPickerView *slopePicker = [[UIPickerView alloc] init];
	slopePicker.delegate =self;
	slopePicker.showsSelectionIndicator = YES;

	int slopeAverage;

	if([[[ParseData sharedParseData]roundCount]integerValue]==0)slopeAverage = 113;
	else slopeAverage = [[[ParseData sharedParseData]slopeAverage]integerValue];

	[self.groupCourseSlope setInputView:slopePicker];
	[slopePicker selectRow:(slopeAverage-55) inComponent:0 animated:NO];
	_groupCourseSlope.text=[NSString stringWithFormat:@"%d",slopeAverage];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	//set number of rows
	return 101;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	//set item per row
	return [NSString stringWithFormat:@"%d", row + 55];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_groupCourseSlope.text=[NSString stringWithFormat:@"%d",row + 55];
	[self calculateGroupCourseHandicap:(id)self];
}

-(void)SetDataAfterParseFetch
{
	_myHandicapLabel.text = [self.hCapClass handicapCalculationString];
	[self calculateGroupCourseHandicap:(id)self];
}


@end
