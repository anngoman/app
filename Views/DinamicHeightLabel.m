//
//  DinamicCellLabel.m
//  Hookah Locator
//
//  Created by Anna Goman on 26.05.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "DinamicHeightLabel.h"

@implementation DinamicHeightLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if (bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
