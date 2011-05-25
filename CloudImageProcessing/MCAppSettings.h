//
//  MCAppSettings.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCAppSettings : NSObject {
    
}

+ (MCAppSettings *)sharedSettings;
- (NSURL *)urlForServletName:(NSString *)servletName;

@end
