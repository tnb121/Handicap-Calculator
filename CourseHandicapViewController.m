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
@synthesize courseData=_courseData;

@synthesize managedObjectContext=_managedObjectContext;

@synthesize courseHandicapLabel=_courseHandicapLabel;
@synthesize courseHandicapMyHandicapLabel=_courseHandicapMyHandicapLabel;
@synthesize courseHandicapSlopeValue=_courseHandicapSlopeValue;
@synthesize courseHandicapCalculateButton=_courseHandicapCalculateButton;

@synthesize hCapClass=_hCapClass;
@synthesize coursesClass=_coursesClass;
@synthesize tees=_tees;
@synthesize courseAttributes=_courseAttributes;


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
	[self.courseData reloadData];
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

	self.courseData.delegate=self;
	self.courseData.dataSource=self;
	self.courseHandicapCalculateButton.enabled=NO;
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
	[self.courseHandicapSlopeValue resignFirstResponder];
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
	double courseSlope =[_courseHandicapSlopeValue.text doubleValue];
	double courseHCap= myHandicap * courseSlope / 113;

	if(courseHCap==0)
		_courseHandicapLabel.text= @"-";
	else
		_courseHandicapLabel.text = [NSString stringWithFormat:@"%.1f",courseHCap];
}


- (IBAction)toolbarSetup:(id)sender
{
[sender setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
}


@end
