//
//  UPNSpeakerListModel.h
//  Up Next
//
//  Created by Jason Lotito on 8/2/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^StorageHandler)(NSMutableArray* list);

@interface UPNSpeakerListModel : NSObject

@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) StorageHandler storageHandler;

+(instancetype)sharedInstance;

-(id)initWithEmptySpeakerList;
-(NSString *)speakerNameAtIndex: (NSUInteger)index;
-(NSUInteger)addSpeaker:(NSString *)speakerName;
-(void)save;

@end
