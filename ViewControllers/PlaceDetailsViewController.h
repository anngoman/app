//
//  PlaceDetailsViewController.h
//  app
//
//  Created by Anna Goman on 08.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>

@class PlaceDetails;

@interface PlaceDetailsViewController : UIViewController < UIScrollViewAccessibilityDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) PlaceDetails* placeDetails;
@property (nonatomic, retain) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeWorkLabel;

@property (weak, nonatomic) IBOutlet UILabel *costCalyanLabel;
@property (weak, nonatomic) IBOutlet UILabel *costTeaLabel;
;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateCalianLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateAtmosLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateServiceLabel;

@property (weak, nonatomic) IBOutlet UILabel *hasFoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *hasAlcoholLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UIView *foodView;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIButton *calianButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;


- (IBAction)addToFavorite:(id)sender;

- (IBAction)openMap:(id)sender;
- (IBAction)callToPhone:(id)sender;

@end
