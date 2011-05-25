//
//  MCVideoListCell.m
//  CloudImageProcessing
//
//  Created by Madis Nõmme on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCVideoListCell.h"


@implementation MCVideoListCell
@synthesize thumbnailImageView;
@synthesize titleLabel;
@synthesize sizeLabel;
@synthesize durationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	DLog(@"Cell was selected");

    // Configure the view for the selected state
}

+ (MCVideoListCell *)cellFromNibNamed:(NSString *)nibName
{
	
	NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    MCVideoListCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[MCVideoListCell class]]) {
            customCell = (MCVideoListCell *)nibItem;
            break; // we have a winner
        }
    }
    return customCell;
}

- (void)dealloc
{
    [thumbnailImageView release];
    [titleLabel release];
    [sizeLabel release];
    [durationLabel release];
    [super dealloc];
}

@end
