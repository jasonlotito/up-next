//
//  UPNSpeakerListModel.m
//  Up Next
//
//  Created by Jason Lotito on 8/2/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import "UPNSpeakerListModel.h"

#define SPEAKER_LIST_DEFAULTS @"speakerListDefaults"

@interface UPNSpeakerListModel ()
@property (strong, nonatomic) NSMutableArray *speakerList;
@property (assign, nonatomic) NSUInteger pointer;
@end

@implementation UPNSpeakerListModel

+(instancetype)sharedInstance
{
    static UPNSpeakerListModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[UPNSpeakerListModel alloc]init];
    });
    
    return model;
}

-(NSMutableArray*)speakerList
{
    if( ! _speakerList){
        _speakerList = [[[NSUserDefaults standardUserDefaults]arrayForKey:SPEAKER_LIST_DEFAULTS] mutableCopy];
    }
    
    if( ! _speakerList){
        _speakerList = [@[]mutableCopy];
    }
    
    return _speakerList;
}

-(id)initWithEmptySpeakerList
{
    _speakerList = [@[] mutableCopy];
    return [self init];
}

-(id)init
{
    if(self = [super init]){
        if ( ! _speakerList) {
            _speakerList = [[[NSUserDefaults standardUserDefaults]arrayForKey:SPEAKER_LIST_DEFAULTS] mutableCopy];
            
            if( ! _speakerList){
                _speakerList = [@[]mutableCopy];
            }
        }
        
        _pointer = 0;
        _count = _speakerList.count;
    }

    return self;
}

-(id)initWithStorageHandler:(StorageHandler)storageHandler
{
    _storageHandler = storageHandler;
    return [self init];
}

-(NSUInteger)addSpeaker:(NSString *)speakerName
{
    [self.speakerList insertObject:speakerName atIndex:[self.speakerList count]];
    self.count = self.speakerList.count;
    [self save];
    return self.count - 1;
}

-(void)addSpeaker:(NSString *)speakerName atIndex:(NSUInteger)index
{
    [self.speakerList insertObject:speakerName atIndex:index];
    self.count = self.speakerList.count;
}

-(void)removeSpeakerAtIndex:(NSUInteger)index
{
    [self.speakerList removeObjectAtIndex:index];
    self.count = self.speakerList.count;
}

-(void)save
{
    self.count = self.speakerList.count;
    [[NSUserDefaults standardUserDefaults] setObject:self.speakerList forKey:SPEAKER_LIST_DEFAULTS];
}

-(id)speakerNameAtIndex: (NSUInteger)index
{
    return self.speakerList[index];
}

-(void)resetPointer
{
    self.pointer = 0;
}

-(NSString *)nextSpeaker
{
    if(self.speakerList.count == 0){
        return @"add speaker names";
    }
    
    if(self.speakerList.count <= self.pointer ) {
        self.pointer = 0;
    }
    
    return self.speakerList[self.pointer++];
}

@end
