//
//  citySelectViewController.h
//  app
//
//  Created by Victor Sharov on 05/04/15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface citySelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tablewView;

@end
