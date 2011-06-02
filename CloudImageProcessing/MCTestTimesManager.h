//
//  MCTestTimesManager.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCAsyncTestTimes;
@interface MCTestTimesManager : NSObject {
@private
	NSMutableDictionary *times;
}

+ (MCTestTimesManager *)sharedManager;
- (MCAsyncTestTimes *)timesForID:(NSString *)timesID;
- (void)addTimes:(MCAsyncTestTimes *)newTimes;

@end
