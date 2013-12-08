//
//  HomeScreenTableViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/5/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "HomeScreenTableViewController.h"
#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

#import "RoundCell.h"
#import "EditRoundViewController.h"
#import "ParseData.h"

@interface HomeScreenTableViewController()

@property (strong,nonatomic) NSArray * roundArray;

@end


@implementation HomeScreenTableViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table

        // The className to query on
        self.parseClassName = @"Rounds";

        // The key of the PFObject to display in the label of the default cell style
        //self.textKey = @"text";

        // The title for this table in the Navigation Controller.
        //self.title = @"Todos";

        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;

        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;

        // The number of objects to show per page
        self.objectsPerPage = 200;
    }
    return self;
}
*/

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHomeTable) name:@"ParseRoundsCommunicationComplete" object:nil];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


-(void)reloadHomeTable
{
	[self.tableView reloadData];
}


#pragma mark - PFQueryTableViewController




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(![PFUser currentUser]) return 0;

	else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (![PFUser currentUser])return 0;

	else
	{
		int test =[[[ParseData sharedParseData]roundsFromParse] count];
	return test;;
	}
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.

/*
- (PFQuery *)queryForTable
{

	if (![PFUser currentUser])return nil;

	PFQuery *roundQuery = [PFQuery queryWithClassName:@"Rounds"];
	[roundQuery whereKey:@"roundUser" equalTo:[PFUser currentUser].username];


    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0)
	{
        roundQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

 // If Pull To Refresh is enabled, query against the network by default.
 //if (self.pullToRefreshEnabled)
 //{
 //	roundQuery.cachePolicy = kPFCachePolicyNetworkOnly;
 //}

 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.

 [roundQuery orderByDescending:@"roundDate"];

 return roundQuery;
 }

*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	//RoundCell *cell = (RoundCell * )[self.tableView dequeueReusableCellWithIdentifier:@"RoundCell" forIndexPath:indexPath];

    RoundCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RoundCell"];

	if (cell==nil)
	{
        cell = [[RoundCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoundCell"];

    }

	// get string values from Parse
	_roundArray = [[ParseData sharedParseData]roundsFromParse];

	PFObject * roundObject = [_roundArray objectAtIndex:indexPath.row];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd-yyyy"];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	[formatter setDateFormat:@"MM/dd/yy"];

	 // get string values from Parse
	 NSString * teeString =[roundObject objectForKey:@"roundTee"];
	 NSString* courseString = [roundObject objectForKey:@"roundCourse"];
	 	 NSString * courseString2 = [[courseString stringByAppendingString:@" - "]stringByAppendingString:teeString];
	 NSString * dateString = [formatter stringFromDate:[roundObject objectForKey:@"roundDate"]];

	NSNumber * scoreNumber = [roundObject objectForKey:@"roundScore"];
	NSString * scoreString = [NSString stringWithFormat:@"%@",scoreNumber];

	NSNumber * differentialNumber = [roundObject objectForKey:@"roundDifferential"];
	NSString *differentialString = [NSString stringWithFormat:@"%@",differentialNumber];

	cell.courseNameCell.text = courseString2;
	cell.dateCell.text = dateString;
	cell.scoreCell.text= scoreString;
	cell.differentialCell.text=differentialString;
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

	if ([[segue identifier] isEqualToString:@"EditRoundSegue"])
	{

		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		EditRoundViewController *editVC = segue.destinationViewController;
		PFObject *object = [_roundArray objectAtIndex:indexPath.row];
		editVC.roundToEdit = object;
	}

	NSLog(@"Unknown segue: %@", [segue identifier]);
}


@end
