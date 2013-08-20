//
//  UPNAlarmModel.h
//  Up Next
//
//  Created by Jason Lotito on 8/18/13.
//  Copyright (c) 2013 Jason Lotito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPNAlarmModel : NSObject

-(id)initWithMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
-(BOOL)soundAlarmForMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;
@end
