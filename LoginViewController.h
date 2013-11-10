//
//  LoginViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 10/29/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "HandicapAppDelegate.h"
@interface LoginViewController : PFLogInViewController <PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
