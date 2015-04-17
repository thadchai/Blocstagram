//
//  BLCMediaFullScreenViewController.m
//  Blocstagram
//
//  Created by Work on 4/7/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCMediaFullScreenViewController.h"
#import "BLCMedia.h"


@interface BLCMediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) BLCMedia *media;

// Properties for gesture recognizers
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;


@end

@implementation BLCMediaFullScreenViewController

- (instancetype) initWithMedia:(BLCMedia *)media {
    self = [super init];
    
    if (self) {
        self.media = media;
    }
    
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    // setting up the scroll view and image view
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.media.image.size;
    
    // initializing Tap Gesture Recognizers
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    // numberOfTapsRequired = allows a tap gesture recognizer to require more than one tap to fire
    self.doubleTap.numberOfTapsRequired = 2;
    
    //requireGestureRecognizerToFail = allows one gesture recognizer to wait for another gesture recognizer to fail before it succeeds. Without this line, it would be impossible to double-tap because the single tap gesture recognizer would fire before the user had a chance to tap twice.
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    // Assignment - Share Button -- Walked through w/ Mark
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //Setting properties of the button
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    shareButton.backgroundColor = [UIColor whiteColor];
    [shareButton sizeToFit];
    [shareButton setFrame: (CGRectMake(20, 20, shareButton.frame.size.width, shareButton.frame.size.height))];
    [self.scrollView addSubview:shareButton];
    
    
}
    // Assignment - Share Button -- Took and pieced together from BLCImageTableViewController
- (void) share {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    [itemsToShare addObject:self.imageView.image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // setting up minimumZoomScale & maximumZoomScale
    
    // the scroll view's frame is set to the view's bounds. So the scroll view will always take up all of the view's space
    self.scrollView.frame = self.view.bounds;
    
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    // the ratio of the scroll view's width to the image's width
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    // the ratio of the scroll view's height to the image's height
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    
    // Whichever is smaller will become our minimumZoomScale
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    
    // maximumZoomScale will always be 1 (representing 100%).
    self.scrollView.maximumZoomScale = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Makes sure that the image starts out centered
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

// centerScrollView - If the image is zoomed down so that it doesn't fill the full scroll view, this method will center the image on that axis.
- (void)centerScrollView {
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate
// two scroll view delegates

//This method tells the scroll view which view to zoom in and out on;
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//This method calls centerScrollView when the user has changed the zoom level.
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}

#pragma mark - Gesture Recognizers

// When the user single-taps, simply dismiss the view controller
- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// When the user double-taps, adjust the zoom level
// If the current zoom scale is already as small as it can be, double-tapping will zoom in
// This works by calculating a rectangle using the user's finger as a center point, and telling the scroll view to zoom in on that rectangle.
- (void) doubleTapFired:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    } else {
        // If the current zoom scale is larger, then zoom out to the minimum scale
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

// Assignment - Share Button selector
//- (void) share:(UITapGestureRecognizer *)sender {
//    self.shareButton.enabled = [self.];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
