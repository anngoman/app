//
//  PlaceTableViewCell.m
//  app
//
//  Created by Anna Goman on 07.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlaceTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SettingsManager.h"
#import "UIImage+Color.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation PlaceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithPlace:(Place*)place {
    self.nameLabel.text = place.name;
    
    if (place.distance < 1000) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0f м.",place.distance];
    } else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f км.",(place.distance/1000)];
    }
    self.rateLabel.text = [NSString stringWithFormat:@"%.1f",place.rate];
    self.metroLabel.text = [NSString stringWithFormat:@"%@",place.metro];
    self.streetLabel.text = [NSString stringWithFormat:@"%@",place.street];
    self.logoImageView.image = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:        [NSString stringWithFormat:@"%@%@",SERVER_BASE_URL,place.mainImage]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.logoImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.logoImageView.image = [UIImage drawOverlayImage:[UIImage imageNamed:@"bg_zav.png"] inImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image download error!");
    }];
    
}

//parallax cell
- (void)cellOnTableView:(UITableView *)tableView didScrollOnView:(UIView *)view {
    CGRect rectInSuperview = [tableView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame)/2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.logoImageView.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.logoImageView.frame;
    imageRect.origin.y = -(difference/2)+move;
    self.logoImageView.frame = imageRect;
    
}


@end
