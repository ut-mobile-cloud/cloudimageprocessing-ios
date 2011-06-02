//
//  MCAppSettings.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCAppSettings.h"

static NSString *MCServerAddress = @"192.168.1.69";
static NSString *MCServerPort = @"8084";
static NSString *MCServletContextPath = @"cloudimageprocessing-server";

@implementation MCAppSettings

+ (MCAppSettings *)sharedSettings
{
	static MCAppSettings *instance = nil;
	if (instance == nil) {
		instance = [[MCAppSettings alloc] init];
	}
	return instance;
}

- (NSURL *)urlForServletName:(NSString *)servletName
{
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/%@/%@", MCServerAddress, MCServerPort, MCServletContextPath, servletName];
	return [NSURL URLWithString:urlString];
}

@end
