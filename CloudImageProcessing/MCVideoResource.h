//
//  MCVideoResource.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCVideoResource : NSObject {
    NSString *ID;
	NSString *title;
	NSNumber *size;
	NSNumber *duration;
	NSString *location;
	
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *size;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSString *location;


@end
