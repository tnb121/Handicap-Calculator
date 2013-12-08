//
//  HandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRoundViewController.h"
#import "HomeScreenViewController.h"
#import "ParseData.h"

@interface HandicapViewController ()

@property (nonatomic, strong) Differential *diff;

@property (nonatomic,strong)Handicap * hCapClass;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong, nonatomic)NSMutableArray * teeColors;
@property (strong,nonatomic)NSMutableArray * coursesArray;
@property (strong,nonatomic) PFGeoPoint *currentLocation;


@property (strong,nonatomic)IBOutlet UITextField *ratingValue;
@property (strong,nonatomic)IBOutlet UITextField *slopeValue;
@property (strong,nonatomic)IBOutlet UITextField *scoreValue;
@property (strong,nonatomic)IBOutlet UITextField *dateValue;
@property (strong,nonatomic)IBOutlet UITextField *courseNameValue;
@property (strong,nonatomic)IBOutlet UITextField * teeValue;
@property (strong, nonatomic) IBOutlet UIButton *saveRoundButton;

@property (strong, nonatomic) IBOutlet UITextField *existingRoundText;

-(IBAction)CalculateDifferentialAction:(UIButton *)sender;
-(IBAction)dismissKeyboard:(id)sender;
-(IBAction)showTeePicker:(id)sender;


@end

@implementation HandicapViewController


@synthesize diff = _diff;
@synthesize hCapClass=_hCapClass;
@synthesize teeColors=_teeColors;


@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize scoreValue=_scoreValue;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;
@synthesize teeValue=_teeValue;
@synthesize saveRoundButton=_saveRoundButton;
@synthesize currentLocation=_currentLocation;


bool escDontShowAgain=YES;

@synthesize cameFromInfo=_cameFromInfo;

double lastHandicap;


-(Differential*) diff

{
	if(!_diff) _diff = [[Differential alloc] init];
	return _diff;
}

-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}


-(BOOL) RoundRatingCheck
{
	double rating = [_ratingValue.text doubleValue];

	if(rating>=65 && rating<=85)
		return YES;
	else
		return NO;
}

-(BOOL) RoundSlopeCheck
{
	double slope = [_slopeValue.text doubleValue];

	if(slope>=55 && slope<=155)
		return YES;
	else
		return NO;
}

-(BOOL) RoundScoreCheck
{
	double score = [_scoreValue.text doubleValue];

	if(score>=56 && score<=500)
		return YES;
	else
		return NO;
}

