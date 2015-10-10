//
//  CommentPlace.h
//  app
//
//  Created by Anna Goman on 09.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "comment_id": "660",
 "text": "7",
 "date": "2015-03-13",
 "time": "01:16:26",
 "nickname": "alan.tishin",
 "photo": "\/files\/avatars\/54fc6f40869a4.jpg",
 "likes": "1",
 "dislikes": "0",
 "rang": "\u0432\u043b\u0430\u0434\u0435\u043b\u0435\u0446"
 },
 */

@interface PlaceComment : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *photo;

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *rang;

@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) NSInteger dislikes;


@end
