//
//  BLCMedia.h
//  Blocstagram
//
//  Created by Work on 2/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //had to add this for UIImage to be recognized

@class BLCUser;

@interface BLCMedia : NSObject <NSCoding>

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) BLCUser *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;

 - (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
