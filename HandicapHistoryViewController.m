//
//  HandicapHistory.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/25/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HandicapHistoryViewController.h"
#import "HandicapAppDelegate.h"

@interface HandicapHistoryViewController ()

@end

@implementation HandicapHistoryViewController

@synthesize handicapHistoryTableView;
@synthesize HcapHistoryCellClass=_HcapHistoryCellClass;
@synthesize hCapClass=_hCapClass;


@synthesize HistoryfetchedResultsController=_HistoryfetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;

-(HandicapHistoryCell*)HcapHistoryCellClass
{
	if(!_HcapHistoryCellClass) _HcapHistoryCellClass = [[HandicapHistoryCell alloc] init];
	return _HcapHistoryCellClass;
}

-(Handicap*)hCapClass
{
	if(!_hCapClass)_hCapClass = [[Handicap alloc] init];
	return _hCapClass;

}

- (NSFetchedResultsController *)fetchedResultsController
{
	HandicapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = [appDelegate managedObjectContext];
	self.managedObjectContext=context;

	if (_HistoryfetchedResultsController != nil)
	{
        return _HistoryfetchedResultsController;
    }
	
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [NSEntityDescription entityForName:@"HandicapHistory" inManagedObjectContext:self.managedObjectContext];

	// Set the sort descriptor
	NSSortDescriptor *  date = [[NSSortDescriptor alloc] initWithKey: @"historyDate"
														   ascending: NO];
    NSArray *           sortDescriptors = [NSArray arrayWithObjects: date, nil];
    fetchRequest.sortDescriptors = sortDescriptors;



    // Initialize fetched results controller - creates cache
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest: fetchRequest
                                                             managedObjectContext: self.managedObjectContext
                                                             sectionNameKeyPath: nil
                                                             cacheName: nil];
    aFetchedResultsController.delegate = self;
    self.HistoryfetchedResultsController = aFetchedResultsController;

	// handle errors
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
	NSLog(@"fetched: %@",_HistoryfetchedResultsController);
    return _HistoryfetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// set up and intialize TableView Cell
	static NSString *CellIdentifier = @"HistoryCell";
	UITableViewCell *   cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];

	if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


	// fetch results for Rounds
	HandicapHistory * history =(HandicapHistory *) [self.fetchedResultsController objectAtIndexPath:indexPath];

	UILabel *historyDateLabel = (UILabel *)[cell.contentView viewWithTag:310];
	NSDate * historyDate = history.historyDate;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[dateFormatter setDateFormat:@"MM/dd/yy"];
	NSString *dateString = [dateFormatter stringFromDate:historyDate];
	[historyDateLabel setText:dateString];


	UILabel *historyHCapLabel = (UILabel *)[cell.contentView viewWithTag:320];
	NSString * historyHCapString = [NSString stringWithFormat:@"%.1f",[history.historyHCap doubleValue]];
    [historyHCapLabel setText:historyHCapString];


	UILabel *historyScoringAverageLabel = (UILabel *)[cell.contentView viewWithTag:330];
	NSString * historyScoringAverageString = [NSString stringWithFormat:@"%.1f",[history.historyScoringAverage doubleValue]];
    [historyScoringAverageLabel setText:historyScoringAverageString];


	UILabel *historyRoundCountLabel = (UILabel *)[cell.contentView viewWithTag:340];
	NSString * historyRoundCountString = [NSString stringWithFormat:@"%ld",(long)[history.historyRoundCount integerValue]];
    [historyRoundCountLabel setText:historyRoundCountString];

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int fetchCount=[self.fetchedResultsController.fetchedObjects count];
	return fetchCount;
}
-(NSMutableArray*) fetchHistoryResults
{
	if (_managedObjectContext == nil)
	{
		_managedObjectContext = [(HandicapAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	}

	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"HandicapHistory" inManagedObjectContext:moc];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor *sortbyDate=[NSSortDescriptor sortDescriptorWithKey:@"historyDate" ascending:YES];
	NSArray *sortDescriptors = @[sortbyDate];
	[request setEntity:entityDescription];
	[request setSortDescriptors:sortDescriptors];

	NSError *error;

	NSMutableArray *array = [[moc executeFetchRequest:request error:&error]mutableCopy];
	if (array == nil)
	{
		// Deal with error...
	}

	NSLog(@"array: %@",array);

	return array;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	self.HistoryfetchedResultsController = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
	[handicapHistoryTableView reloadData];
	[super viewWillAppear:animated];

}

@end
