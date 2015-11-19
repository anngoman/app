//
//  Place.m
//  app
//
//  Created by Anna Goman on 06.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "Place.h"
#import "NSArray+LinqExtensions.h"

static NSString *kID = @"kID";
static NSString *kName = @"kName";
static NSString *kPhone = @"kPhone";
static NSString *kRate = @"kRate";
static NSString *kCity = @"kCity";
static NSString *kCountry = @"kCountry";
static NSString *kMetro = @"kMetro";
static NSString *kStreet = @"kStreet";
static NSString *kImage = @"kImage";
static NSString *kLatitude = @"kLatitude";
static NSString *kLongitude = @"kLongitude";
static NSString *kDistance = @"kDistance";
static NSString *kMainImage = @"kMainImage";

@implementation Place

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _id = [decoder decodeIntegerForKey:kID];
    _name = [decoder decodeObjectForKey:kName];
    _phone = [decoder decodeObjectForKey:kPhone];
    _city = [decoder decodeObjectForKey:kCity];
    _country = [decoder decodeObjectForKey:kCountry];
    _metro = [decoder decodeObjectForKey:kMetro];
    _street = [decoder decodeObjectForKey:kStreet];
    _mainImage = [decoder decodeObjectForKey:kMainImage];
    _rate = [decoder decodeDoubleForKey:kRate];
    _latitude = [decoder decodeDoubleForKey:kLatitude];
    _longitude = [decoder decodeDoubleForKey:kLongitude];
    _distance = [decoder decodeDoubleForKey:kDistance];
    _logo = [decoder decodeObjectForKey:kImage];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_id forKey:kID];
    [coder encodeObject:_name forKey:kName];
    [coder encodeObject:_phone forKey:kPhone];
    [coder encodeObject:_city forKey:kCity];
    [coder encodeObject:_country forKey:kCountry];
    [coder encodeObject:_metro forKey:kMetro];
    [coder encodeObject:_street forKey:kStreet];
    [coder encodeObject:_mainImage forKey:kMainImage];
    [coder encodeDouble:_rate forKey:kRate];
    [coder encodeDouble:_latitude forKey:kLatitude];
    [coder encodeDouble:_longitude forKey:kLongitude];
    [coder encodeDouble:_distance forKey:kDistance];
    [coder encodeObject:_logo forKey:kImage];

}

#pragma mark -  Sorting / Filtering Methods


+ (NSArray*)sortedPlacesByDistance:(NSArray*)places {
    return [places linq_sort:^id(Place *place) {
        return [NSNumber numberWithDouble:place.distance];
    }];
}

+ (NSArray*)sortedPlacesByRating:(NSArray*)places {
    return [[places linq_sort:^id(Place *place) {
        return [NSNumber numberWithDouble:place.rate];
    }] linq_reverse];
}

+ (NSArray*)filteredPlacesByName:(NSArray*)places withString:(NSString*)searchString {
    return [places linq_where:^BOOL(Place* place) {
        return [place.name.lowercaseString rangeOfString:searchString.lowercaseString].location != NSNotFound;
    }];
}

@end
