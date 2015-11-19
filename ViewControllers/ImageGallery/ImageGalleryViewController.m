//
//  SHImageGalleryViewController.m
//  SixHands
//
//  Created by Anna Goman on 24.06.15.
//  Copyright (c) 2015 Andrei Kosykhin. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "ImageGalleryView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ImageGalleryViewController ()
@property (nonatomic, strong) IBOutlet ImageGalleryView *imageGallery;

@property (nonatomic, strong) NSArray *images;

- (void)configureUI;

@end

@implementation ImageGalleryViewController

- (instancetype)initWithImages:(NSArray *)images
{
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    _images = images;
  }
  return  self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureUI];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
//
//- (void)viewDidLayoutSubviews {
//  [super viewDidLayoutSubviews];
//  self.imageGallery.frame = self.view.bounds;
//}

#pragma mark - UI Methods

- (void)configureUI
{
  self.imageGallery.images = _images;
  self.imageGallery.currentIndex = _currentIndex;
  self.imageGallery.contentMode = UIViewContentModeScaleAspectFit;
  [[self.imageGallery imageTappedSignal] subscribeNext:^(id x) {
    [self dismissViewControllerAnimated:YES completion:^{
      self.receiveCurrentState(self.imageGallery.currentIndex);
    }];
  }];
}

#pragma mark -  Setters

- (void)setCurrentIndex:(NSInteger)currentIndex
{
  _currentIndex = currentIndex;
  self.imageGallery.currentIndex = _currentIndex;
}

@end
