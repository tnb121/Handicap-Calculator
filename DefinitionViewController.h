//
//  DefinitionViewController.h
//  Handicap Calculator
//
//  Created by Todd Bohannon on 9/7/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefinitionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *definitionItem;
@property (strong, nonatomic) IBOutlet UITextView *definitionDetail;

@property (strong,nonatomic) NSString* definitionItemText;
@property (strong,nonatomic)NSString* definitionDetalText;

@end
