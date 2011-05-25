//
//  MCResourceManager.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCResourceManager.h"
#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"
#import "MCVideoResource.h"
#import "JSON.h"

NSString *MCResourcesUpdatedNotification = @"MCResourcesUpdatedNotification";
NSString *MCResourceProcessingStartedNotification = @"MCResourceProcessingStartedNotification";
NSString *MCResourceProcessingCompleteNotification = @"MCResourceProcessingCompleteNotification";

static NSString *MCListResourcesServletName = @"ListResources";
static NSString *MCProcessResourceServletName = @"ProcessResource";

@implementation MCResourceManager

@synthesize resources;

+ (MCResourceManager *)sharedManager
{
	static MCResourceManager *instance = nil;
	if (instance == nil) {
		instance = [[MCResourceManager alloc] init];
	}
	return instance;
}
- (void)remoteNotificationReceived:(NSDictionary *)data
{
	DLog(@"Remote notification received");
}
- (void)refreshResourcesBlockComplete
{
	DLog(@"Block called on main queue. Refreshing resources done");
}

- (void)requesProcessingBlockComplete
{
	
}

- (void)refreshResources
{
	DLog(@"Refreshing resources");
	dispatch_queue_t queue = dispatch_queue_create("ee.ut.cs.ds.cloudImageProcessing", NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	void (^MCRefreshResourcesBlock)(void) = ^(void) {
		NSURL *servletURL = [[MCAppSettings sharedSettings] urlForServletName:MCListResourcesServletName];
		ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:servletURL];
		[request startSynchronous];
		DLog(@"Finished request");
		NSError *error = request.error;
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		DLog(@"Response status code : %d", [request responseStatusCode]);
		if (error == nil && [request responseStatusCode]==200) {
			DLog(@"Got the list of resources");
			[userInfo setObject:[NSNull null] forKey:@"error"];
			NSString *responseString = [request responseString];
			NSArray *newResourcesDicts = [responseString JSONValue];
			NSMutableArray *newVideoResources = [NSMutableArray arrayWithCapacity:0];
			for (NSDictionary *resourceDict in newResourcesDicts) {
				MCVideoResource *videoResource = [[[MCVideoResource alloc] init] autorelease];
				[videoResource setValuesForKeysWithDictionary:resourceDict];
				[newVideoResources addObject:videoResource];
			}
			// This is needed to minimize the time that resources object is being changed 
			// (in case someone uses if for example for drawing UI
			[resources removeAllObjects];
			[resources addObjectsFromArray:newVideoResources];
			
		} else {
			if (error != nil) {
				[userInfo setObject:error forKey:@"error"];
				
			} else {
				NSString *errorMessage = [NSString stringWithFormat:@"Unable to request for list or resources. Server error code : %d", [request responseStatusCode]];
				[userInfo setObject:errorMessage forKey:@"error"];
			}
			
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:MCResourcesUpdatedNotification object:self userInfo:userInfo];
		[request release];
		dispatch_sync(main, ^{
			[self refreshResourcesBlockComplete];
		});
	};
	
	dispatch_async(queue, MCRefreshResourcesBlock);
	
}

- (void)requestProcessingResource:(MCVideoResource *)resource
{
	dispatch_queue_t queue = dispatch_queue_create("ee.ut.cs.ds.cloudImageProcessing", NULL);
	dispatch_queue_t main = dispatch_get_main_queue();
	
	void (^MCRequestProcessingBlock)(void) = ^(void) {
		NSURL *servletURL = [[MCAppSettings sharedSettings] urlForServletName:MCProcessResourceServletName];
		ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:servletURL];
		NSDictionary *resourceDict = [resource dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"ID", @"title", @"size", @"duration", @"location", nil]];
		DLog(@"RESOURCE JSON TO SERVER : %@", [resourceDict JSONRepresentation]);
		[request addPostValue:[resourceDict JSONRepresentation] forKey:@"resource"];
		[request startSynchronous];
		// TODO: check server response. Maybe something went wrong and it could not start processing ?
		// Notify that processing has started
		[[NSNotificationCenter defaultCenter] postNotificationName:MCResourceProcessingStartedNotification object:self userInfo:resourceDict];
		dispatch_sync(main, ^{
		[self requesProcessingBlockComplete];
		});
	};
	
	dispatch_async(queue, MCRequestProcessingBlock);
}

- (id)init
{
	self = [super init];
	if (self) {
		resources = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[resources release];
	[super dealloc];
}
@end
