//
//  GroupCourseHandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Handicap.h"
#import "KeyboardController.h"

@interface GroupCourseHandicapViewController : UIViewController<KeyboardControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@property (strong, nonatomic) IBOutlet UITextField *player2HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player3HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player4HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *groupCourseSlope;

@property (strong, nonatomic) IBOutlet UILabel *myHandicapLabel;
@property (strong, nonatomic) IBOutlet UILabel *myCourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player2CourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player3CourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player4CourseHandicap;

@property (strong, nonatomic) IBOutlet UILabel *strokesToGiveMy;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive2;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive3;
@property (strong, nonatomic) IBOutlet UILabel *strokesToGive4;


@property (strong,nonatomic) Handicap * hCapClass;

@end
