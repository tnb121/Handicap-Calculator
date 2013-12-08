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
#import "HandicapAppDelegate.h"
#import "KeyboardController.h"

@interface HandicapViewController: UIViewController<UITextFieldDelegate,KeyboardControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property BOOL cameFromInfo;

@end
