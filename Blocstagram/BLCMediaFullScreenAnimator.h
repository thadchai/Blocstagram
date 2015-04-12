//
//  BLCMediaFullScreenAnimator.h
//  Blocstagram
//
//  Created by Work on 4/8/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BLCMediaFullScreenAnimator : NSObject <UIViewControllerAnimatedTransitioning>

// presenting (Property), will let us know if the animation is a presenting animation (if not, it's a dismissing animation)
@property (nonatomic, assign) BOOL presenting;

// cellImageView (Property), will reference the image view from the media table view cell (the image view the user taps on)
@property (nonatomic, weak) UIImageView *cellImageView;

@end
