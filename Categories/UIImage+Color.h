//
//  UIImage+Color.h
//  Zabbkit
//
//  Created by Alexey Dozortsev on 19.09.13.
//  Copyright (c) 2013 Andrey Kosykhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)colorizeImage:(UIImage *)image withColor:(UIColor *)color ;
+ (UIImage*)drawOverlayImage:(UIImage*) overlayImage
                      inImage:(UIImage*) image;
@end