-(BOOL) RoundCourseNameCheck
{
	NSString * courseText = _courseNameValue.text;

	if([courseText  isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundTeeNameCheck
{
	NSString * teeText = _teeValue.text;

	if([teeText isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundDateCheck
{
	NSString * dateText = _dateValue.text;
	if([dateText isEqualToString:@""])
		return NO;
	else
		return YES;
}
-(BOOL)roundDataEntryComplete
{
	if ([self RoundCourseNameCheck] == YES && [self RoundTeeNameCheck] == YES && [self RoundDateCheck] == YES && [self RoundRatingCheck] == YES && [self RoundSlopeCheck] == YES && [self RoundScoreCheck]== YES )
	{
		self.saveRoundButton.enabled=YES;
		return YES;
	}
	else
	{
		self.saveRoundButton.enabled=NO;
		return NO;
	}
}

- (IBAction)testDataEntry:(id)sender
{

	if([self roundDataEntryComplete] == YES)
		return;
	else
		return;
	[self.view setNeedsDisplay];
}

-(void)AddRound
{
	NSNumberFormatter *differentialFormatter = [[NSNumberFormatter alloc] init];
	[differentialFormatter setMaximumFractionDigits:1];

	[[ParseData sharedParseData]incrementRoundCount];



	NSNumber *rating = [[NSNumber alloc] initWithDouble:[_ratingValue.text integerValue]];
	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeValue.text integerValue]];
	NSNumber *score= [[NSNumber alloc] initWithDouble:[_scoreValue.text integerValue]];
	NSString *courseName = [NSString stringWithFormat:@"%@", _courseNameValue.text];
	NSString *teeColor = [NSString stringWithFormat:@"%@", _teeValue.text];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:[_dateValue.text substringToIndex:10]];

	double differential = [self.diff CalculateDifferential:[_ratingValue.text integerValue] withslope:[_slopeValue.text integerValue] withscore:[_scoreValue.text integerValue]];
	NSString * differentialString = [NSString stringWithFormat:@"%.1f",differential];
	NSNumber * differentialRounded = [differentialFormatter numberFromString:differentialString];

	if(!_currentLocation) _currentLocation= [PFGeoPoint geoPointWithLatitude:0 longitude:0];


	// Save to HandicapHistory
	if ([[[ParseData sharedParseData]roundCount]integerValue]>= 5)

	{

		PFObject *handicapHistoryObject = [PFObject objectWithClassName:@"HandicapHistory"];
		handicapHistoryObject[@"historyUser"] = [PFUser currentUser].username;
		handicapHistoryObject[@"historyDate"] = [NSDate date];
		handicapHistoryObject[@"historyRoundCount"] = [NSNumber numberWithDouble:[[[ParseData sharedParseData]roundCount]integerValue]];
		handicapHistoryObject[@"historyHandicap"] = [NSNumber numberWithDouble:[self.hCapClass handicapCalculation]];
		handicapHistoryObject[@"historyScoringAverage"] = [NSNumber numberWithDouble:[[[ParseData sharedParseData]scoringAverage]doubleValue]];

		[handicapHistoryObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
		 {
			 if(!error)
			 {
				 [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedToUpdateDataFromParse" object:nil] ;
			 }
			 else NSLog(@"failed");
			 [handicapHistoryObject saveEventually];
		 }];
	}

	// Save to Rounds
	PFObject *roundObject = [PFObject objectWithClassName:@"Rounds"];
	roundObject[@"roundUser"] = [PFUser currentUser].username;
	roundObject[@"roundCourse"] = courseName;
	roundObject[@"roundTee"] = teeColor;
	roundObject[@"roundDate"] = date;
	roundObject[@"roundRating"] = rating;
	roundObject[@"roundSlope"] = slope;
	roundObject[@"roundScore"] = score;
	roundObject[@"roundDifferential"] = differentialRounded;
	roundObject[@"roundLocation"]=_currentLocation;

	[roundObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if(!error)
		{
				PFQuery *round20Query = [PFQuery queryWithClassName:@"Rounds"];
				[round20Query orderByDescending:@"roundDate"];
				[round20Query setLimit:(20)];
				[round20Query whereKey:@"roundUser" equalTo:[PFUser currentUser].username];

				[round20Query findObjectsInBackgroundWithBlock:^(NSArray *round20Objects,NSError *error)
				 {
					 if(!error)
					 {
						 NSLog(@"Success");
						 ParseData * parseData = [ParseData sharedParseData];
						parseData.roundsRecent20FromParse =[round20Objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"roundDifferential" ascending:NO]]];
						 [[NSNotificationCenter defaultCenter] postNotificationName:@"ParseCommunicationComplete" object:nil];
						 [self alertMessage];
						 [self performSegueWithIdentifier:@"SavetoHomeSegue" sender:self];
						 [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedToUpdateDataFromParse" object:nil];

					 }
					 else NSLog(@"failed");
				 }];

		}
		else
		{
			UIAlertView *failedAlert =[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Due to problems with your network connection your round was not saved.  The round will be saved when you are reconnected to the network." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[failedAlert show];
			[roundObject saveEventually];
			[self performSegueWithIdentifier:@"SavetoHomeSegue" sender:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"NeedToUpdateDataFromParse" object:nil];
		}
    }];


}

- (IBAction)CalculateDifferentialAction:(id)sender
{
	[self AddRound];

}

-(void) alertMessage
{
	NSString *mymessage=nil;
	int roundCount =[[[ParseData sharedParseData]roundCount]integerValue];
	int newHandicapRounded = [self.hCapClass handicapCalculation]*10;
	int lastHandicapRounded = lastHandicap*10;

	double lastHandicapDouble = lastHandicapRounded;

	NSString * lastHandicapString = [NSString stringWithFormat:@"%.1f",lastHandicapDouble/10];


	if(roundCount < 5)
		mymessage= @"A minimum of 5 rounds must be entered before a handicap can be calculated.";
	else if (roundCount == 5)
		mymessage = [NSString stringWithFormat:@"Your new handicap is %.1d",newHandicapRounded/10];
	else
		{
			if(newHandicapRounded < lastHandicapRounded)
			{
				mymessage = [NSString stringWithFormat:@"Your handicap decreased \r\n from %@ to %@",lastHandicapString,[self.hCapClass handicapCalculationString]];
			}
			else if (newHandicapRounded == lastHandicapRounded)
			{

				mymessage=[NSString stringWithFormat:@"Your handicap remained \r\n the same at %@",lastHandicapString];
			}
			else if (newHandicapRounded > lastHandicapRounded)
			{
				mymessage = [NSString stringWithFormat:@"Your handicap increased \r\n from %@ to %@",lastHandicapString,[self.hCapClass handicapCalculationString]];
			}
		}


	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:mymessage
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

	if ([[segue identifier] isEqualToString:@"SavetoHomeSegue"])
	{
		[self prepareForSaveRoundSegue:segue sender:sender];
		return;
	}
	NSLog(@"Unknown segue: %@", [segue identifier]);
}



- (void)prepareForSaveRoundSegue:(UIStoryboardSegue*)segue sender:(id)sender

{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
}

- (void)viewDidUnload
{
 
    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.saveRoundButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self escAlert];
	lastHandicap = [self.hCapClass mostRecentHandicap];

	[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
		if (!error) {
			_currentLocation=geoPoint;
		}
	}];

	ParseData *parseData = [ParseData sharedParseData];

	if(parseData.roundCount>0) [self courseAlert];
	else [_courseNameValue becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	_currentLocation=NULL;
}


- (IBAction)showDatePicker:(id)sender
{
	UIDatePicker *datePicker = [[UIDatePicker alloc]init];
	datePicker.datePickerMode = UIDatePickerModeDate;
	datePicker.maximumDate=[NSDate date];

	
	[datePicker setDate:[NSDate date]];
	[datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
	[self.dateValue setInputView:datePicker];

	UIDatePicker *picker = (UIDatePicker*)self.dateValue.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateValue.text = dateInput;

}
-(void)updateTextField:(id)sender
{
	UIDatePicker *picker = (UIDatePicker*)self.dateValue.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateValue.text = dateInput;
}

-(IBAction)showTeePicker:(id)sender
{
	UIPickerView *teePicker = [[UIPickerView alloc] init];
	teePicker.delegate =self;
	teePicker.showsSelectionIndicator = YES;
	teePicker.tag = 1;
	[self.teeValue setInputView:teePicker];


	// initialize the Array of tee colors
	_teeColors= [[NSMutableArray alloc] init];
	[_teeColors addObject:@"Black"];
	[_teeColors addObject:@"Blue"];
	[_teeColors addObject:@"Gold"];
	[_teeColors addObject:@"Green"];
	[_teeColors addObject:@"Red"];
	[_teeColors addObject:@"White"];
	[_teeColors addObject:@"Other"];

	_teeValue.text = [_teeColors objectAtIndex:0];

}

-(void)showCoursePicker2:(id)sender
{
	UIPickerView *coursePicker = [[UIPickerView alloc] init];
	coursePicker.delegate =self;
	coursePicker.showsSelectionIndicator = YES;
	coursePicker.tag = 2;
	[self.courseNameValue setInputView:coursePicker];

	ParseData * parseData = [ParseData sharedParseData];
	// initialize the Array of tee colors
	_coursesArray=[parseData.uniqueCourseArray mutableCopy];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

	if(pickerView.tag == 1) return _teeColors.count;
	if(pickerView.tag ==2) return _coursesArray.count;
	else return 0;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(pickerView.tag ==1) return [_teeColors objectAtIndex:row];
	if(pickerView.tag == 2)
	{
		NSString * courseName = [[_coursesArray objectAtIndex:row]valueForKey:@"name"];
		NSString * teeName = [[_coursesArray objectAtIndex:row]valueForKey:@"tee"];
		NSString * courseString2 = [[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
		return courseString2;
	}
		else return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if(pickerView.tag == 1) _teeValue.text=[_teeColors objectAtIndex:row];
	if(pickerView.tag ==2)
	{
		_courseNameValue.text =[[_coursesArray objectAtIndex:row] valueForKey:@"name"];
		_teeValue.text= [[_coursesArray objectAtIndex:row] valueForKey:@"tee"];
		_slopeValue.text = [NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:row] valueForKey:@"rating"]];
		_ratingValue.text =[NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:row] valueForKey:@"slope"]] ;
	}
}

#pragma mark Existing Course Picker View



- (IBAction) dismissKeyboard:(id)sender
{
	[_courseNameValue resignFirstResponder];
	[_teeValue resignFirstResponder];
	[_dateValue resignFirstResponder];
	[_slopeValue resignFirstResponder];
	[_scoreValue resignFirstResponder];
	[_existingRoundText resignFirstResponder];
}
- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}


