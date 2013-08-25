//
//  DatePickerView.m
//  Handicap Calculator
//
//  Created by Todd Bohannon on 8/20/13.
//  Copyright (c) 2013 Todd Bohannon. All rights reserved.
//

#import "DatePickerView.h"
#import "HandicapViewController.h"

@implementation DatePickerView

@synthesize datePicker = _datePicker;
@synthesize dateText;

UITextField *_inputField;

// TARGET METHODS


-(void)pickerValueChanged:(UIDatePicker *)picker
{
	dateText = self.datePicker.date.description;

	_inputField.text = self.datePicker.date.description; // set text to date description
}
-(void)viewDoubleTapped:(UITapGestureRecognizer *)tapGR
{
    [_inputField resignFirstResponder]; // upon double-tap dismiss picker
}
-(void)textFieldBeganEditing:(NSNotification *)note
{
	_inputField = note.object; // set ivar to current first responder
}
-(void)textFieldEndedEditing:(NSNotification *)note
{
	_inputField  = nil; // the first responder ended editing CRITICAL:avoids retain cycle
}
// INITI METHODS
-(void)initializationCodeMethod{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];// All pickers have preset height
	_datePicker.datePickerMode = UIDatePickerModeDate;
	_datePicker.maximumDate=[NSDate date];
	self.bounds = _datePicker.frame; // Make our view same size as picker

    [self addSubview:_datePicker];
    [_datePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // register to be notified when the value changes
																													// As an example we'll use a tap gesture recognizer to dismiss on a double-tap
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    tapGR.numberOfTapsRequired = 2; // Limit to double-taps
    [self addGestureRecognizer:tapGR];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textFieldBeganEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil]; // Ask to be informed when any textfield begins editing
    [center addObserver:self selector:@selector(textFieldEndedEditing:) name:UITextFieldTextDidEndEditingNotification object:nil]; // Ask to be informed when any textfield ends editing
}
-(id)init{
    if ((self = [super init])){
        [self initializationCodeMethod];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])){
        [self initializationCodeMethod];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self initializationCodeMethod];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
