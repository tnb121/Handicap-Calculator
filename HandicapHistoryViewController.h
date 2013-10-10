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

@interface HandicapHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *handicapHistoryTableView;

@property (strong, nonatomic) NSFetchedResultsController *HistoryfetchedResultsController;
@property (strong,nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong,nonatomic) HandicapHistoryCell * HcapHistoryCellClass;
@property (strong,nonatomic) Handicap * hCapClass;

@end
