//
//  ViewController.h
//  app
//
//  Created by Victor Sharov on 12/03/15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox-iOS-SDK/Mapbox.h>

@interface PlacesViewController : UIViewController<RMMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *chooseCityBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapBarButton;

- (IBAction)selectViewType:(id)sender;

@end

