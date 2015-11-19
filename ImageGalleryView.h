//
//  SHImageGalleryView.h
//  SixHands
//
//  Created by Anna Goman on 24.06.15.
//  Copyright (c) 2015 Andrei Kosykhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ImageGalleryView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, readonly) RACSignal* imageTappedSignal;
@property (nonatomic, copy) void (^imageSetFullScreen)(NSInteger currentIndex);


@end
