//
//  EditRoundViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/8/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "Differential.h"
#import "HandicapAppDelegate.h"
#import "KeyboardController.h"

@interface EditRoundViewController : UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong,nonatomic) PFObject * roundToEdit;

@property bool cameFromInfo;

@end
