//
//  HandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapViewController.h"



@interface HandicapViewController ()
@property (nonatomic, strong) Differential *diff;
@end

@implementation HandicapViewController

@synthesize mymessage;
@synthesize diff = _diff;
@synthesize delegate;

@synthesize ratingValue=_ratingValue;
@synthesize slopeValue=_slopeValue;
@synthesize scoreValue=_scoreValue;
@synthesize differential;
@synthesize dateValue=_dateValue;
@synthesize courseNameValue=_courseNameValue;

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

	NSNumber *rating = [[NSNumber alloc] initWithDouble:[_ratingValue.text integerValue]];
	NSNumber *slope = [[NSNumber alloc] initWithDouble:[_slopeValue.text integerValue]];
	NSNumber *score= [[NSNumber alloc] initWithDouble:[_scoreValue.text integerValue]];
	NSString * courseName = _courseNameValue.text;

	


	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	NSDate *date = [formatter dateFromString:_dateValue.text];


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


}


- (IBAction)CalculateDifferentialAction:(id)sender
{

	[self AddRound];

	mymessage =[NSString stringWithFormat:@"Round Differential = %.1f",[self.diff CalculateDifferential:[self RoundRatingFromTextInput] withslope:[self RoundSlopeFromTextInput] withscore:[self RoundScoreFromTextInput]]];


	// open an alert with just an OK button
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:mymessage
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	
}



-(IBAction)dismissKeyboard:(id)sender
{
	[sender resignFirstResponder];
}


- (IBAction)cancel:(id)sender
{
	[self.delegate HandicapViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate HandicapViewControllerDidCancel:self];
}





@end
