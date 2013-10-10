//
//  EditRoundViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/8/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Differential.h"
#import "Rounds.h"
#import "HandicapAppDelegate.h"
#import "KeyboardController.h"
#import "Rounds.h"

@interface EditRoundViewController : UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>


-(IBAction)CalculateDifferentialAction:(UIButton *)sender;
-(IBAction)dismissKeyboard:(id)sender;
-(IBAction)showTeePicker:(id)sender;

@property(strong,nonatomic) Rounds * rounds;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property bool cameFromInfo;

@property (strong, nonatomic) IBOutlet UITextField *courseNameEditRound;
@property (strong, nonatomic) IBOutlet UITextField *teeEditRound;
@property (strong, nonatomic) IBOutlet UITextField *dateEditRound;
@property (strong, nonatomic) IBOutlet UITextField *ratingEditRound;
@property (strong, nonatomic) IBOutlet UITextField *slopeEditRound;
@property (strong, nonatomic) IBOutlet UITextField *scoreEditRound;
@property (strong, nonatomic) IBOutlet UIButton *saveChangesEditRoundButton;

@end
