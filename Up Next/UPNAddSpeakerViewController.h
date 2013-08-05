//
//  UPNAddSpeakerViewController.h
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

typedef void(^SaveHandler)(NSString *username);
typedef void(^CancelHandler)();

#import <UIKit/UIKit.h>

@interface UPNAddSpeakerViewController : UIViewController
@property (strong, nonatomic) SaveHandler saveHandler;
@property (strong, nonatomic) CancelHandler cancelHandler;
@end
