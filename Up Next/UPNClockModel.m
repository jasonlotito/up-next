//
//  UPNClockModel.m
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNClockModel.h"
#import "UPNAlarmModel.h"



@interface UPNClockModel ()
@property (assign, nonatomic) UPNMinute originalMinutes;
@property (assign, nonatomic) UPNSecond originalSeconds;
@property (assign, nonatomic) UPNMinute minutes;
@property (assign, nonatomic) UPNSecond seconds;
@property (assign, nonatomic) UPNMinute alarmMinutes;
@property (assign, nonatomic) UPNSecond alarmSeconds;
@property (strong, nonatomic) ClockAlarm alarm;
@property (strong, nonatomic) UPNAlarmModel *alarmModel;
@property (assign, nonatomic) BOOL alarmSounded;
@end

@implementation UPNClockModel

-(id)initWithMinutes:(UPNMinute)minutes seconds:(UPNSecond)seconds
{
    if(self = [super init]) {
        _minutes = minutes;
        _seconds = seconds;
        _originalMinutes = minutes;
        _originalSeconds = seconds;
        _alarmSounded = NO;
    }
    
    return self;
}

-(NSString *)remainingTime
{
    return [NSString stringWithFormat:@"%d:%.2d", self.minutes, self.seconds];
}

-(NSString *)minutesAsString
{
    return [NSString stringWithFormat:@"%d", self.minutes];
}

-(NSString *)secondsAsString
{
    return [NSString stringWithFormat:@"%.2d", self.seconds];
}

-(NSString *)originalMinutesAsString
{
    return [NSString stringWithFormat:@"%d", self.originalMinutes];
}

-(NSString *)originalSecondsAsString
{
    return [NSString stringWithFormat:@"%.2d", self.originalSeconds];
}

-(void)decrementBySeconds:(UPNSecond)seconds
{
    if(self.seconds < seconds) {
        self.minutes = (self.minutes + (MINUTES_IN_A_HOUR - 1)) % MINUTES_IN_A_HOUR;
    }
    
    self.seconds = (self.seconds + (SECONDS_IN_A_MINUTE - seconds)) % SECONDS_IN_A_MINUTE;
    [self soundAlarmIfNeeded];
}

-(void)decrementByMinutes:(UPNMinute)minutes
{
    self.minutes = (self.minutes + (MINUTES_IN_A_HOUR - minutes)) % MINUTES_IN_A_HOUR;
    [self soundAlarmIfNeeded];
}

-(void)decrementByMinutes:(UPNMinute)minutes decrementBySeconds:(UPNSecond)seconds
{
    [self decrementByMinutes:minutes];
    [self decrementBySeconds:seconds];
}

-(void)reset
{
    self.seconds = self.originalSeconds;
    self.minutes = self.originalMinutes;
    self.alarmSounded = NO;
}

-(void)atMinutes:(UPNMinute)minutes seconds:(UPNSecond)seconds soundAlarm:(ClockAlarm)alarm
{
    self.alarm = alarm;
    self.alarmMinutes = minutes;
    self.alarmSeconds = seconds;
}

-(void)atAlarm:(UPNAlarmModel*)alarm soundAlarm:(ClockAlarm)clockAlarm
{
    if ([alarm soundAlarmForMinutes:self.minutes seconds:self.seconds]){
        clockAlarm();
    }
}

- (BOOL)alarmShouldBeSounded
{
    return ! self.alarmSounded && (self.minutes < self.alarmMinutes || [self timeIsOnOrPassedMinutes:self.alarmMinutes seconds:self.alarmSeconds]);
}

- (BOOL)timeIsOnOrPassedMinutes:(UPNMinute)minutes seconds:(UPNSecond)seconds
{
    return (minutes == self.minutes && self.seconds <= seconds);
}

-(void)soundAlarmIfNeeded
{
    if([self alarmShouldBeSounded]){
        [self soundAlarm];
    }
    
    if([self timeIsOnOrPassedMinutes:0 seconds:0]){
        [self soundClockFinished];
    }
}

-(void)soundAlarm
{
    if(self.alarm){
        self.alarmSounded = YES;
        self.alarm();
    }
}

-(void)soundClockFinished
{
    if(self.clockFinished){
        self.clockFinished();
    }
}

-(float)remainingTimeInSeconds
{
    return ((self.minutes * SECONDS_IN_A_MINUTE) + self.seconds);
}

-(float)originalTimeInSeconds
{
    // Should really cache this, as it doesn't change often
    return ((self.originalMinutes * SECONDS_IN_A_MINUTE) + self.originalSeconds);
}

-(float)progress
{
    return 1 - ( [self remainingTimeInSeconds] / [self originalTimeInSeconds] );
}

@end
