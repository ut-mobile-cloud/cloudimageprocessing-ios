//
//  MCVideoListController.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCVideoListCell;

@interface MCVideoListController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *resources;
	UITableViewCell *customVideoCell;
	UITableView *videosTable;
}

@property (nonatomic, retain) IBOutlet UITableView *videosTable;
@property (nonatomic, retain) NSMutableArray *resources;
@property (nonatomic, retain) IBOutlet UITableViewCell *customVideoCell;

- (IBAction)pickVideoPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;
- (IBAction)runTestsPressed:(id)sender;

@end
