//
//  CourseTableViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/9/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseTableViewController.h"
#import <UIKit/UIKit.h>

#import "CourseCell.h"

@interface CourseTableViewController ()

@property (strong,nonatomic) Handicap * hCapClass;

@end

@implementation CourseTableViewController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad
{
    [super objectsWillLoad];

    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];

    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int fetchCount = [self.objects count];
	return fetchCount;
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable
{
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

	return roundQuery;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{

	CourseCell *cell = (CourseCell * )[self.tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];

	// get string values from Parse
	NSString * teeString =[object objectForKey:@"roundTee"];
	NSString* courseString = [object objectForKey:@"roundCourse"];
	NSString * courseString2 = [[courseString stringByAppendingString:@" - "]stringByAppendingString:teeString];

	NSNumber * SlopeNumber = [object objectForKey:@"roundSlope"];
	NSString * slopeString = [NSString stringWithFormat:@"%@",SlopeNumber];

	NSNumber * ratingNumber = [object objectForKey:@"roundRating"];
	NSString * ratingString = [NSString stringWithFormat:@"%@",ratingNumber];

	double handicap = [self.hCapClass handicapCalculation];
	double roundSlope = [[object objectForKey:@"roundSlope"]doubleValue];


	//double courseHCap = [self.hCapClass handicapCalculation] * [[object objectForKey:@"roundSlope"]integerValue]/113;

	double courseHCap = handicap * roundSlope / 113;


	if (courseHCap < 0)

		cell.courseHCapLabel.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.1f",-(courseHCap)]];
	else
			cell.courseHCapLabel.text =[NSString stringWithFormat:@"%.1f",courseHCap];


	cell.courseNameLabel.text = courseString2;
	cell.CourseSlopeLabel.text = slopeString;
	cell.courseRatingLabel.text = ratingString;

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
