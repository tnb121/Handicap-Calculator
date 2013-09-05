//
//  CourseHandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseHandicapViewController.h"

@interface CourseHandicapViewController ()

@end

@implementation CourseHandicapViewController

@synthesize courseHandicapLabel=_courseHandicapLabel;
@synthesize courseHandicapMyHandicapLabel=_courseHandicapMyHandicapLabel;
@synthesize courseHandicapRatingValue=_courseHandicapRatingValue;
@synthesize courseHandicapSlopeValue=_courseHandicapSlopeValue;

@synthesize hCapClass=_hCapClass;


-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}
-(NSArray*) fetchRoundResults
{
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"Courses" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];

	NSError *error;

	NSMutableArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
	if (array == nil)
	{
		// Deal with error...
	}

	NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"courseName" ascending:YES];
	[array sortUsingDescriptors:[NSArray arrayWithObject:sort]];

	NSLog(@"array: %@", array);

	return array;
}
- (IBAction)calculateCourseHandicap:(id)sender
{

	double myHandicap = [[self.hCapClass handicapCalculation]doubleValue];

	double courseSlope =[_courseHandicapSlopeValue.text doubleValue];

	_courseHandicapLabel.text= [NSString stringWithFormat:@"%.1f",myHandicap * courseSlope / 113];
}

- (void)viewWillAppear:(BOOL)animated
{

	[super viewWillAppear:animated];

		_courseHandicapMyHandicapLabel.text = [self.hCapClass handicapCalculation];
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
