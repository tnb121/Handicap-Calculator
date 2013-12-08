//
//  HandicapAppDelegate.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 7/28/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <StoreKit/StoreKit.h>
#import "HandicapAppDelegate.h"
#import "ParseData.h"


@interface HandicapAppDelegate()

@end


@implementation HandicapAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

	UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    [tabController setSelectedIndex:0];

	[Parse setApplicationId:@"dOEY4AHocmPKtur5RU0oCyz1ygKkiG2MIG7F9tai"
				  clientKey:@"CH1nW38EnKKWZNdoOV6VnjhrLEn0egI6OLu6g7xX"];
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
	[PFFacebookUtils initializeFacebook];
	[PFTwitterUtils initializeWithConsumerKey:@"PnlxuwDRcgdmOggzeea0A"
							   consumerSecret:@"VUSzqyrtDD4bwu840jFIIRXMDqd6fyUnrswy5EAiXws"];

	[PFPurchase addObserverForProduct:@"com.mygolfinsight.mygolfhandicap.fullversionupgrade" block:^(SKPaymentTransaction *transaction)
	{
		// Write business logic that should run once this product is purchased.
		[[ParseData sharedParseData] upgradeToFullVersion];

	}];


	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


@end