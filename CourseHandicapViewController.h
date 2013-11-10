//
//  CourseHandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HandicapAppDelegate.h"
#import "HomeScreenViewController.h"
#import "Handicap.h"
#import "Courses.h"
#import "Tee.h"
#import "CourseCell.h"

@interface CourseHandicapViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,KeyboardControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *courseContainer;

@property (strong, nonatomic) IBOutlet UIView *courseTable;
@property (strong, nonatomic) IBOutlet UITextField *courseHandicapSlopeValue;
@property (strong, nonatomic) IBOutlet UILabel *courseHandicapMyHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseHandicapLabel;
@property (strong, nonatomic) IBOutlet UIButton *courseHandicapCalculateButton;

@property (strong,nonatomic) Handicap * hCapClass;
@property (strong,nonatomic) Courses * coursesClass;
@property (strong,nonatomic) Tee *tees;

@property (strong, nonatomic) NSFetchedResultsController *CoursefetchedResultsController;
@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;

@end
