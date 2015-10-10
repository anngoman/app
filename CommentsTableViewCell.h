//
//  CommentsTableViewCell.h
//  Hookah Locator
//
//  Created by Anna Goman on 26.05.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DinamicHeightLabel.h"

@interface CommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet DinamicHeightLabel *commentLabel;

@end
