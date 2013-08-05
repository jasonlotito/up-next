//
//  UPNAddSpeakerViewController.m
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNAddSpeakerViewController.h"

@interface UPNAddSpeakerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *presenterName;
@end

@implementation UPNAddSpeakerViewController


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
    [self.presenterName becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)nameEnteredIsValid {
    return self.presenterName.text.length > 0;
}

- (void)handleSave {
    if ([self nameEnteredIsValid] && self.saveHandler) {
        self.saveHandler(self.presenterName.text);
    }
}

- (void)handleCancel {
    if(self.cancelHandler){
        self.cancelHandler();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self handleSave];
    
    return YES;
}

- (IBAction)savePresenter:(UIBarButtonItem *)sender {
    [self handleSave];
}

- (IBAction)cancelAddition:(UIBarButtonItem *)sender {
    [self handleCancel];
}

@end
