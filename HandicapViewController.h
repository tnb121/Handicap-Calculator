//
//  HandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HandicapMainControllerViewController.h"
#import "Differential.h"
#import "Rounds.h"
#import "HandicapAppDelegate.h"


@class HandicapViewController;

@protocol HandicapViewControllerDelegate <NSObject>
- (void)HandicapViewControllerDidCancel:
(HandicapViewController *)controller;
@end

@interface HandicapViewController

@property (nonatomic, weak) id <HandicapViewControllerDelegate> delegate;

@property (strong,nonatomic)IBOutlet UITextField *ratingValue;
@property (strong,nonatomic)IBOutlet UITextField *slopeValue;
@property (strong,nonatomic)IBOutlet UITextField *scoreValue;
@property (strong,nonatomic)IBOutlet UILabel	*differential;
@property (strong,nonatomic)IBOutlet UITextField *dateValue;
@property (strong,nonatomic)IBOutlet UILabel *courseNameValue;


-(IBAction)CalculateDifferentialAction:(UIButton *)sender;
-(IBAction)dismissKeyboard:(id)sender;
-(IBAction)CancelAddRound:(id)sender;

@property (nonatomic,strong)NSString *mymessage;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end
