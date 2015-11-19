//
//  City.m
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "City.h"
static NSString *kID = @"kID";
static NSString *kName = @"kName";
static NSString *kAbbr = @"kAbbr";
static NSString *kLatitude = @"kLatitude";
static NSString *kLongitude = @"kLongitude";

@implementation City

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _id = [decoder decodeIntegerForKey:kID];
    _name = [decoder decodeObjectForKey:kName];
    _abbr = [decoder decodeObjectForKey:kAbbr];
    _latitude = [decoder decodeDoubleForKey:kLatitude];
    _longitude = [decoder decodeDoubleForKey:kLongitude];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_id forKey:kID];
    [coder encodeObject:_name forKey:kName];
    [coder encodeObject:_abbr forKey:kAbbr];
    [coder encodeDouble:_latitude forKey:kLatitude];
    [coder encodeDouble:_longitude forKey:kLongitude];
}

- (BOOL)isEqual:(City*)object {
    return [_abbr isEqualToString:object.abbr];
}

@end
