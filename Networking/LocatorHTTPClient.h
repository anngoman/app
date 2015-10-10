//
//  LocatorHTTPClient.h
//  app
//
//  Created by Anna Goman on 06.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "PlaceDetails.h"

@class City, Place;

@interface LocatorHTTPClient : AFHTTPSessionManager

+ (LocatorHTTPClient *)sharedLocatorHTTPClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)getCitiesWithSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock;

- (void)getPlacesForCity:(City*)city withSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock;

- (void)getDetailsForPlace:(Place*)place withSuccessBlock:(void (^)(PlaceDetails *placeDetails))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock;

@end
