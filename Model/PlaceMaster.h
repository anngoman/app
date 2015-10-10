//
//  PlaceMaster.h
//  app
//
//  Created by Anna Goman on 09.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "master": [
 {
 "id": "7",
 "zav_id": "266",
 "name": "tester",
 "stazh": "duet 100 let",
 "photo": "\/files\/masters\/552100f81063f.jpg"
 }*/

@interface PlaceMaster : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *experience;


@end
