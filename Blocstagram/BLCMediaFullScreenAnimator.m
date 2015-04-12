//
//  BLCMediaFullScreenAnimator.m
//  Blocstagram
//
//  Created by Work on 4/8/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCMediaFullScreenAnimator.h"
#import "BLCMediaFullScreenViewController.h"

@implementation BLCMediaFullScreenAnimator

// Specify how many seconds long the animation will be
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //points to the table view controller
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //point to the full screen image view controller
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        BLCMediaFullScreenViewController *fullScreenVC = (BLCMediaFullScreenViewController *)toViewController;
        
        //disable user interaction on the table view controller, so the users can't scroll while the animation is happening
        fromViewController.view.userInteractionEnabled = NO;
        
        //add the views of both view controllers to the transition context's container view
        [transitionContext.containerView addSubview:toViewController.view];
        
        //calculate the initial frame of the new view controller before the animation begins
        //converts a view's frame or bounds from one view's coordinate system into the receiver's
        CGRect startFrame = [transitionContext.containerView convertRect:self.cellImageView.bounds fromView:self.cellImageView];
        CGRect endFrame = fromViewController.view.frame;
        
        toViewController.view.frame = startFrame;
        fullScreenVC.imageView.frame = toViewController.view.bounds;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            
            fullScreenVC.view.frame = endFrame;
            [fullScreenVC centerScrollView];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        BLCMediaFullScreenViewController *fullScreenVC = (BLCMediaFullScreenViewController *)fromViewController;
        
        CGRect endFrame = [transitionContext.containerView convertRect:self.cellImageView.bounds fromView:self.cellImageView];
        CGRect imageStartFrame = [fullScreenVC.view convertRect:fullScreenVC.imageView.frame fromView:fullScreenVC.scrollView];
        CGRect imageEndFrame = [transitionContext.containerView convertRect:endFrame toView:fullScreenVC.view];
        
        imageEndFrame.origin.y = 0;
        
        [fullScreenVC.view addSubview:fullScreenVC.imageView];
        fullScreenVC.imageView.frame = imageStartFrame;
        fullScreenVC.imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        
        toViewController.view.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fullScreenVC.view.frame = endFrame;
            fullScreenVC.imageView.frame = imageEndFrame;
            
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end