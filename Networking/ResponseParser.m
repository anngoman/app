//
//  ResponseParser.m
//  HLocator
//
//  Created by Anna on 19.11.15.
//  Copyright © 2015 victorsharov. All rights reserved.
//

#import "ResponseParser.h"
#import "Place.h"
#import "City.h"
#import "PlaceComment.h"
#import "PlaceMaster.h"
#import "PlaceDetails.h"
#import "NSArray+LinqExtensions.h"

@implementation ResponseParser

+ (NSArray*)citiesFromResponse:(NSArray*)response {
  NSArray *cities  = [response linq_select:^id(NSDictionary *cityObj) {
    City *city = [City new];
    city.id = ((NSNumber*)[cityObj objectForKey:@"id"]).integerValue;
    city.name = [cityObj objectForKey:@"name"];
    city.abbr = [cityObj objectForKey:@"abbr"];
    city.latitude = ((NSNumber*)[cityObj objectForKey:@"lat"]).doubleValue;
    city.longitude = ((NSNumber*)[cityObj objectForKey:@"lng"]).doubleValue;
        return city;
  }];
  return cities;
}

+ (NSArray*)placesFromResponse:(NSArray*)response {
  NSArray *places  = [response linq_select:^id(NSDictionary *info) {
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
  return places;
}

+ (PlaceDetails*)placeDetailsFromResponse:(NSDictionary*)response {
  NSDictionary *info = [response objectForKey:@"info"];
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
  
  placeDetails.costCalian = [info objectForKey:@"cost_calian"];
  placeDetails.costTea = [info objectForKey:@"cost_tea"];
  placeDetails.mainImage = [info objectForKey:@"main_image"];
  placeDetails.working = [info objectForKey:@"working"];
  
  placeDetails.photos = [info objectForKey:@"photos"];
  placeDetails.rateAtmosphere = ((NSNumber*)[info objectForKey:@"rate_atmosphere"]).doubleValue;
  placeDetails.rateCalian = ((NSNumber*)[info objectForKey:@"rate_calian"]).doubleValue;
  placeDetails.rateService = ((NSNumber*)[info objectForKey:@"rate_service"]).doubleValue;
  
  placeDetails.hasDrinks = ((NSNumber*)[info objectForKey:@"drinks"]).boolValue;
  placeDetails.hasFood = ((NSNumber*)[info objectForKey:@"food"]).boolValue;
  placeDetails.calians = [response objectForKey:@"tags"];
  
  //parse comments
  NSArray *comments = [response objectForKey:@"comments"];
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
  NSArray *masters = [response objectForKey:@"master"];
  NSArray *masterResult  = [masters linq_select:^id(NSDictionary *info) {
    PlaceMaster *placeMaster = [PlaceMaster new];
    placeMaster.id = ((NSNumber*)[info objectForKey:@"id"]).integerValue;
    placeMaster.name = [info objectForKey:@"name"];
    placeMaster.photo = [info objectForKey:@"photo"];
    placeMaster.experience = [info objectForKey:@"stazh"];
    
    return placeMaster;
  }];
  placeDetails.masters = masterResult;
  return placeDetails;
}

@end
