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

@synthesize hCapClass=_hCapClass;



-(Handicap*)hCapClass
{
	if(!_hCapClass)_hCapClass = [[Handicap alloc] init];
	return _hCapClass;

}

/*
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


	return array;
}

 */



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
	[super viewWillAppear:animated];

}


@end
