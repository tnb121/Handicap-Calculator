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
#import "KeyboardController.h"



@interface HandicapViewController: UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong,nonatomic)IBOutlet UITextField *ratingValue;
@property (strong,nonatomic)IBOutlet UITextField *slopeValue;
@property (strong,nonatomic)IBOutlet UITextField *scoreValue;
@property (strong,nonatomic)IBOutlet UITextField *dateValue;
@property (strong,nonatomic)IBOutlet UITextField *courseNameValue;
@property (strong,nonatomic)IBOutlet UITextField * teeValue;


-(IBAction)CalculateDifferentialAction:(UIButton *)sender;
-(IBAction)dismissKeyboard:(id)sender;
-(IBAction)showTeePicker:(id)sender;



-(NSArray*)recordsInTable:(NSString*)tableName andManageObjectContext:(NSManagedObjectContext *)manageObjContext;

@property (nonatomic,strong) NSString *mymessage;
@property (nonatomic, retain) NSMutableArray *teeColors;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
