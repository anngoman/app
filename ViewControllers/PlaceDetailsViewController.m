//
//  PlaceDetailsViewController.m
//  app
//
//  Created by Anna Goman on 08.04.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "PlaceDetails.h"
#import "PlaceComment.h"
#import "UIImageView+AFNetworking.h"
#import "SettingsManager.h"
#import <QuartzCore/QuartzCore.h>
#import "PlaceCommentsViewController.h"
#import "PlaceCaliansViewController.h"
#import "SVProgressHUD.h"
#import "UIImage+Color.h"


@interface PlaceDetailsViewController ()
{
    CGPoint _lastContentOffset;
    CGPoint _startContentOffset;
    
    BOOL _isHiddenNavBar;

}

- (void) configureView;

@end

@implementation PlaceDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.placeDetails.name;
    _isHiddenNavBar = YES;
    [self configureView];
    [self downloadImage];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = _isHiddenNavBar;

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self changeViewSizes];
    [self.view layoutIfNeeded];

}

- (void) changeViewSizes
{
    self.rateLabel.layer.borderWidth = 2;
    self.rateLabel.layer.borderColor = ORANGE_COLOR.CGColor;
    self.rateLabel.layer.cornerRadius = self.rateLabel.frame.size.width / 2;
    self.rateLabel.clipsToBounds = YES;
    
    self.calianButton.layer.borderWidth = 0.5;
    self.calianButton.layer.borderColor = GRAY_COLOR.CGColor;
    
    self.commentsButton.layer.borderWidth = 0.5;
    self.commentsButton.layer.borderColor = GRAY_COLOR.CGColor;
    
    [self.distanceLabel sizeToFit];
    self.streetLabel.frame = CGRectMake(CGRectGetMaxX(self.distanceLabel.frame) + 5, self.streetLabel.frame.origin.y, self.streetLabel.frame.size.width, self.streetLabel.frame.size.height);
    
    if (self.placeDetails.comments.count) {
        self.commentNameLabel.text = ((PlaceComment*)self.placeDetails.comments[0]).nickName;
        self.commentTextLabel.text = ((PlaceComment*)self.placeDetails.comments[0]).text;
        [self.commentTextLabel sizeToFit];
//        self.commentsButton.frame = CGRectMake(12, CGRectGetMaxY(self.commentTextLabel.frame) + 10, self.view.bounds.size.width - 24, 50);
//        self.commentsView.frame = CGRectMake(self.commentsView.frame.origin.x, self.commentsView.frame.origin.y, self.commentsView.frame.size.width, CGRectGetMaxY(self.commentsButton.frame) + 20);
//        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,CGRectGetMaxY(self.commentsView.frame));
        
        
    } else {
        self.commentsView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,CGRectGetMaxY(self.foodView.frame));
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Private

- (void)configureView
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    self.nameLabel.text = self.placeDetails.name;
    self.streetLabel.text = self.placeDetails.street;
    
    self.timeWorkLabel.text = [NSString stringWithFormat:@"с %@ до %@",self.placeDetails.todayOpen, self.placeDetails.todayClose];
    self.costTeaLabel.text = [NSString stringWithFormat:@"%@ руб",self.placeDetails.costTea];
    self.costCalyanLabel.text = [NSString stringWithFormat:@"%@ руб",self.placeDetails.costСalian];
    
    self.rateLabel.text = [NSString stringWithFormat:@"%.1f",self.placeDetails.rate];
    self.rateCalianLabel.text = [NSString stringWithFormat:@"%.1f",self.placeDetails.rateCalian];
    self.rateAtmosLabel.text = [NSString stringWithFormat:@"%.1f",self.placeDetails.rateAtmosphere];
    self.rateServiceLabel.text = [NSString stringWithFormat:@"%.1f",self.placeDetails.rateService];
    
    if (self.placeDetails.distance < 1000) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%.0f м.",self.placeDetails.distance];
    } else {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f км.",(self.placeDetails.distance/1000)];
    }

    self.hasFoodLabel.text = self.placeDetails.hasFood?@"есть":@"нет";
    self.hasAlcoholLabel.text = self.placeDetails.hasDrinks?@"есть":@"нет";

    if ([[SettingsManager sharedSettingsManager] isFavoritePlace:self.placeDetails]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart_zak.png"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"Удалить";
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"В избранное";
    }
}

