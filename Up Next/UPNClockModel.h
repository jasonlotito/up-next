//
//  UPNClockModel.h
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECONDS_IN_A_MINUTE 60
#define MINUTES_IN_A_HOUR 60

typedef void(^ClockAlarm)();
typedef void(^ClockFinished)();
typedef unsigned int UPNMinute;
typedef unsigned int UPNSecond;

@interface UPNClockModel : NSObject

@property (strong, nonatomic) ClockFinished clockFinished;

-(NSString *)remainingTime;
-(id)initWithMinutes:(UPNMinute)minutes seconds:(UPNSecond)seconds;
-(void)decrementBySeconds:(UPNSecond)seconds;
-(void)decrementByMinutes:(UPNMinute)minutes;
-(void)decrementByMinutes:(UPNMinute)minutes decrementBySeconds:(UPNSecond)seconds;
-(void)reset;
-(void)atMinutes:(UPNMinute)minutes seconds:(UPNSecond)seconds soundAlarm:(ClockAlarm)alarm;
-(NSString *)minutesAsString;
-(NSString *)secondsAsString;
-(NSString *)originalMinutesAsString;
-(NSString *)originalSecondsAsString;
-(float)progress;

@end
