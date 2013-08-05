//
//  UPNTimeUpdateViewController.h
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPNTimeUpdateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *minutes;
@property (weak, nonatomic) IBOutlet UITextField *seconds;

-(void)setDefaultMinutes:(NSString *)minutes seconds:(NSString *)seconds;

@end
