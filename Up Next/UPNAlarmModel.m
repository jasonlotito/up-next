//
//  UPNAlarmModel.m
//  Up Next
//
//  Created by Jason Lotito on 8/18/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNAlarmModel.h"

@interface UPNAlarmModel()
@property (assign, nonatomic) NSUInteger minutes;
@property (assign, nonatomic) NSUInteger seconds;
@end

@implementation UPNAlarmModel

-(id)initWithMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds
{
    if (self = [super init]) {
        _minutes = minutes;
        _seconds = seconds;
    }
    
    return self;
}

-(BOOL)soundAlarmForMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds
{
    if(seconds>60){
        NSException *exception = [NSException exceptionWithName:@"InvalidArgumentExeption"
                                                         reason:@"seconds argument too large"
                                                       userInfo:nil];
        @throw exception;
    }
    
    return (self.minutes > minutes) || ((self.minutes == minutes) && (self.seconds >= seconds));
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)self.minutes, (unsigned long)self.seconds];
}

@end
