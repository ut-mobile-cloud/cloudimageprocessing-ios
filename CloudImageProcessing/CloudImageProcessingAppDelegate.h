//
//  CloudImageProcessingAppDelegate.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudImageProcessingAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
	UINavigationController *_navigationController;
}
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
