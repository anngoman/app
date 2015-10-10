//
//  PlaceTableViewCell.h
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlaceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *metroLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (void) configureWithPlace:(Place*)place;
- (void) cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view;

@end
