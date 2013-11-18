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
#import "CourseCell.h"

@interface CourseHandicapViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,KeyboardControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *courseHandicapSlopeValue;
@property (strong, nonatomic) IBOutlet UILabel *courseHandicapMyHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseHandicapLabel;

@property (strong,nonatomic) Handicap * hCapClass;

@end
