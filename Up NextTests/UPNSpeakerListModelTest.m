//
//  UPNSpeakerListModelTest.m
//  Up Next
//
//  Created by Jason Lotito on 8/4/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNSpeakerListModelTest.h"
#import "UPNSpeakerListModel.h"

@interface UPNSpeakerListModelTest()
@property (strong, nonatomic) UPNSpeakerListModel *model;
@end

@implementation UPNSpeakerListModelTest

-(void)setUp
{
    [super setUp];
    self.model = [[UPNSpeakerListModel alloc]initWithEmptySpeakerList];
}

-(void)tearDown
{
    [super tearDown];
    self.model = nil;
}

-(void)testCanAddSpeaker
{
    NSUInteger placement = [self.model addSpeaker:@"Jason"];
    STAssertTrue(placement == 0, @"Speaker added at place 0");
}

-(void)testCanAddTwoSpeakers
{
    [self.model addSpeaker:@"Jason"];
    STAssertTrue([self.model addSpeaker:@"Bob"] == 1, @"Speakers added into places 0 and 1");
}

-(void)testCanGetSpeakerBackFromIndex
{
    NSUInteger index = [self.model addSpeaker:@"Jason"];
    
    STAssertTrue([@"Jason" isEqualToString:[self.model speakerNameAtIndex:index]], @"Speaker name is %@", [self.model speakerNameAtIndex:index]);
}

-(void)testCanGetSpeakerBackFromIndexFromListWithManySpeakers
{
    [self.model addSpeaker:@"John"];
    [self.model addSpeaker:@"Paul"];
    NSUInteger index = [self.model addSpeaker:@"Jason"];
    [self.model addSpeaker:@"Ringo"];
    [self.model addSpeaker:@"George"];
    
    STAssertTrue([@"Jason" isEqualToString:[self.model speakerNameAtIndex:index]], @"Speaker name is %@", [self.model speakerNameAtIndex:index]);
}

@end
