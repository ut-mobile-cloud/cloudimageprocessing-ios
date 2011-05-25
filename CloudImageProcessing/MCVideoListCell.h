//
//  MCVideoListCell.h
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MCVideoListCell : UITableViewCell {
    
	UIImageView *thumbnailImageView;
	UILabel *titleLabel;
	UILabel *sizeLabel;
	UILabel *durationLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *sizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;

+ (MCVideoListCell *)cellFromNibNamed:(NSString *)nibName;

@end
