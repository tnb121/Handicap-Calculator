//
//  CourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseHandicapViewController.h"
#import "ParseData.h"

@interface CourseHandicapViewController ()
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;

@end

@implementation CourseHandicapViewController


@synthesize courseHandicapLabel=_courseHandicapLabel;
@synthesize courseHandicapMyHandicapLabel=_courseHandicapMyHandicapLabel;
@synthesize courseHandicapSlopeValue=_courseHandicapSlopeValue;


@synthesize hCapClass=_hCapClass;


double courseSlope;
int slopeAverage;


-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}


- (IBAction)calculateCourseHandicap:(id)sender
{
	[self SharedCourseHandicapCalculation];
}

- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];

	_courseHandicapMyHandicapLabel.text = [self.hCapClass handicapCalculationString];
	[self.courseHandicapSlopeValue becomeFirstResponder];

	if([[[ParseData sharedParseData]roundCount]integerValue]==0)
		courseSlope= 113;
	else
		courseSlope = [[[ParseData sharedParseData] slopeAverage]doubleValue];
	slopeAverage = 0;


}

- (void)viewDidAppear:(BOOL)animated
{

	[super viewDidAppear:animated];
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
	_courseHandicapLabel.text= @"-";
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetDataAfterParseFetch) name:@"ParseCommunicationComplete" object:nil];
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

- (IBAction)dismissKeyboard:(id)sender
{
	[_courseHandicapSlopeValue resignFirstResponder];
}


- (void)doneDidTouchDown
{
	[self.courseHandicapSlopeValue resignFirstResponder];
	[self SharedCourseHandicapCalculation];
}

- (void)previousDidTouchDown
{

}
- (void)nextDidTouchDown
{

}

-(void)SharedCourseHandicapCalculation
{
	double myHandicap = [self.hCapClass handicapCalculation];
	double courseHCap= myHandicap * courseSlope / 113;

	if(courseHCap==0)
		_courseHandicapLabel.text= @"-";
	else
		_courseHandicapLabel.text = [NSString stringWithFormat:@"%.1f",courseHCap];
}


- (IBAction)toolbarSetup:(id)sender
{
[sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];
}


-(void)showSlopeAlertView
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Course Slope"
														message:@"Enter course slope:"
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
	[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[[alertView textFieldAtIndex:0] setDelegate:self];
	[[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
	[[alertView textFieldAtIndex:0] becomeFirstResponder];
	[alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        UITextField *alertViewCourseSlope = [alertView textFieldAtIndex:0];
		courseSlope=[alertViewCourseSlope.text integerValue];
		self.courseHandicapSlopeValue.text=[NSString stringWithFormat:@"%.0f",courseSlope];
    }
}

- (IBAction)ShowSlopePicker:(id)sender
{
	UIPickerView *slopePicker = [[UIPickerView alloc] init];
	slopePicker.delegate =self;
	slopePicker.showsSelectionIndicator = YES;

	if(slopeAverage==0)
	{

	if([[[ParseData sharedParseData]roundCount]integerValue]==0)
		slopeAverage = 113;
	else
		slopeAverage = [[[ParseData sharedParseData]slopeAverage]integerValue];
	}

	[self.courseHandicapSlopeValue setInputView:slopePicker];
	[slopePicker selectRow:(slopeAverage-55) inComponent:0 animated:NO];
	_courseHandicapSlopeValue.text=[NSString stringWithFormat:@"%d",slopeAverage];
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
	int rowInt=row + 55;
	return [NSString stringWithFormat:@"%d", rowInt];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    courseSlope = row + 55;
	slopeAverage=row + 55;
	_courseHandicapSlopeValue.text=[NSString stringWithFormat:@"%.0f",courseSlope];
	_courseHandicapMyHandicapLabel.text = [self.hCapClass handicapCalculationString];

}

-(void)SetDataAfterParseFetch
{
	_courseHandicapMyHandicapLabel.text = [self.hCapClass handicapCalculationString];
	[self SharedCourseHandicapCalculation];
}



@end
