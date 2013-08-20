//
//  UPNTimeUpdateViewController.m
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNTimeUpdateViewController.h"

@interface UPNTimeUpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *minutesInput;
@property (weak, nonatomic) IBOutlet UITextField *secondsInput;
@property (weak, nonatomic) IBOutlet UIStepper *minutesStepper;
@property (weak, nonatomic) IBOutlet UIStepper *secondsStepper;
@property (strong, nonatomic) NSString *defaultMinutes;
@property (strong, nonatomic) NSString *defaultSeconds;

@end

@implementation UPNTimeUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)save:(UIBarButtonItem *)sender {
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)valueChangeMinuteStepper:(UIStepper *)sender {
    [self setMinutesField:sender.value];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *charSet = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    NSRange rangeOfBadChars = [string rangeOfCharacterFromSet:charSet];
    if(rangeOfBadChars.length == 0){
        return YES;
    }
    
    return NO;
}

- (void)setSecondField:(double)value {
    self.seconds.text = [NSString stringWithFormat:@"%.0f", value];
}

- (void)setMinutesField:(double)value {
    self.minutes.text = [NSString stringWithFormat:@"%.0f", value];
}

- (IBAction)valueChangeSecondStepper:(UIStepper *)sender {
    [self setSecondField:sender.value];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.minutesInput == textField) {
        self.minutesStepper.value = 1;
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setMinutesField:1];
        });
    } else {
        self.secondsStepper.value = 0;
        double delayInSeconds = 0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setSecondField:0];
        });
    }
    
    return YES;
}

-(void)setDefaultMinutes:(NSString *)minutes seconds:(NSString *)seconds
{
    self.defaultMinutes = minutes;
    self.defaultSeconds = seconds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.minutes.text = self.defaultMinutes;
    self.seconds.text = self.defaultSeconds;
    [self.minutes becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
