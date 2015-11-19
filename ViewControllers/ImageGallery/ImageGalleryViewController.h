//
//  SHImageGalleryViewController.h
//  SixHands
//
//  Created by Anna Goman on 24.06.15.
//  Copyright (c) 2015 Andrei Kosykhin. All rights reserved.
//


@interface ImageGalleryViewController : UIViewController
@property (nonatomic, copy) void (^receiveCurrentState)(NSInteger currentIndex);
@property (nonatomic, assign) NSInteger currentIndex;

- (instancetype)initWithImages:(NSArray *)images;

@end
