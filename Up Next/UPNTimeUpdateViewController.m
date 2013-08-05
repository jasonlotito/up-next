//
//  UPNTimeUpdateViewController.m
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNTimeUpdateViewController.h"

@interface UPNTimeUpdateViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