- (void)downloadImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_BASE_URL,_placeDetails.mainImage]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.logoImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.logoImageView.image =  [UIImage drawOverlayImage:[UIImage imageNamed:@"shadow.png"] inImage:image];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Image download error!");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"CommentsSegue"]) {
        ((PlaceCommentsViewController*)segue.destinationViewController).placeComments = self.placeDetails.comments;
    }
    if ([segue.identifier isEqualToString:@"CSegue"]) {
        ((PlaceCaliansViewController*)segue.destinationViewController).calians = self.placeDetails.calians;
    }
    
}


#pragma mark - IBAction

- (IBAction)addToFavorite:(id)sender {
    if ([[SettingsManager sharedSettingsManager] isFavoritePlace:self.placeDetails]) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        [[SettingsManager sharedSettingsManager] removeFromFavorites:self.placeDetails];
        self.favoriteLabel.text = @"В избранное";
        [SVProgressHUD showSuccessWithStatus:@"Удалено!"];

    } else {
        [[SettingsManager sharedSettingsManager] addToFavorites:self.placeDetails];
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart_zak.png"] forState:UIControlStateNormal];
        self.favoriteLabel.text = @"Удалить";
        [SVProgressHUD showSuccessWithStatus:@"Добавлено!"];
    }

}

- (IBAction)openMap:(UIBarButtonItem*)item {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"Яндекс.Навигатор",@"Яндекс.Карты", nil];
    actionSheet.actionSheetStyle = UIBarStyleBlack;
    [actionSheet showInView:self.view];
    
}

- (IBAction)callToPhone:(id)sender
{
    NSString *cleanedString = [[self.placeDetails.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
    [[UIApplication sharedApplication] openURL:phoneURL];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height))
    {
        //is bounce
        return;
    }
    
    CGFloat differenceFromStart = _startContentOffset.y - scrollView.contentOffset.y;
//    CGFloat differenceFromLast = _lastContentOffset.y - scrollView.contentOffset.y;
    _lastContentOffset = scrollView.contentOffset;
    
    if((differenceFromStart) < 0)
    {
        // scroll up // && (abs(((int)differenceFromLast))>1)
        if(_isHiddenNavBar && scrollView.contentOffset.y >=  self.logoImageView.frame.size.height- self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height)
        {

            [UIView animateWithDuration:0.1 animations:^{
                self.navigationController.navigationBar.translucent = NO;
                _isHiddenNavBar = NO;
                
            }];
        }
    }
    else {
        if (!_isHiddenNavBar && scrollView.contentOffset.y <  self.logoImageView.frame.size.height- self.navigationController.navigationBar.frame.size.height) {
            [UIView animateWithDuration:0.1 animations:^{
                self.navigationController.navigationBar.translucent = YES;
                _isHiddenNavBar = YES;
                
            }];
        }
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _startContentOffset = _lastContentOffset = scrollView.contentOffset;

}


#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSURL* naviURL = [NSURL URLWithString:[NSString stringWithFormat:@"yandexnavi://build_route_on_map?lat_from=%f&lon_from=%f&lat_to=%f&lon_to=%f",_locationManager.location.coordinate.latitude
                                                   ,_locationManager.location.coordinate.longitude,_placeDetails.latitude,_placeDetails.longitude]];
            
            if ([[UIApplication sharedApplication] canOpenURL:naviURL]) {
                [[UIApplication sharedApplication] openURL:naviURL];
            } else {
                NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/yandeks.navigator/id474500851?mt=8"];
                [[UIApplication sharedApplication] openURL:appStoreURL];
            }
        }
            break;
        case 1:
        {
            
            NSString *yaMapsString = [NSString stringWithFormat:@"yandexmaps://maps.yandex.ru/?pt=%f,%f&ll=%f,%f", _placeDetails.longitude, _placeDetails.latitude, _locationManager.location.coordinate.longitude, _locationManager.location.coordinate.latitude];
            NSURL *yamapsUrl = [NSURL URLWithString:yaMapsString];
            if ([[UIApplication sharedApplication] canOpenURL:yamapsUrl])
            {
                [[UIApplication sharedApplication] openURL:yamapsUrl];
            } else {
                NSURL* appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/andeks.karty-karta-rossii/id313877526?mt=8"];
                [[UIApplication sharedApplication] openURL:appStoreURL];
            }
        }
            break;
        case 2:
            
            break;
        default:
            break;
            
    }
}


@end
