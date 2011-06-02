//
//  MCVideoListController.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCVideoListController.h"
#import "MCVideoListCell.h"
#import "MCVideoDetailsController.h"
#import "MCResourceManager.h"
#import "MCVideoResource.h"
#import "MCTimeSynchronizer.h"
#import "MCAsyncTestTimes.h"
#import "MCTestTimesManager.h"

#define MCVideoCellThumbnailImageViewTag 1001
#define MCVideoCellTitleLabelTag 1002
#define MCVideoCellSizeLabelTag 1003
#define MCVideoCellDurationLabelTag 1004

static int MCBytesInOneMB = 1048576;

// Includes for private interface, used only for performance measurement

#import "ASIFormDataRequest.h"
#import "MCAppSettings.h"

@implementation MCVideoListController

@synthesize videosTable;
@synthesize resources;
@synthesize customVideoCell;

- (UITableViewCell *)loadCell
{
	[[NSBundle mainBundle] loadNibNamed:@"MCVideoListCell" owner:self options:nil];
	return self.customVideoCell;
}

- (IBAction)pickVideoPressed:(id)sender {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

- (void)notificationReceived:(NSNotification *)notification
{
	// Resource was updated
	// TODO: add checking here. Currently this method is meant to be used
	// for handling all otherwise unhandled notifications. At the moment only 
	// MCResourceProcessingCompleteNotification will be catched
	DLog(@"MCResourceProcessingCompleteNotification : %@", notification);
	NSString *resourceID = [[notification userInfo] objectForKey:@"resourceID"];
	if (resourceID != nil && [resourceID length]>0) {
		MCAsyncTestTimes *clientTimes = [[MCTestTimesManager sharedManager] timesForID:resourceID];
		clientTimes.clientReceivePushNotification = [[NSDate date] timeIntervalSince1970];
		[clientTimes syncWithServer];
	}
	
	
}

- (void)resourcesUpdated:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	if ([userInfo objectForKey:@"error"] == [NSNull null]) {
		DLog(@"Updating resources was successful redrawing table");
		[self.videosTable reloadData];
	} else {
		DLog(@"Will show alert view");
		NSError *error = [userInfo objectForKey:@"error"];
		NSString *errorMessage = [NSString stringWithFormat:@"%@", error];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error refreshing" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	DLog(@"Notification received. Resources were updated.");
}

- (IBAction)refreshPressed:(id)sender {
	DLog(@"refresh pressed");
	[[MCResourceManager sharedManager] refreshResources];
}

- (IBAction)runTestsPressed:(id)sender {
	MCAsyncTestTimes *testTimes = [[MCAsyncTestTimes alloc] init];
	
	MCVideoResource *testResource = [[MCVideoResource alloc] init];
	[testResource setID:testTimes.testID];
	[testResource setLocation:@"input1"];

	testTimes.clientInitialRequest = [[NSDate date] timeIntervalSince1970];
	[[MCResourceManager sharedManager] requestProcessingResource:testResource];
	[[MCTestTimesManager sharedManager] addTimes:testTimes];
	[testTimes syncWithServer];
	[testTimes release];
}

- (IBAction)syncTimesPressed:(id)sender {
	[[MCTimeSynchronizer sharedSynchronizer] startSyncingWithMCM];
	DLog(@"Time difference : %f", [[MCTimeSynchronizer sharedSynchronizer] calculateSyncDifference]);
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	DLog(@"finished picking : %@", info);
	[picker dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	DLog(@"Ridu kysiti");
	NSInteger rows = [MCResourceManager sharedManager].resources.count;
	return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = 1;
	return sections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MCCustomVideoCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
		cell = [self loadCell];
		DLog(@"New cell w/ reuse identifier : %@", cell.reuseIdentifier);
    }
	MCVideoResource *videoResource = [[MCResourceManager sharedManager].resources objectAtIndex:indexPath.row];
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:MCVideoCellTitleLabelTag];
	UILabel *sizeLabel = (UILabel *)[cell viewWithTag:MCVideoCellSizeLabelTag];
	UILabel *durationLabel = (UILabel *)[cell viewWithTag:MCVideoCellDurationLabelTag];
	
	titleLabel.text = videoResource.title;
	sizeLabel.text = [NSString stringWithFormat:@"%.3f MB", [videoResource.size floatValue]/MCBytesInOneMB];
	durationLabel.text = [NSString stringWithFormat:@"%@ sec", videoResource.duration];
	
    return cell;
}

#pragma mark UITableViewDelegate
// All method optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MCVideoDetailsController *detailsController = [[MCVideoDetailsController alloc] initWithNibName:@"MCVideoDetailsController" bundle:[NSBundle mainBundle]];
	detailsController.videoResource = [[MCResourceManager sharedManager].resources objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detailsController animated:YES];
	[detailsController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DLog(@"I was called");
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[self.videosTable deselectRowAtIndexPath:[self.videosTable indexPathForSelectedRow] animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourcesUpdated:) name:MCResourcesUpdatedNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:MCResourceProcessingCompleteNotification object:nil];
}

- (void)viewDidUnload
{
	[self setVideosTable:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setCustomVideoCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[videosTable release];
	[customVideoCell release];
	[super dealloc];
}
@end
