//
//  UPNClockModelTest.m
//  Up Next
//
//  Created by Jason Lotito on 8/3/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNClockModelTest.h"
#import "UPNClockModel.h"

@implementation UPNClockModelTest
- (void)setUp
{
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testClockCreatedWithFiveMinutesLeft
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    NSLog(@"REMAINING TIME: [%@]", [model remainingTime]);
    STAssertTrue([[model remainingTime]isEqualToString:@"5:00"], @"5:00 Minutes left");
}

-
(void)testClockTimeCreatedWithTenMinutesLeft
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:10 seconds:0];
    STAssertTrue([[model remainingTime]isEqualToString:@"10:00"], @"10:00 Minutes left");
}

-(void)testClockTimeDecrementsAfterASecond
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementBySeconds:1];
    STAssertTrue([[model remainingTime] isEqualToString:@"4:59"], @"4:59 seconds left");
        NSLog(@"REMAINING TIME: [%@]", [model remainingTime]);
}

-(void)testClockTimeDecrementsAfterTenSeconds
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementBySeconds:10];
    STAssertTrue([[model remainingTime] isEqualToString:@"4:50"], @"4:50 seconds left");
        NSLog(@"REMAINING TIME: [%@]", [model remainingTime]);
}

-(void)testClockTimeDecrementsAfterOneMinuteTenSeconds
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementByMinutes:1 decrementBySeconds:10];
    STAssertTrue([[model remainingTime] isEqualToString:@"3:50"], @"3:50 seconds left");
        NSLog(@"REMAINING TIME: [%@]", [model remainingTime]);
}

-(void)testReset
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementByMinutes:1 decrementBySeconds:10];
    STAssertTrue([[model remainingTime] isEqualToString:@"3:50"], @"3:50 seconds left");
    [model reset];
    STAssertTrue([[model remainingTime] isEqualToString:@"5:00"], @"5:00 seconds left");
}

-(void)testAlarm
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model atMinutes:4 seconds:0 soundAlarm:^{
        STAssertTrue(YES, @"Alarm Sounded");
    }];
    [model decrementByMinutes:1 decrementBySeconds:10];
}

-(void)testProgress
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementBySeconds:1];
    STAssertTrue([model progress] < 0.003334, @"Progress is at %f", [model progress]);
}


-(void)testProgressAtHalfWay
{
    UPNClockModel *model = [[UPNClockModel alloc]initWithMinutes:5 seconds:0];
    [model decrementByMinutes:2 decrementBySeconds:30];
    STAssertTrue([model progress] == 0.5, @"Progress is at %f", [model progress]);
}

@end
