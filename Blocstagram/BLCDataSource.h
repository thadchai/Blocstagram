//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Work on 2/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCMedia;

typedef void (^BLCNewItemCompletionBlock)(NSError *error);

@interface BLCDataSource : NSObject

+ (instancetype) sharedInstance;

@property (nonatomic, strong, readonly) NSArray *mediaItems;

- (void) deleteMediaItem:(BLCMedia *)item;

// Pull Down to Refresh
- (void) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;

// Infinite Scroll
- (void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler;

@end
