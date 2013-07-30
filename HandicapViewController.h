//
//  HandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandicapViewController : UIViewController
{

	IBOutlet UITextField *ratingValue;
	IBOutlet UITextField *slopeValue;
	IBOutlet UITextField *scoreValue;
	IBOutlet UILabel	*differential;
}

- (IBAction)CalculateDifferential:(UIButton *)sender;
-(IBAction)dismissRating:(id)sender;
-(IBAction)dismissSlope:(id)sender;
-(IBAction)dismissScore:(id)sender;
@end
