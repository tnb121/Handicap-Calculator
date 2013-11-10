//
//  CourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseHandicapViewController.h"

@interface CourseHandicapViewController ()
@property (strong, nonatomic) KeyboardController *enhancedKeyboard;
@property (strong, nonatomic)NSMutableArray * courseAttributes;;
@end

@implementation CourseHandicapViewController

@synthesize CoursefetchedResultsController=_CoursefetchedResultsController;

@synthesize managedObjectContext=_managedObjectContext;

@synthesize courseHandicapLabel=_courseHandicapLabel;
@synthesize courseHandicapMyHandicapLabel=_courseHandicapMyHandicapLabel;
@synthesize courseHandicapSlopeValue=_courseHandicapSlopeValue;
@synthesize courseHandicapCalculateButton=_courseHandicapCalculateButton;

@synthesize hCapClass=_hCapClass;
@synthesize coursesClass=_coursesClass;
@synthesize tees=_tees;
@synthesize courseAttributes=_courseAttributes;

double courseSlope;
int slopeAverage;


-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}

-(Courses*)coursesClass
{
	if(!_coursesClass) _coursesClass=[[Courses alloc] init];
	return _coursesClass;
}
-(Tee*)tees
{
	if(!_tees)_tees = [[Tee alloc] init];
	return _tees;
}

-(BOOL) RoundSlopeCheck
{
	double slope = [_courseHandicapSlopeValue.text doubleValue];

	if(slope>=55 && slope<=155)
		return YES;
	else
		return NO;
}

-(BOOL)roundDataEntryComplete
{
	if ([self RoundSlopeCheck] == YES)
	{
		self.courseHandicapCalculateButton.enabled=YES;
		self.enhancedKeyboard = [[KeyboardController alloc] init];
		self.enhancedKeyboard.delegate = self;

		return YES;
	}
	else
	{
		self.courseHandicapCalculateButton.enabled=NO;
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

- (NSFetchedResultsController *)fetchedResultsController
{
	HandicapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = [appDelegate managedObjectContext];
	self.managedObjectContext=context;

	if (_CoursefetchedResultsController != nil)
	{
        return _CoursefetchedResultsController;
    }

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [NSEntityDescription entityForName:@"Courses" inManagedObjectContext:self.managedObjectContext];

	[fetchRequest setReturnsDistinctResults:YES];
	[fetchRequest setResultType:NSDictionaryResultType];


	_courseAttributes= [[NSMutableArray alloc] init];
	[_courseAttributes addObject:@"courseName"];
	[_courseAttributes addObject:@"courseRating"];
	[_courseAttributes addObject:@"courseSlope"];
	[_courseAttributes addObject:@"tees.teeColor"];



	[fetchRequest setPropertiesToFetch:_courseAttributes];
	// Set the sort descriptor
	NSSortDescriptor *  date = [[NSSortDescriptor alloc] initWithKey: @"courseName"
														   ascending: NO];
    NSArray *           sortDescriptors = [NSArray arrayWithObjects: date, nil];
    fetchRequest.sortDescriptors = sortDescriptors;

    // Initialize fetched results controller - creates cache
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest: fetchRequest
                                                             managedObjectContext: self.managedObjectContext
                                                             sectionNameKeyPath: nil
                                                             cacheName: nil];
    aFetchedResultsController.delegate = self;
    self.CoursefetchedResultsController = aFetchedResultsController;

	// handle errors
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _CoursefetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// set up and intialize TableView Cell
	static NSString *CellIdentifier = @"courseHandicapCell";
	UITableViewCell *   cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];

	if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


	// fetch results for Rounds

	NSDictionary* courseAttributes = [self.fetchedResultsController objectAtIndexPath:indexPath];

	NSString * courseName =[courseAttributes objectForKey:@"courseName"];
	NSString * teeName = [courseAttributes objectForKey:@"tees.teeColor"];

	UILabel *courseNameLabel = (UILabel *)[cell.contentView viewWithTag:110];
	NSString * courseAndTee =[[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
    [courseNameLabel setText:courseAndTee];

	UILabel *courseSlopeLabel = (UILabel *)[cell.contentView viewWithTag:120];
	NSString* SlopeLabelText = [NSString stringWithFormat:@"%d",[[courseAttributes objectForKey:@"courseSlope"]integerValue]];
	[courseSlopeLabel setText:SlopeLabelText];

	UILabel *courseRatingLabel = (UILabel *)[cell.contentView viewWithTag:140];
	NSString* RatingLabelText = [NSString stringWithFormat:@"%d",[[courseAttributes objectForKey:@"courseRating"] intValue]];
	[courseRatingLabel setText:RatingLabelText];



	UILabel *courseHCapLabel = (UILabel *)[cell.contentView viewWithTag:130];
	double courseHCap = [self.hCapClass handicapCalculation] * [[courseAttributes objectForKey:@"courseSlope"]integerValue]/113;

	if (courseHCap < 0)

		[courseHCapLabel setText: [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.1f",-(courseHCap)]]];
	else
		[courseHCapLabel setText:[NSString stringWithFormat:@"%.1f",courseHCap]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int fetchCount = [self.fetchedResultsController.fetchedObjects count];
	return fetchCount;
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

	if([self.hCapClass roundCountCalculation]==0)
		courseSlope= 113;
	else
		courseSlope = [self.hCapClass slopeAverage];
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
	self.courseHandicapCalculateButton.enabled=NO;
	self.enhancedKeyboard = [[KeyboardController alloc] init];
	self.enhancedKeyboard.delegate=self;

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.CoursefetchedResultsController = nil;
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

	if([self.hCapClass roundCountCalculation]==0)
		slopeAverage = 113;
	else
		slopeAverage = [self.hCapClass slopeAverage];
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



@end
