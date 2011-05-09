//
//  MCAssetManager.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCAssetManager.h"


@implementation MCAssetManager

+ (MCAssetManager *)sharedManager
{
	static MCAssetManager *instance = nil;
	if (instance == nil) {
		instance = [[MCAssetManager alloc] init];
	}
	return instance;
}


@end
