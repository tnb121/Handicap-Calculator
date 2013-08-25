//
//  HandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandicapViewController.h"
#import "HandicapAppDelegate.h"
#import "HomeScreenViewController.h"
#import "DatePickerView.h"



@interface HandicapViewController ()
@property (nonatomic, strong) Differential *diff;
@end

@implementation HandicapViewController

@synthesize mymessage;
@synthesize diff = _diff;
@synthesize temp;

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize scoreValue=_scoreValue;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;
@synthesize differential=_differential;

-(Differential*) diff

{
	if(!_diff) _diff = [[Differential alloc] init];
	return _diff;
}


-(double) RoundRatingFromTextInput
{
	NSInteger rating = [_ratingValue.text integerValue];
	return rating;
}

-(double) RoundSlopeFromTextInput
{
	NSInteger slope = [_slopeValue.text integerValue];
	return slope;
}

-(double) RoundScoreFromTextInput
{
	NSInteger score = [_scoreValue.text integerValue];
	return score;
}

-(void)AddRound
{

	NSNumber *rating = [[NSNumber alloc] initWithDouble:[_scoreValue.text integerValue]];
	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeValue.text integerValue]];
	NSNumber *score= [[NSNumber alloc] initWithDouble:[_scoreValue.text integerValue]];
	NSString *courseName = [NSString stringWithFormat:@"%@", _courseNameValue.text];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [formatter dateFromString:[_dateValue.text substringToIndex:10]];
					
	temp = [self.diff CalculateDifferential:[self RoundRatingFromTextInput] withslope:[self RoundSlopeFromTextInput] withscore:[self RoundScoreFromTextInput]];
	NSNumber *differential = [[NSNumber alloc] initWithDouble:temp];

	

	HandicapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = [appDelegate managedObjectContext];

	NSEntityDescription *rounds = [NSEntityDescription entityForName:@"Rounds" inManagedObjectContext:context];
	NSFetchRequest *request =[[NSFetchRequest alloc]init];
	[request setEntity:rounds];

	NSManagedObject *newRound;
	newRound = [NSEntityDescription insertNewObjectForEntityForName:@"Rounds" inManagedObjectContext:context];
	NSError *error;
	[context save:&error];

	
	
	[newRound setValue:rating forKey:@"roundRating"];
	[newRound setValue:slope forKey:@"roundSlope"];
	[newRound setValue:score forKey:@"roundScore"];
	[newRound setValue:date	forKey:@"roundDate"];
	[newRound setValue:courseName forKey:@"roundCourseName"];
	[newRound setValue:differential	forKey:@"roundDifferential"];

	NSArray *rounddata=[self recordsInTable:@"Rounds" andManageObjectContext:context];
    NSLog(@"Rounds %@",rounddata);

}


- (IBAction)CalculateDifferentialAction:(id)sender
{

	mymessage =[NSString stringWithFormat:@"Round Differential = %.1f",[self.diff CalculateDifferential:[self RoundRatingFromTextInput] withslope:[self RoundSlopeFromTextInput] withscore:[self RoundScoreFromTextInput]]];


	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:mymessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];

	[self AddRound];
	
}

-(IBAction)dismissKeyboard:(id)sender
{
	[sender resignFirstResponder];
}


-(NSArray*)recordsInTable:(NSString*)tableName andManageObjectContext:(NSManagedObjectContext *)manageObjContext
	{
		NSError *error=nil;
		// **** log objects currently in database ****
		// create fetch object, this object fetch's the objects out of the database
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName: tableName inManagedObjectContext:manageObjContext];
		[fetchRequest setEntity:entity];
		NSArray *fetchedObjects = [manageObjContext executeFetchRequest:fetchRequest error:&error];
		return  fetchedObjects;
	}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

	if ([[segue identifier] isEqualToString:@"SaveRoundSegue"])
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

		HomeScreenViewController* vc = [segue destinationViewController];
		vc.managedObjectContext = self.managedObjectContext;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	DatePickerView *dateEntryView = [[DatePickerView alloc] init];
	self.dateValue.inputView = dateEntryView;
}

- (void)viewDidUnload
{
 
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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




@end
