//
//  CourseCell.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/15/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *CourseSlopeLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseHCapLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseRatingLabel;

@end
