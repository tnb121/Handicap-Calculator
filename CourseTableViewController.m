//
//  CourseTableViewController.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 11/9/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "CourseTableViewController.h"
#import <UIKit/UIKit.h>
#import "ParseData.h"
#import "CourseFromParse.h"

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int fetchCount = [[ParseData sharedParseData]uniqueCourseArray].count;
	return fetchCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	CourseCell *cell = (CourseCell * )[self.tableView dequeueReusableCellWithIdentifier:@"CourseCell" forIndexPath:indexPath];

	// get string values from Parse
	NSArray * courseArray = [[ParseData sharedParseData]uniqueCourseArray];

	CourseFromParse * courseObject = [courseArray objectAtIndex:indexPath.row];

	NSString * courseName = courseObject.name;
	NSString * teeName = courseObject.tee;
	NSString * courseString2 = [[courseName stringByAppendingString:@" - "]stringByAppendingString:teeName];
	NSNumber *rating = courseObject.rating;
	NSNumber * slope = courseObject.slope;

	int courseHCap = lround([self.hCapClass handicapCalculation] * [slope doubleValue] / 113);

	if (courseHCap < 0)

		cell.courseHCapLabel.text = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%.1d",-(courseHCap)]];
	else
			cell.courseHCapLabel.text =[NSString stringWithFormat:@"%.1d",courseHCap];

	cell.courseNameLabel.text = courseString2;
	cell.CourseSlopeLabel.text = [NSString stringWithFormat:@"%d",[slope integerValue]];
	cell.courseRatingLabel.text = [NSString stringWithFormat:@"%.1f",[rating doubleValue]];

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
