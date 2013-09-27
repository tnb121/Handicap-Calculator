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
@synthesize historyClass=_historyClass;

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize managedObjectContext=_managedObjectContext;

-(HandicapHistory*)historyClass
{
	if(!_historyClass) _historyClass = [[HandicapHistory alloc] init];
	return _historyClass;
}

- (NSFetchedResultsController *)fetchedResultsController
{
	HandicapAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext* context = [appDelegate managedObjectContext];
	self.managedObjectContext=context;

	if (_fetchedResultsController != nil)
	{
        return _fetchedResultsController;
    }

    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    fetchRequest.entity = [NSEntityDescription entityForName:@"HandicapHistory" inManagedObjectContext:self.managedObjectContext];

	[fetchRequest setReturnsDistinctResults:NO];

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
    self.fetchedResultsController = aFetchedResultsController;

	// handle errors
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {

	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
	NSLog(@"fetched: %@",_fetchedResultsController);
    return _fetchedResultsController;
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
	NSString * historyHCapString = [NSString stringWithFormat:@"%@",history.historyHCap];
    [historyHCapLabel setText:historyHCapString];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int c =[self.fetchedResultsController.fetchedObjects count];
	return c;
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
	self.handicapHistoryTableView.delegate=self;
	self.handicapHistoryTableView.dataSource=self;
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
	[super viewWillAppear:animated];
	[self.handicapHistoryTableView reloadData];

}

@end
