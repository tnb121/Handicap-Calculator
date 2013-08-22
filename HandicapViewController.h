//
//  HandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Differential.h"
#import "Rounds.h"
#import "HandicapAppDelegate.h"



@interface HandicapViewController: UIViewController


@property (strong,nonatomic)IBOutlet UITextField *ratingValue;
@property (strong,nonatomic)IBOutlet UITextField *slopeValue;
@property (strong,nonatomic)IBOutlet UITextField *scoreValue;
@property (strong,nonatomic)IBOutlet UITextField *dateValue;
@property (strong,nonatomic)IBOutlet UITextField *courseNameValue;
@property (strong,nonatomic)IBOutlet UILabel *differential;


-(IBAction)CalculateDifferentialAction:(UIButton *)sender;
-(IBAction)dismissKeyboard:(id)sender;


-(NSArray*)recordsInTable:(NSString*)tableName andManageObjectContext:(NSManagedObjectContext *)manageObjContext;

@property (nonatomic,strong) NSString *mymessage;
@property  double temp;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
