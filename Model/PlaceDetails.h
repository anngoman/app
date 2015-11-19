//
//  PlaceDetails.h
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"

@interface PlaceDetails : Place

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *masters;
@property (nonatomic, strong) NSArray *calians;

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSString *working;

@property (nonatomic, strong) NSString *open;
@property (nonatomic, strong) NSString *close;
@property (nonatomic, strong) NSString *weekendOpen;
@property (nonatomic, strong) NSString *weekendClose;
@property (nonatomic, readonly) NSString *todayOpen;
@property (nonatomic, readonly) NSString *todayClose;

@property (nonatomic, strong) NSString *costCalian;
@property (nonatomic, strong) NSString *costTea;

@property (nonatomic, assign) double rateAtmosphere;
@property (nonatomic, assign) double rateCalian;
@property (nonatomic, assign) double rateService;

@property (nonatomic, assign) BOOL hasDrinks;
@property (nonatomic, assign) BOOL hasFood;

@end




