//
//  UPNAlarmModelTest.m
//  Up Next
//
//  Created by Jason Lotito on 8/18/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UPNAlarmModel.h"

@interface UPNAlarmModelTest : SenTestCase

@end

@implementation UPNAlarmModelTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCanSetupAlarm
{
    UPNAlarmModel *alarm = [[UPNAlarmModel alloc]initWithMinutes:0 seconds:30];
    STAssertTrue([[alarm description] isEqualToString:@"0:30"], @"%@", [alarm description]);
}

- (void)testCanSetupAnotherAlarm
{
    UPNAlarmModel *alarm = [[UPNAlarmModel alloc]initWithMinutes:5 seconds:0];
    STAssertTrue([[alarm description] isEqualToString:@"5:00"], @"%@", [alarm description]);
}

- (void)testKnowsWhenAlarmIsSounded
{
    UPNAlarmModel *alarm = [[UPNAlarmModel alloc]initWithMinutes:1 seconds:0];
    STAssertTrue([alarm soundAlarmForMinutes:1 seconds:0], @"Alarm should sound");
    STAssertTrue([alarm soundAlarmForMinutes:0 seconds:59], @"Alarm should sound");
    STAssertTrue([alarm soundAlarmForMinutes:0 seconds:29], @"Alarm should sound");
}

- (void)testKnowsWhenAlarmIsNotSounded
{
    UPNAlarmModel *alarm = [[UPNAlarmModel alloc]initWithMinutes:1 seconds:0];
    STAssertFalse([alarm soundAlarmForMinutes:1 seconds:1], @"Alarm should sound");
    STAssertFalse([alarm soundAlarmForMinutes:1 seconds:59], @"Alarm should sound");
    STAssertFalse([alarm soundAlarmForMinutes:1 seconds:29], @"Alarm should sound");
}

- (void)testAlarmTestShouldErrorWithLargeSeconds
{
    BOOL exceptionCaught = NO;
    UPNAlarmModel *alarm = [[UPNAlarmModel alloc]initWithMinutes:1 seconds:5];
    
    @try {
        [alarm soundAlarmForMinutes:0 seconds:61];
    }
    @catch (NSException *exception) {
        exceptionCaught = YES;
    }
    @finally {
        STAssertTrue(exceptionCaught, @"Exception caught");
    }


}

@end
