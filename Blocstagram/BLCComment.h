//
//  BLCComment.h
//  Blocstagram
//
//  Created by Work on 2/25/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCUser;

@interface BLCComment : NSObject <NSCoding>

@property (nonatomic, strong) NSString *idNumber;

@property (nonatomic, strong) BLCUser *from;
@property (nonatomic, strong) NSString *text;

 - (instancetype) initWithDictionary:(NSDictionary *)commentDictionary;

@end
