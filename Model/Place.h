//
//  Place.h
//  app
//
//  Created by Anna Goman on 06.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) double rate;
@property (nonatomic, strong) NSString *mainImage;

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *metro;
@property (nonatomic, strong) NSString *street;

@property (nonatomic, strong) NSString *logo;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double distance;


+ (NSArray*)sortedPlacesByDistance:(NSArray*)places;
+ (NSArray*)sortedPlacesByRating:(NSArray*)places;
+ (NSArray*)filteredPlacesByName:(NSArray*)places withString:(NSString*)searchString;

@end

