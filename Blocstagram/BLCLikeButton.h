//
//  BLCLikeButton.h
//  Blocstagram
//
//  Created by Work on 4/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Defines four possible states the button might be in

typedef NS_ENUM(NSInteger, BLCLikeState) {
    BLCLikeStateNotLiked    = 0,
    BLCLikeStateLiking      = 1,
    BLCLikeStateLiked       = 2,
    BLCLikeStateUnliking    = 3
};

@interface BLCLikeButton : UIButton

/*
 The current state of the like button. Setting to BLCLikeButtonNotLiked or BLCLikeButtonLiked will display an empty heart or a heart, respectively. Setting to BLCLikeButtonLiking or BLCLikeButtonUnliking will display an activity indicator and disable button taps until the button is set to BLCLikeButtonNotLiked or BLCLikeButtonLiked.
 */

@property (nonatomic, assign) BLCLikeState likeButtonState;  // Expose a property for storing this state

@end
