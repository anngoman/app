//
//  LocatorHTTPClient.m
//  app
//
//  Created by Anna Goman on 06.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "LocatorHTTPClient.h"
#import "ResponseParser.h"
#import "City.h"

@implementation LocatorHTTPClient

+ (LocatorHTTPClient *)sharedLocatorHTTPClient {
    static LocatorHTTPClient *_sharedLocatorHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocatorHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL]];
    });
    return _sharedLocatorHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return self;
}


- (void)getCitiesWithSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock {
    [self GET:@"/api/get_cities_list" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      NSArray *cities = [ResponseParser citiesFromResponse:responseObject];
        successLoadBlock(cities);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

- (void)getPlacesForCity:(City*)city withSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock {
    [self GET:[NSString stringWithFormat:@"/main/ajax_get_zavs/%@",city.abbr] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      NSArray *places = [ResponseParser placesFromResponse:responseObject];
      successLoadBlock(places);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

- (void)getDetailsForPlace:(Place*)place withSuccessBlock:(void (^)(PlaceDetails *placeDetails))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock {
    [self GET:[NSString stringWithFormat:@"/api/get_zav_by_id/%@",[@(place.id) stringValue]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      PlaceDetails *placeDetails = [ResponseParser placeDetailsFromResponse:responseObject];
      successLoadBlock(placeDetails);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

@end
