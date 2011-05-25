//
//  MCVideoDetailsController.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCVideoResource;
@class MPMoviePlayerController;

@interface MCVideoDetailsController : UIViewController {
    MCVideoResource *videoResource;
	UILabel *titleLabel;
	UILabel *sizeLabel;
	UILabel *durationLabel;
	MPMoviePlayerController *moviePlayer;
	UIView *moviePlayerView;
}

@property (nonatomic, retain) MCVideoResource *videoResource;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) IBOutlet UIView *moviePlayerView;

- (IBAction)processPressed:(id)sender;
@end
