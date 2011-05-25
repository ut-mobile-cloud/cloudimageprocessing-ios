//
//  MCResourceManager.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *MCResourcesUpdatedNotification;
extern NSString *MCResourceProcessingStartedNotification;
extern NSString *MCResourceProcessingCompleteNotification;

@class MCVideoResource;

@interface MCResourceManager : NSObject {
	NSMutableArray *resources;
}
@property (retain, readonly) NSArray *resources;

+ (MCResourceManager *)sharedManager;
- (void)refreshResources;
- (void)requestProcessingResource:(MCVideoResource *)resource;
- (void)remoteNotificationReceived:(NSDictionary *)data;

@end
