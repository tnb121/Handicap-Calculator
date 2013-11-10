//
//  HandicapHistory.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "HandicapHistory.h"
#import "HandicapHistoryCell.h"
#import "Handicap.h"

@interface HandicapHistoryViewController : UIViewController

@property (strong,nonatomic) Handicap * hCapClass;

@end
