//
//  MCAssetManager.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCAssetManager : NSObject {
	NSMutableArray *_assets;
}

+ (MCAssetManager *)sharedManager;

@end
