//
//  EditRoundViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/8/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "EditRoundViewController.h"
#import <UIKit/UIKit.h>
#import "AddRoundViewController.h"
#import "HandicapAppDelegate.h"
#import "HomeScreenViewController.h"
#import "Rounds.h"
#import "Tee.h"
#import "Courses.h"
#import "HandicapHistory.h"



@interface EditRoundViewController ()
@property (nonatomic, strong) Differential *diff;
@property (nonatomic,strong)Handicap * hCapClass;
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong,nonatomic)NSMutableArray * teeColors;
@end


@implementation EditRoundViewController


@synthesize diff = _diff;
@synthesize hCapClass=_hCapClass;
@synthesize rounds;
@synthesize teeColors=_teeColors;


@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize courseNameEditRound=_courseNameEditRound;
@synthesize teeEditRound=_teeEditRound;
@synthesize dateEditRound=_dateEditRound;
@synthesize ratingEditRound=_ratingEditRound;
@synthesize slopeEditRound=_slopeEditRound;
@synthesize scoreEditRound=_scoreEditRound;
@synthesize saveChangesEditRoundButton=_saveChangesEditRoundButton;


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
	double rating = [_ratingEditRound.text doubleValue];

	if(rating>=65 && rating<=85)
		return YES;
	else
		return NO;
}

-(BOOL) RoundSlopeCheck
{
	double slope = [_slopeEditRound.text doubleValue];

	if(slope>=55 && slope<=155)
		return YES;
	else
		return NO;
}

-(BOOL) RoundScoreCheck
{
	double score = [_scoreEditRound.text doubleValue];

	if(score>=56 && score<=500)
		return YES;
	else
		return NO;
}

-(BOOL) RoundCourseNameCheck
{
	NSString * courseText = _courseNameEditRound.text;

	if([courseText  isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundTeeNameCheck
{
	NSString * teeText = _teeEditRound.text;

	if([teeText isEqualToString:@""])
		return NO;
	else
		return YES;
}

-(BOOL) RoundDateCheck
{
	NSString * dateText = _dateEditRound.text;
	if([dateText isEqualToString:@""])
		return NO;
	else
		return YES;
}
-(BOOL)roundDataEntryComplete
{
	if ([self RoundCourseNameCheck] == YES && [self RoundTeeNameCheck] == YES && [self RoundDateCheck] == YES && [self RoundRatingCheck] == YES && [self RoundSlopeCheck] == YES && [self RoundScoreCheck]== YES )
	{
		self.saveChangesEditRoundButton.enabled=YES;
		return YES;
	}
	else
	{
		self.saveChangesEditRoundButton.enabled=NO;
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

-(void)SaveChanges
{
	NSManagedObjectContext * context = self.managedObjectContext;

	NSNumber *rating = [[NSNumber alloc] initWithDouble:[_ratingEditRound.text integerValue]];
	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeEditRound.text integerValue]];
	NSNumber *score= [[NSNumber alloc] initWithDouble:[_scoreEditRound.text integerValue]];
	NSString *courseName = [NSString stringWithFormat:@"%@", _courseNameEditRound.text];
	NSString *teeColor = [NSString stringWithFormat:@"%@", _teeEditRound.text];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:[_dateEditRound.text substringToIndex:10]];

	NSNumber *differential = [[NSNumber alloc] initWithDouble:[self.diff CalculateDifferential:[_ratingEditRound.text integerValue] withslope:[_slopeEditRound.text integerValue] withscore:[_scoreEditRound.text integerValue]]];



	[self.rounds setValue:date forKey:@"roundDate"];
	[self.rounds setValue:score forKey:@"roundScore"];
	[self.rounds setValue:differential forKey:@"roundDifferential"];

	[self.rounds.courses setValue:rating forKey:@"courseRating"];
	[self.rounds.courses setValue:slope forKey:@"courseSlope"];
	[self.rounds.courses setValue:courseName forKey:@"courseName"];

	[self.rounds.courses.tees setValue:teeColor forKey:@"teeColor"];

	NSError *error;
	[context save:&error];

	/*if ([self.hCapClass roundCountCalculation] < 5)
		return;
	else

	{
		HandicapHistory * history = [NSEntityDescription insertNewObjectForEntityForName:@"HandicapHistory" inManagedObjectContext:context];
		[history setValue:[NSDate date] forKey:@"historyDate"];
		[history setValue:[NSNumber numberWithDouble:[self.hCapClass handicapCalculation]]  forKey:@"historyHCap"];
		[history setValue:[NSNumber numberWithDouble:[self.hCapClass scoringAverageCalculation]] forKey:@"historyScoringAverage"];
		[history setValue:[NSNumber numberWithDouble:[self.hCapClass roundCountCalculation]] forKey:@"historyRoundCount"];	}

	[context save:&error];
	 */
}


- (IBAction)CalculateDifferentialAction:(id)sender
{

	//NSString *mymessage1 =[NSString stringWithFormat:@"Round Differential = %.1f",[self.diff CalculateDifferential:[_ratingEditRound.text integerValue] withslope:[_slopeEditRound.text integerValue] withscore:[_scoreEditRound.text integerValue]]];

	//NSString * mymessage2 = @"A minimum of 5 rounds must be entered before a handicap can be calculated.";





	[self SaveChanges];
	[self performSegueWithIdentifier:@"EditToHomeSegue" sender:self];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.saveChangesEditRoundButton.enabled = NO;
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;
	[self setTextFieldValues];
	[self roundDataEntryComplete];
}

-(void)setTextFieldValues
{
	self.courseNameEditRound.text = self.rounds.courses.courseName;
	self.teeEditRound.text = self.rounds.courses.tees.teeColor;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:self.rounds.roundDate];
	self.dateEditRound.text = dateInput;
	self.ratingEditRound.text=[NSString stringWithFormat:@"%.1f",[self.rounds.courses.courseRating doubleValue]];
	self.slopeEditRound.text=[NSString stringWithFormat: @"%d",[self.rounds.courses.courseSlope integerValue]];
	self.scoreEditRound.text=[NSString stringWithFormat: @"%d",[self.rounds.roundScore integerValue]];
}

- (void)viewDidUnload
{

    [super viewDidUnload];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self.courseNameEditRound becomeFirstResponder];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
	[self.dateEditRound setInputView:datePicker];

	UIDatePicker *picker = (UIDatePicker*)self.dateEditRound.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateEditRound.text = dateInput;

}
-(void)updateTextField:(id)sender
{
	UIDatePicker *picker = (UIDatePicker*)self.dateEditRound.inputView;

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSString* dateInput=[formatter stringFromDate:picker.date];
	self.dateEditRound.text = dateInput;
}

