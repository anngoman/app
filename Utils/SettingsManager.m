//
//  SettingsManager.m
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "SettingsManager.h"

static NSString *kCity = @"kCityKey";
static NSString *kFavorites = @"kFavoritesKey";


@implementation SettingsManager

+ (instancetype)sharedSettingsManager {
    static SettingsManager *_sharedSettingsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettingsManager = [[SettingsManager alloc] init];
    });
    
    return _sharedSettingsManager;
}


- (void)setCity:(City *)city {
    if (city) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:city];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCity];
    }
}

- (City *)city {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCity];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

- (void)setFavorites:(NSArray *)favorites{
    if (favorites) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favorites];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kFavorites];
    }
}

- (NSArray *)favorites {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kFavorites];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return [NSArray array];
    }
}

#pragma mark - Favorites Methods

- (void) addToFavorites:(Place*)place {
    if (![self isFavoritePlace:place]) {
        NSMutableArray *favorites = self.favorites.mutableCopy;
        [favorites addObject:place];
        [self setFavorites:favorites.copy];
    }
}

- (void) removeFromFavorites:(Place*)place{
    NSInteger index = [self.favorites indexOfObjectPassingTest:^BOOL(Place* placeObj, NSUInteger idx, BOOL *stop) {
        return (place.id == placeObj.id);
    }];
    
    if (index != NSNotFound) {
        NSMutableArray *favorites = self.favorites.mutableCopy;
        [favorites removeObjectAtIndex:index];
        [self setFavorites:favorites.copy];
    }
}

- (BOOL)isFavoritePlace:(Place*)place {
    NSInteger index = [self.favorites indexOfObjectPassingTest:^BOOL(Place* placeObj, NSUInteger idx, BOOL *stop) {
        return (place.id == placeObj.id);
    }];
    return (index != NSNotFound);
}

@end
