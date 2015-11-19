//
//  ResponseParser.h
//  HLocator
//
//  Created by Anna on 19.11.15.
//  Copyright © 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlaceDetails;

@interface ResponseParser : NSObject

+ (NSArray*)citiesFromResponse:(NSArray*)response;
+ (NSArray*)placesFromResponse:(NSArray*)response;
+ (PlaceDetails*)placeDetailsFromResponse:(NSDictionary*)response;

@end
