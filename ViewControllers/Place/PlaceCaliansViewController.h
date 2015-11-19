//
//  PlaceCaliansViewController.h
//  app
//
//  Created by Anna Goman on 09.05.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCaliansViewController : UIViewController

@property (nonatomic, strong) NSArray *calians;
@property (weak, nonatomic) IBOutlet UITextView *caliansTextView;

@end
