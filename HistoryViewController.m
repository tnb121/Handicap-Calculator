//
//  HistoryViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/9/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HistoryViewController.h"
#import "ParseData.h"

@interface HistoryViewController ()

@property (strong,nonatomic) Handicap * hCapClass;
@property (strong,nonatomic) NSArray * historyArray;

@end

@implementation HistoryViewController

@synthesize hCapClass=_hCapClass;


double courseSlope;


-(Handicap*)hCapClass
{
	if(!_hCapClass) _hCapClass = [[Handicap alloc] init];
	return _hCapClass;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	_historyArray = [[ParseData sharedParseData]handicapHistoryFromParse];
	[self.tableView reloadData];
};

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int fetchCount = [_historyArray count];
	return fetchCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	HandicapHistoryCell *cell = (HandicapHistoryCell * )[self.tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
	
	PFObject * historyObject = [_historyArray objectAtIndex:indexPath.row];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setDateFormat:@"MM/dd/yy"];
	//NSString *dateString = [dateFormatter stringFromDate:historyDate];

	// get string values from Parse
	NSNumber * roundCountNumber = [historyObject objectForKey:@"historyRoundCount"];
	NSString * roundCountString = [NSString stringWithFormat:@"%@",roundCountNumber];

	NSString* dateString = [formatter stringFromDate:[historyObject objectForKey:@"historyDate"]];

	NSNumber * scoringAverageNumber = [historyObject objectForKey:@"historyScoringAverage"];
	NSString * scoringAverageString = [NSString stringWithFormat:@"%.1f",[scoringAverageNumber doubleValue]];

	NSNumber * handicapNumber = [historyObject objectForKey:@"historyHandicap"];
	NSString * handicapString = [NSString stringWithFormat:@"%.1f",[handicapNumber doubleValue]];


	cell.historyCellDateLabel.text = dateString;
	cell.historyCellHandicapLabel.text = handicapString;
	cell.historyCellRoundLabel.text = roundCountString;
	cell.historyCellScoreAvgLabel.text = scoringAverageString;

	return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";

 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }

 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";

 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}
@end