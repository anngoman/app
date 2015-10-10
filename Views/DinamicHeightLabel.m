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
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    if (bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
