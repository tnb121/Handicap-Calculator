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
@end

@implementation CourseHandicapViewController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize courseData=_courseData;

@synthesize managedObjectContext=_managedObjectContext;

@synthesize courseHandicapLabel=_courseHandicapLabel;
@synthesize courseHandicapMyHandicapLabel=_courseHandicapMyHandicapLabel;
@synthesize courseHandicapSlopeValue=_courseHandicapSlopeValue;

@synthesize hCapClass=_hCapClass;
@synthesize coursesClass=_coursesClass;


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


- (NSFetchedResultsController *)fetchedResultsController
{
	HandicapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = [appDelegate managedObjectContext];
	self.managedObjectContext=context;

	if (_fetchedResultsController != nil)
	{
        return _fetchedResultsController;
    }

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [NSEntityDescription entityForName:@"Courses" inManagedObjectContext:self.managedObjectContext];

	[fetchRequest setReturnsDistinctResults:YES];

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
    self.fetchedResultsController = aFetchedResultsController;

	// handle errors
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
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
	Courses * courses =(Courses *) [self.fetchedResultsController objectAtIndexPath:indexPath];

	UILabel *courseNameLabel = (UILabel *)[cell.contentView viewWithTag:110];
	NSString * courseName = courses.courseName;
	NSString * teeName = courses.tees.teeColor;
	NSString * courseAndTee =[[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
    [courseNameLabel setText:courseAndTee];

	UILabel *courseSlopeLabel = (UILabel *)[cell.contentView viewWithTag:120];
	NSString* SlopeLabelText = [NSString stringWithFormat:@"%d",[courses.courseSlope intValue]];
	[courseSlopeLabel setText:SlopeLabelText];

	UILabel *courseRatingLabel = (UILabel *)[cell.contentView viewWithTag:140];
	NSString* RatingLabelText = [NSString stringWithFormat:@"%d",[courses.courseRating intValue]];
	[courseRatingLabel setText:RatingLabelText];

	UILabel *courseHCapLabel = (UILabel *)[cell.contentView viewWithTag:130];
	double courseHCap = [self.hCapClass handicapCalculation] * [courses.courseSlope intValue]/113;
	NSString * courseHCapLabelText = [NSString stringWithFormat:@"%.1f",courseHCap];
    [courseHCapLabel setText:courseHCapLabelText];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int c =[self.fetchedResultsController.fetchedObjects count];
	return c;
}
- (IBAction)calculateCourseHandicap:(id)sender
{

	double myHandicap = [self.hCapClass handicapCalculation];
	double courseSlope =[_courseHandicapSlopeValue.text doubleValue];
	double courseHCap= myHandicap * courseSlope / 113;

	if(courseHCap==0)
		_courseHandicapLabel.text= @"-";
	else
		_courseHandicapLabel.text = [NSString stringWithFormat:@"%.1f",courseHCap];
}

- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];

		_courseHandicapMyHandicapLabel.text = [self.hCapClass handicapCalculationString];
		[_courseData reloadData];
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
	self.enhancedKeyboard.delegate = self;
	self.courseData.delegate=self;
	self.courseData.dataSource=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboard:(id)sender
{
	[self.courseHandicapSlopeValue resignFirstResponder];
}
- (IBAction)toolbarSetup:(id)sender
{
 [sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:NO NextEnabled:NO DoneEnabled:YES]];}

- (void)doneDidTouchDown
{
	[self.courseHandicapSlopeValue resignFirstResponder];

	double myHandicap = [self.hCapClass handicapCalculation];
	double courseSlope =[_courseHandicapSlopeValue.text doubleValue];
	double courseHCap= myHandicap * courseSlope / 113;

	if(courseHCap==0)
		_courseHandicapLabel.text= @"-";
	else
		_courseHandicapLabel.text = [NSString stringWithFormat:@"%.1f",courseHCap];
}

- (void)previousDidTouchDown
{

}
- (void)nextDidTouchDown
{

}



@end
