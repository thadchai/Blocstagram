//
//  BLCMediaTableViewCell.h
//  Blocstagram
//
//  Created by Work on 3/2/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCMedia, BLCMediaTableViewCell;

@protocol BLCMediaTableViewCellDelegate <NSObject>

- (void) cell:(BLCMediaTableViewCell *)cell didTapImageView:(UIImageView *)imageView;
- (void) cell:(BLCMediaTableViewCell *)cell didLongPressImageView:(UIImageView *)imageView;

// Adding a method indicating that the button was pressed
- (void) cellDidPressLikeButton:(BLCMediaTableViewCell *)cell;

// Assignment Work - two finger tap on cell to retry image download
- (void) cell:(BLCMediaTableViewCell *)cell didTwoFingerPressImageView:(UIImageView *)imageView;

@end

@interface BLCMediaTableViewCell : UITableViewCell

// Get the media item
@property (nonatomic, strong) BLCMedia *mediaItem;
@property (nonatomic, weak) id <BLCMediaTableViewCellDelegate> delegate;

+ (CGFloat) heightForMediaItem:(BLCMedia *)mediaItem width:(CGFloat)width;

@end
