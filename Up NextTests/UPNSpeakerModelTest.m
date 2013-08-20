//
//  UPNSpeakerModelTest.m
//  Up Next
//
//  Created by Jason Lotito on 8/18/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "UPNSpeakerModel.h"

@interface UPNSpeakerModelTest : SenTestCase
@property (strong, nonatomic) UPNSpeakerModel *model;
@end

@implementation UPNSpeakerModelTest

- (void)setUp
{
    [super setUp];
    self.model = [[UPNSpeakerModel alloc]init];
}

- (void)tearDown
{
    self.model = nil;
    [super tearDown];
}

- (void)testCanCreateSpeaker
{
    self.model.name = @"Jason";
    STAssertEquals(self.model.name, @"Jason", @"Name Jason should equal %@", self.model.name);
}

- (void)testCanAssignNotesForSpeaker
{
    NSString *notes = @"These are notes for the speaker";
    self.model.name = @"Jason";
    self.model.notes = notes;
    STAssertEquals(self.model.notes, notes, @"Notes should equal %@", notes);
}

- (void)testCanAssignSpeakerTalkTitle
{
    NSString *talkTitle = @"This is a talk title";
    self.model.name = @"Jason";
    self.model.talkTitle = talkTitle;
    STAssertEquals(self.model.talkTitle, talkTitle, @"Talk title should be %@", talkTitle);
}

@end
