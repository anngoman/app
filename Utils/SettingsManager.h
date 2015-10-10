//
//  SettingsManager.h
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "Place.h"

@interface SettingsManager : NSObject

+ (instancetype)sharedSettingsManager;

@property (nonatomic, strong) City *city;
@property (nonatomic, readonly) NSArray *favorites;

- (void) addToFavorites:(Place*)place;
- (void) removeFromFavorites:(Place*)place;
- (BOOL) isFavoritePlace:(Place*)place;

@end
