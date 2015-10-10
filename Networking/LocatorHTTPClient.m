//
//  LocatorHTTPClient.m
//  app
//
//  Created by Anna Goman on 06.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "LocatorHTTPClient.h"
#import "NSArray+LinqExtensions.h"
#import "Place.h"
#import "City.h"
#import "PlaceComment.h"
#import "PlaceMaster.h"

@implementation LocatorHTTPClient

+ (LocatorHTTPClient *)sharedLocatorHTTPClient
{
    static LocatorHTTPClient *_sharedLocatorHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocatorHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL]];
    });
    
    return _sharedLocatorHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    
    return self;
}


- (void)getCitiesWithSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock
{

    [self GET:@"/api/get_cities_list" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"City - %@",responseObject);

        NSArray *result  = [responseObject linq_select:^id(NSDictionary *cityObj) {
            City *city = [City new];
            city.id = ((NSNumber*)[cityObj objectForKey:@"id"]).integerValue;
            city.name = [cityObj objectForKey:@"name"];
            city.abbr = [cityObj objectForKey:@"abbr"];
            city.latitude = ((NSNumber*)[cityObj objectForKey:@"lat"]).doubleValue;
            city.longitude = ((NSNumber*)[cityObj objectForKey:@"lng"]).doubleValue;
            
            return city;
        }];
        successLoadBlock(result);
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

- (void)getPlacesForCity:(City*)city withSuccessBlock:(void (^)(NSArray *items))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock
{
    [self GET:[NSString stringWithFormat:@"/main/ajax_get_zavs/%@",city.abbr] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"Places - %@",responseObject);

        NSArray *result  = [responseObject linq_select:^id(NSDictionary *info) {
            Place *place = [Place new];
            place.id = ((NSNumber*)[info objectForKey:@"id"]).integerValue;
            place.name = [info objectForKey:@"name"];
            place.city = [info objectForKey:@"city"];
            place.country = [info objectForKey:@"country"];
            place.street = [info objectForKey:@"crossStreet"];
            place.phone = [info objectForKey:@"phone"];
            place.logo = [info objectForKey:@"logo"];
            place.metro = [info objectForKey:@"metro"];
            place.rate = ((NSNumber*)[info objectForKey:@"rate_all"]).doubleValue;
            place.latitude = ((NSNumber*)[info objectForKey:@"lat"]).doubleValue;
            place.longitude = ((NSNumber*)[info objectForKey:@"lng"]).doubleValue;
            place.mainImage = [info objectForKey:@"main_image"];
            return place;
        }];
        successLoadBlock(result);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

- (void)getDetailsForPlace:(Place*)place withSuccessBlock:(void (^)(PlaceDetails *placeDetails))successLoadBlock failureBlock:(void (^)(NSError *error))failureLoadBlock
{
    [self GET:[NSString stringWithFormat:@"/api/get_zav_by_id/%@",[@(place.id) stringValue]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"placeDetails - %@",responseObject);
        
        //parse info
        NSDictionary *info = [responseObject objectForKey:@"info"];
        PlaceDetails *placeDetails = [PlaceDetails new];
        placeDetails.id = ((NSNumber*)[info objectForKey:@"id"]).integerValue;
        placeDetails.name = [info objectForKey:@"name"];
        placeDetails.city = [info objectForKey:@"city"];
        placeDetails.country = [info objectForKey:@"country"];
        placeDetails.street = [info objectForKey:@"crossStreet"];
        placeDetails.phone = [info objectForKey:@"phone"];
        placeDetails.logo = [info objectForKey:@"logo"];
        placeDetails.metro = [info objectForKey:@"metro"];
        placeDetails.rate = ((NSNumber*)[info objectForKey:@"rate_all"]).doubleValue;
        placeDetails.latitude = ((NSNumber*)[info objectForKey:@"lat"]).doubleValue;
        placeDetails.longitude = ((NSNumber*)[info objectForKey:@"lng"]).doubleValue;
        
        placeDetails.open = [info objectForKey:@"open"];
        placeDetails.close = [info objectForKey:@"close"];
        placeDetails.weekendOpen = [info objectForKey:@"weekend_open"];
        placeDetails.weekendClose = [info objectForKey:@"weekend_close"];

        placeDetails.costСalian = [info objectForKey:@"cost_calian"];
        placeDetails.costTea = [info objectForKey:@"cost_tea"];
        placeDetails.mainImage = [info objectForKey:@"main_image"];
        placeDetails.working = [info objectForKey:@"working"];

        placeDetails.photos = [info objectForKey:@"photos"];
        placeDetails.rateAtmosphere = ((NSNumber*)[info objectForKey:@"rate_atmosphere"]).doubleValue;
        placeDetails.rateCalian = ((NSNumber*)[info objectForKey:@"rate_calian"]).doubleValue;
        placeDetails.rateService = ((NSNumber*)[info objectForKey:@"rate_service"]).doubleValue;
        
        placeDetails.hasDrinks = ((NSNumber*)[info objectForKey:@"drinks"]).boolValue;
        placeDetails.hasFood = ((NSNumber*)[info objectForKey:@"food"]).boolValue;
        placeDetails.calians = [responseObject objectForKey:@"tags"];

        //parse comments
        NSArray *comments = [responseObject objectForKey:@"comments"];
        NSArray *commentsResult  = [comments linq_select:^id(NSDictionary *info) {
            PlaceComment *placeComment = [PlaceComment new];
            placeComment.id = ((NSNumber*)[info objectForKey:@"comment_id"]).integerValue;
            placeComment.text = [info objectForKey:@"text"];
            placeComment.nickName = [info objectForKey:@"nickname"];
            placeComment.photo = [info objectForKey:@"photo"];
            placeComment.rang = [info objectForKey:@"rang"];
            placeComment.likes = ((NSNumber*)[info objectForKey:@"likes"]).integerValue;
            placeComment.dislikes = ((NSNumber*)[info objectForKey:@"dislikes"]).integerValue;
            placeComment.date = [info objectForKey:@"date"];
            placeComment.time = [info objectForKey:@"time"];
            
            return placeComment;
        }];
        placeDetails.comments = commentsResult;
        
        //parse  masters
        NSArray *masters = [responseObject objectForKey:@"master"];
        NSArray *masterResult  = [masters linq_select:^id(NSDictionary *info) {
            PlaceMaster *placeMaster = [PlaceMaster new];
            placeMaster.id = ((NSNumber*)[info objectForKey:@"id"]).integerValue;
            placeMaster.name = [info objectForKey:@"name"];
            placeMaster.photo = [info objectForKey:@"photo"];
            placeMaster.experience = [info objectForKey:@"stazh"];
            
            return placeMaster;
        }];
        placeDetails.masters = masterResult;
        
     
        successLoadBlock(placeDetails);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureLoadBlock(error);
    }];
}

@end
