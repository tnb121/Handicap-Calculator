//
//  HandicapViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapViewController.h"


@interface HandicapViewController ()

@end

@implementation HandicapViewController


- (IBAction)CalculateDifferential:(UIButton *)sender
{
	// Save Course Rating
	NSString *saveRating = ratingValue.text;
	NSUserDefaults *defaultsRating = [NSUserDefaults standardUserDefaults];
	[defaultsRating setObject:saveRating forKey:@"saveRating"];
	[defaultsRating synchronize];

	// Save Course Slope
	NSString *saveSlope =slopeValue.text;
	NSUserDefaults *defaultsSlope = [NSUserDefaults standardUserDefaults];
	[defaultsSlope setObject:saveSlope forKey:@"saveSlope"];
	[defaultsSlope synchronize];

	// Save Round Score
	NSString *saveScore = scoreValue.text;
	NSUserDefaults *defaultsScore = [NSUserDefaults standardUserDefaults];
	[defaultsScore setObject:saveScore forKey:@"saveScore"];
	[defaultsScore synchronize];

	//NSInteger myInt = [myString intValue];
	NSInteger rating = [ratingValue.text integerValue];
	NSInteger  slope = [slopeValue.text integerValue];
	NSInteger score = [scoreValue.text integerValue];

	[differential setText :[NSString stringWithFormat:@"Round Differential = %.1f",(score - rating)*113.0 / slope]];
}

-(IBAction)dismissRating:(id)sender
{
	[sender resignFirstResponder];
}

-(IBAction)dismissSlope:(id)sender
{
	[sender resignFirstResponder];
}
-(IBAction)dismissScore:(id)sender
{
	[sender resignFirstResponder];
}

@end





