//
//  MCVideoDetailsController.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MCVideoDetailsController.h"
#import "MCResourceManager.h"
#import "MCVideoResource.h"

@implementation MCVideoDetailsController

@synthesize videoResource;
@synthesize titleLabel;
@synthesize sizeLabel;
@synthesize durationLabel;
@synthesize moviePlayer;
@synthesize moviePlayerView;

- (IBAction)processPressed:(id)sender
{
	[[MCResourceManager sharedManager] requestProcessingResource:self.videoResource];
}

- (void)processingStartedNotification:(NSDictionary *)userInfo
{
	DLog(@"Details controller processing started : %@", userInfo);
}

- (void)processingCompleteNotification:(NSDictionary *)userInfo
{
	DLog(@"Details controller processing complete : %@", userInfo);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		moviePlayer = [[MPMoviePlayerController alloc] init];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.titleLabel.text = self.videoResource.title;
	self.sizeLabel.text = [NSString stringWithFormat:@"%.3f MB", [self.videoResource.size floatValue]/1048576];
	self.durationLabel.text = [NSString stringWithFormat:@"%@ sec", self.videoResource.duration];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// TODO: this should actually be initialized from self.videoResource.location
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processingStartedNotification:) name:MCResourceProcessingStartedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processingCompleteNotification:) name:MCResourceProcessingCompleteNotification object:nil];
	NSURL *mediaURL = [NSURL URLWithString:@"http://www.ut.ee/~mnomme/video/sample_iPod.m4v"];
	[self.moviePlayer.view setFrame:self.moviePlayerView.bounds];
	[self.moviePlayerView addSubview:self.moviePlayer.view];
    [self.moviePlayer setContentURL:mediaURL];
	[self.moviePlayer play];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setTitleLabel:nil];
	[self setSizeLabel:nil];
	[self setDurationLabel:nil];
	[self setMoviePlayerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
	[moviePlayer stop];
	[moviePlayer release];
	[videoResource release];
	[titleLabel release];
	[sizeLabel release];
	[durationLabel release];
	[moviePlayerView release];
	[super dealloc];
}
@end