-(IBAction)showTeePicker:(id)sender
{
	UIPickerView *teePicker = [[UIPickerView alloc] init];
	teePicker.delegate =self;
	teePicker.showsSelectionIndicator = YES;
	[self.teeEditRound setInputView:teePicker];


	// initialize the Array of tee colors
	_teeColors= [[NSMutableArray alloc] init];
	[_teeColors addObject:@"Black"];
	[_teeColors addObject:@"Blue"];
	[_teeColors addObject:@"Gold"];
	[_teeColors addObject:@"Green"];
	[_teeColors addObject:@"Red"];
	[_teeColors addObject:@"White"];
	[_teeColors addObject:@"Other"];

	_teeEditRound.text = [_teeColors objectAtIndex:0];

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
    _teeEditRound.text=[_teeColors objectAtIndex:row];
}



- (IBAction) dismissKeyboard:(id)sender
{
	[_courseNameEditRound resignFirstResponder];
	[_teeEditRound resignFirstResponder];
	[_dateEditRound resignFirstResponder];
	[_ratingEditRound resignFirstResponder];
	[_slopeEditRound resignFirstResponder];
	[_scoreEditRound resignFirstResponder];
}

- (IBAction)toolbarSetup:(id)sender
{
    [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}


- (void)nextDidTouchDown
{
	if (_courseNameEditRound.isFirstResponder)
		[self.teeEditRound becomeFirstResponder];
	else if (_teeEditRound.isFirstResponder)
		[self.dateEditRound becomeFirstResponder];
	else if (_dateEditRound.isFirstResponder)
		[self.ratingEditRound becomeFirstResponder];
	else if (_ratingEditRound.isFirstResponder)
		[self.slopeEditRound becomeFirstResponder];
	else if(_slopeEditRound.isFirstResponder)
		[self.scoreEditRound becomeFirstResponder];
	else if (_scoreEditRound.isFirstResponder)
		[self.courseNameEditRound becomeFirstResponder];
}

- (void)previousDidTouchDown
{
	if (_courseNameEditRound.isFirstResponder)
		[self.courseNameEditRound becomeFirstResponder];
	else if (_teeEditRound.isFirstResponder)
		[self.courseNameEditRound becomeFirstResponder];
	else if (_dateEditRound.isFirstResponder)
		[self.teeEditRound becomeFirstResponder];
	else if (_ratingEditRound.isFirstResponder)
		[self.dateEditRound becomeFirstResponder];
	else if (_slopeEditRound.isFirstResponder)
		[self.ratingEditRound becomeFirstResponder];
	else if (_scoreEditRound.isFirstResponder)
		[self.slopeEditRound becomeFirstResponder];

}

- (void)doneDidTouchDown
{
	[self dismissKeyboard:self];
}

@end
