//
//  AppDeals.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/6/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDeals : NSObject

    @property int dealCount;
    @property NSString *dataUrl;
    @property NSArray *apps;
    @property NSDate *refreshedAt;

@end