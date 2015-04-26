//
//  BLCLoginViewController.m
//  Blocstagram
//
//  Created by Work on 3/15/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCAppDelegate.h"
#import "BLCLoginViewController.h"
#import "BLCDataSource.h"

@interface BLCLoginViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isLoading;


@end

@implementation BLCLoginViewController

NSString *const BLCLoginViewControllerDidGetAccessTokenNotification = @"BLCLoginViewControllerDidGetAccessTokenNotification";

- (NSString *)redirectURI {
    return @"http://bloc.io";
}

- (void)loadView {
    
    self.title = NSLocalizedString(@"Login", @"Login");
    
    //Create the object in memory
    UIWebView *webView = [[UIWebView alloc] init];
    
    //set the object delegate
    webView.delegate = self;
    
    //set the property equal to the object
    self.webView = webView;
    
//    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.backButton setEnabled:YES];
//    [self.backButton setTitle:NSLocalizedString(@"Back", @"Back command") forState:UIControlStateNormal];
//    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    self.backButton.enabled = [self.webView canGoBack];
//    [self.webView addSubview:self.backButton];
    
    self.view = webView;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *urlString = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&scope=likes+comments+relationships&redirect_uri=%@&response_type=token", [BLCDataSource instagramClientID], [self redirectURI]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    static const CGFloat itemHeight = 50;
//    CGFloat width = CGRectGetWidth(self.view.bounds);
//    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
//    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 4;
//    
//    self.webView.frame = CGRectMake(0, 0, width, browserHeight);
//    
//    CGFloat currentButtonX = 0;
//    
//    for (UIButton *thisButton in @[self.backButton]) {
//        thisButton.frame = CGRectMake(currentButtonX, CGRectGetMaxY(self.webView.frame), buttonWidth, itemHeight);
//        currentButtonX += buttonWidth;
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    // Removing this line causes a weird flickering effect when you relaunch the app after logging in, as the web view is briefly displayed, automatically authenticates with cookies, returns the access token, and dismisses the login view, sometimes in less than a second.
    [self clearInstagramCookies];
    
    // see https://developer.apple.com/library/ios/documentation/uikit/reference/UIWebViewDelegate_Protocol/Reference/Reference.html#//apple_ref/doc/uid/TP40006951-CH3-DontLinkElementID_1
    self.webView.delegate = nil;
}

/**
 Clears Instagram cookies. This prevents caching the credentials in the cookie jar.
 */
- (void) clearInstagramCookies {
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSRange domainRange = [cookie.domain rangeOfString:@"instagram.com"];
        if(domainRange.location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// This method searches for a URL containing the redirect URI, and then sets the access token to everything after access_token=
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    NSLog(@"uri: %@",[self redirectURI]);
    if ([urlString hasPrefix:[self redirectURI]]) {
        // This contains our auth token
        NSRange rangeOfAccessTokenParameter = [urlString rangeOfString:@"access_token="];
        NSUInteger indexOfTokenStarting = rangeOfAccessTokenParameter.location + rangeOfAccessTokenParameter.length;
        NSString *accessToken = [urlString substringFromIndex:indexOfTokenStarting];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BLCLoginViewControllerDidGetAccessTokenNotification object:accessToken];
        
        return NO;
    }
    
    else if ([urlString isEqualToString:@"https://instagram.com/accounts/password/reset/"])
    {
        UIBarButtonItem *leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backButton)];
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem ;
    }
    
    return YES;
}

@end
