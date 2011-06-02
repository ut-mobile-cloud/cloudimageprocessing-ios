//
//  MCTestTimesManager.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCTestTimesManager.h"
#import "MCAsyncTestTimes.h"

@implementation MCTestTimesManager

+ (MCTestTimesManager *)sharedManager
{
	static MCTestTimesManager *instance = nil;
	if (instance == nil) {
		instance = [[MCTestTimesManager alloc] init];
	}
	return instance;
}


- (MCAsyncTestTimes *)timesForID:(NSString *)timesID
{
	return [times objectForKey:timesID];
}

- (void)addTimes:(MCAsyncTestTimes *)newTimes
{
	if (newTimes != nil && newTimes.testID != nil) {
		[times setObject:newTimes forKey:newTimes.testID];
	}
}

- (id)init
{
    self = [super init];
    if (self) {
        times = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[times release];
    [super dealloc];
}

@end
