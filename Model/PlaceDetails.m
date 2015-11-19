//
//  PlaceDetails.m
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlaceDetails.h"

@interface PlaceDetails ()

- (BOOL)isWeekend;

@end

@implementation PlaceDetails

- (BOOL)isWeekend {
    NSDate *today = [NSDate date];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"c"];
    NSString *dayOfWeek = [myFormatter stringFromDate:today];

    if (dayOfWeek.intValue >= 6) {
        return YES;
    }
    return NO;
}

- (NSString *)todayOpen {
    if ([self isWeekend]) {
        return self.weekendOpen;
    } else {
        return self.open;
    }
}

- (NSString *)todayClose {
    if ([self isWeekend]) {
        return self.weekendClose;
    } else {
        return self.close;
    }
}

@end