- (void)nextDidTouchDown
{
	if (_courseNameValue.isFirstResponder)
		[self.teeValue becomeFirstResponder];
	else if (_teeValue.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_dateValue.isFirstResponder)
		[self.ratingValue becomeFirstResponder];
	else if (_ratingValue.isFirstResponder)
		[self.slopeValue becomeFirstResponder];
	else if(_slopeValue.isFirstResponder)
		[self.scoreValue becomeFirstResponder];
	else if (_scoreValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
}

- (void)previousDidTouchDown
{
	if (_courseNameValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
	else if (_teeValue.isFirstResponder)
		[self.courseNameValue becomeFirstResponder];
	else if (_dateValue.isFirstResponder)
		[self.teeValue becomeFirstResponder];
	else if (_ratingValue.isFirstResponder)
		[self.dateValue becomeFirstResponder];
	else if (_slopeValue.isFirstResponder)
		[self.ratingValue becomeFirstResponder];
	else if (_scoreValue.isFirstResponder)
		[self.slopeValue becomeFirstResponder];
	
}

- (void)doneDidTouchDown
{


	if([_existingRoundText isFirstResponder] == YES)
	{
		[_existingRoundText resignFirstResponder];
[_dateValue becomeFirstResponder];
	}
	else 	[self dismissKeyboard:self];;
}

-(void) escAlert
{
	escDontShowAgain = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontShowAgain"];
	if(escDontShowAgain ==YES && _cameFromInfo==NO)
		{
			NSString * escMessage = @"Are you using Equitable Stroke Control (ESC)?  See Information section for more details about ESC.";

			UIAlertView *escAlert = [[UIAlertView alloc]
									 initWithTitle:nil
									 message:escMessage
									 delegate:self
									 cancelButtonTitle:Nil
									 otherButtonTitles: @"OK",@"Learn About ESC",@"Don't show again",nil];
			escAlert.cancelButtonIndex = 1;
			[escAlert show];

		}
	else return;
}

-(void)courseAlert
{

		UIAlertView *courseAlert = [[UIAlertView alloc]
								 initWithTitle:nil
								 message:@"Is this a new or existing course?"
								 delegate:self
								 cancelButtonTitle:Nil
								 otherButtonTitles: @"New",@"Existing",nil];
		[courseAlert show];

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:@"Learn About ESC"])
		{
			_cameFromInfo=YES;
			[self performSegueWithIdentifier:@"escInfoSegue" sender:self];
		}
	if ([buttonTitle isEqualToString:@"Don't show again"])
		{
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dontShowAgain"];
		}

	if ([buttonTitle isEqualToString:@"New"])
	{
		[self.courseNameValue becomeFirstResponder];
	}

	if ([buttonTitle isEqualToString:@"Existing"])
	{
		[self dismissKeyboard:(self)];
		[self.existingRoundText becomeFirstResponder];

	}


}
- (IBAction)showCoursePicker:(id)sender
{

	UIPickerView * coursePicker= [[UIPickerView alloc] init];
	coursePicker.delegate=self;
	coursePicker.showsSelectionIndicator=YES;
	coursePicker.tag=2;
	[self.existingRoundText setInputView:coursePicker];

	ParseData * parseData = [ParseData sharedParseData];
	_coursesArray=[parseData.uniqueCourseArray mutableCopy];
	_courseNameValue.text =[[_coursesArray objectAtIndex:0] valueForKey:@"name"];
	_teeValue.text= [[_coursesArray objectAtIndex:0] valueForKey:@"tee"];
	_slopeValue.text = [NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:0] valueForKey:@"rating"]];
	_ratingValue.text =[NSString stringWithFormat:@"%@",[[_coursesArray objectAtIndex:0] valueForKey:@"slope"]] ;

}

@end
