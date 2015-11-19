//
//  SHImageGalleryView.m
//  SixHands
//
//  Created by Anna Goman on 24.06.15.
//  Copyright (c) 2015 Andrei Kosykhin. All rights reserved.
//

#import "ImageGalleryView.h"
#import <SMPageControl.h>
#import <iCarousel/iCarousel.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIImage+Color.h"

static NSString *ImageGalleryViewNib = @"ImageGalleryView";

@interface ImageGalleryView () <iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet SMPageControl *smPageControl;

@property (weak, nonatomic) IBOutlet iCarousel *carouselView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

- (void) configureUI;

@end

@implementation ImageGalleryView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if (self) {
    if (self.subviews.count == 0) {
      UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
      UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
      subview.frame = self.bounds;
      [self addSubview:subview];
    }
  }
  return self;
}

#pragma mark - Setters Methods


- (void)setImages:(NSArray *)images
{
  if (images.count) {
    _images = images;
    [self configureUI];
  } else {
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
  }
  [_activityIndicatorView stopAnimating];
  _activityIndicatorView.hidden = YES;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
  if (currentIndex < _images.count) {
    _currentIndex = currentIndex;
    [_carouselView scrollToItemAtIndex:_currentIndex animated:NO];
    
    _leftButton.enabled = (_currentIndex != 0);
    _rightButton.enabled = (_currentIndex < _smPageControl.numberOfPages - 1);
  }
}


#pragma mark - UI Methods

- (void)configureUI
{
  self.clipsToBounds = YES;
  self.contentMode = UIViewContentModeScaleAspectFill;
  _carouselView.dataSource = self;
  _carouselView.delegate = self;
  _carouselView.type = iCarouselTypeLinear;
  _carouselView.pagingEnabled = YES;
  _smPageControl.numberOfPages = _images.count;
  _smPageControl.pageIndicatorImage = [UIImage imageNamed:@"uncheked_dot"];
  _smPageControl.currentPageIndicatorImage = [UIImage imageNamed:@"cheked_dot"];
  _leftButton.enabled = NO;
  self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  if (_images.count == 1) {
    _rightButton.enabled = NO;
  }
  
  [[_leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    [self.carouselView scrollToItemAtIndex:_currentIndex-1 animated:YES];
  }];
  
  [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    [self.carouselView scrollToItemAtIndex:_currentIndex+1 animated:YES];
  }];
  
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTapped)];
  self.userInteractionEnabled = YES;
  recognizer.numberOfTapsRequired = 2;
  [self addGestureRecognizer:recognizer];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
  //return the total number of items in the carouse
  return [_images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
  
  UIImageView *imageView = (UIImageView*)view;
  if (imageView == nil) {
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = self.contentMode;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  __block UIImageView *blockImage = imageView;
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_images[index]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
  [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    UIImage* filteredImage =  [UIImage drawOverlayImage:[UIImage imageNamed:@"shadow.png"] inImage:image];

    blockImage.image = filteredImage;

  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
  }];
  return imageView;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
  _smPageControl.currentPage = self.currentIndex = carousel.currentItemIndex;
}


- (void)imageDoubleTapped
{
  self.imageSetFullScreen(self.carouselView.currentItemIndex);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [_carouselView reloadData];
}

@end
