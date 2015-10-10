//
//  City.h
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *abbr;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
