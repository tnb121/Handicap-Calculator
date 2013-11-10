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
#import "Rounds.h"
#import "Tee.h"
#import "Courses.h"
#import "HandicapHistory.h"



@interface HandicapViewController ()
@property (nonatomic, strong) Differential *diff;
@property (nonatomic,strong)Handicap * hCapClass;
@property (nonatomic,strong)HandicapHistory*handicapHistoryClass;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong, nonatomic)NSMutableArray * teeColors;

@end

@implementation HandicapViewController


@synthesize diff = _diff;
@synthesize hCapClass=_hCapClass;
@synthesize handicapHistoryClass=_handicapHistoryClass;
@synthesize teeColors=_teeColors;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize scoreValue=_scoreValue;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;
@synthesize teeValue=_teeValue;
@synthesize saveRoundButton=_saveRoundButton;


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
-(HandicapHistory*)handicapHistoryClass
{
	if(!_handicapHistoryClass) _handicapHistoryClass=[[HandicapHistory alloc]init];
	return _handicapHistoryClass;
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



NSNumber *rating = [[NSNumber alloc] initWithDouble:[_ratingValue.text integerValue]];	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeValue.text integerValue]];
	NSNumber *score= [[NSNumber alloc] initWithDouble:[_scoreValue.text integerValue]];
	NSString *courseName = [NSString stringWithFormat:@"%@", _courseNameValue.text];
	NSString *teeColor = [NSString stringWithFormat:@"%@", _teeValue.text];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:[_dateValue.text substringToIndex:10]];

	double differential = [self.diff CalculateDifferential:[_ratingValue.text integerValue] withslope:[_slopeValue.text integerValue] withscore:[_scoreValue.text integerValue]];
	NSString * differentialString = [NSString stringWithFormat:@"%.1f",differential];
	NSNumber * differentialRounded = [differentialFormatter numberFromString:differentialString];



	PFObject *roundObject = [PFObject objectWithClassName:@"Rounds"];
	roundObject[@"roundUser"] = [PFUser currentUser].username;
	roundObject[@"roundCourse"] = courseName;
	roundObject[@"roundTee"] = teeColor;
	roundObject[@"roundDate"] = date;
	roundObject[@"roundRating"] = rating;
	roundObject[@"roundSlope"] = slope;
	roundObject[@"roundScore"] = score;
	roundObject[@"roundDifferential"] = differentialRounded;
	[roundObject saveInBackground];



	if ([self.hCapClass roundCountCalculation]>= 5)

	{

		PFObject *handicapHistoryObject = [PFObject objectWithClassName:@"HandicapHistory"];
		handicapHistoryObject[@"historyUser"] = [PFUser currentUser].username;
		handicapHistoryObject[@"historyDate"] = [NSDate date];
		handicapHistoryObject[@"historyRoundCount"] = [NSNumber numberWithDouble:[self.hCapClass roundCountCalculation]];
		handicapHistoryObject[@"historyHandicap"] = [NSNumber numberWithDouble:[self.hCapClass handicapCalculation]];
		handicapHistoryObject[@"historyScoringAverage"] = [NSNumber numberWithDouble:[self.hCapClass scoringAverageCalculation]];
		[handicapHistoryObject saveInBackground];
	}

}

- (IBAction)CalculateDifferentialAction:(id)sender
{
	lastHandicap = [self.handicapHistoryClass mostRecentHandicap];
	[self AddRound];
	[self alertMessage];
	[self performSegueWithIdentifier:@"SavetoHomeSegue" sender:self];
}

-(void) alertMessage
{
	NSString *mymessage=nil;
	double newHandicap = [self.hCapClass handicapCalculation];
	int roundCount = [self.hCapClass roundCountCalculation];

	if(roundCount < 5)
		mymessage= @"A minimum of 5 rounds must be entered before a handicap can be calculated.";
	else if (roundCount == 5)
		mymessage = [NSString stringWithFormat:@"Your new handicap is %.1f",newHandicap];
	else
		{
			if(newHandicap < lastHandicap)
			{
				mymessage = [NSString stringWithFormat:@"Your handicap decreased \r\n from %.1f to %.1f",lastHandicap,newHandicap];
			}
			else if (newHandicap == lastHandicap)
			{

				mymessage=[NSString stringWithFormat:@"Your handicap remained \r\n the same at %.1f",lastHandicap];
			}
			else if (newHandicap > lastHandicap)
			{
				mymessage = [NSString stringWithFormat:@"Your handicap increased \r\n from %.1f to %.1f",lastHandicap,newHandicap];
			}
			}


	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:mymessage
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];

}


-(NSArray*)recordsInTable:(NSString*)tableName andManageObjectContext:(NSManagedObjectContext *)manageObjContext
	{
		NSError *error=nil;

		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName: tableName inManagedObjectContext:manageObjContext];
		[fetchRequest setEntity:entity];
		NSArray *fetchedObjects = [manageObjContext executeFetchRequest:fetchRequest error:&error];
		return  fetchedObjects;
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

		if (_managedObjectContext == nil)
		{
			_managedObjectContext = [(HandicapAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		}


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
	[self.courseNameValue becomeFirstResponder];
	self.saveRoundButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[self escAlert];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	//One column
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	//set number of rows
	return _teeColors.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	//set item per row
	return [_teeColors objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _teeValue.text=[_teeColors objectAtIndex:row];
}



- (IBAction) dismissKeyboard:(id)sender
{
	[_courseNameValue resignFirstResponder];
	[_teeValue resignFirstResponder];
	[_dateValue resignFirstResponder];
	[_slopeValue resignFirstResponder];
	[_scoreValue resignFirstResponder];
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
	[self dismissKeyboard:self];
}

-(void) escAlert
{


	BOOL dontShowAgain = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontShowAgain"];
	if(dontShowAgain ==YES && _cameFromInfo==NO)
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
}

@end
