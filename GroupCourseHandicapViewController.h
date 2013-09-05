//
//  GroupCourseHandicapViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/2/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Handicap.h"

@interface GroupCourseHandicapViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *player2HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player3HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *player4HandicapValue;
@property (strong, nonatomic) IBOutlet UITextField *groupCourseSlope;

@property (strong, nonatomic) IBOutlet UILabel *myCourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player2CourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player3CourseHandicap;
@property (strong, nonatomic) IBOutlet UILabel *player4CourseHandicap;



@property (strong,nonatomic) Handicap * hCapClass;

@end
