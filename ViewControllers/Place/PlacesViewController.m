//
//  ViewController.m
//  app
//
//  Created by Victor Sharov on 12/03/15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlacesViewController.h"
#import "LocatorHTTPClient.h"
#import "MMProgressHUD.h"
#import "Place.h"
#import "PlaceTableViewCell.h"
#import "SettingsManager.h"
#import "PlaceDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>

static NSString* CellIdentifier = @"PlaceTableViewCell";

typedef enum : NSUInteger {
  kTopRateTabBarItem,
  kSearchTabBarItem,
  kFavoritesTabBarItem
} TabBarItem;

typedef enum : NSUInteger {
  kListViewType,
  kMapViewType
} ViewType;

@interface PlacesViewController ()  <RMMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate> {
  NSArray *_places;
  NSArray *_downloadedPlaces;
  NSArray *_searchResults;
  
  RMMapView *_mapView;
  ViewType _currentViewType;
  TabBarItem _selectedTabBarItem;
  
  CGPoint _lastContentOffset;
  CGPoint _startContentOffset;
  CGRect _tableViewFrame;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *chooseCityBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mapBarButton;

- (IBAction)selectViewType:(id)sender;

- (void) getPlaces;
- (void) getDetailsForPlace:(Place*)place;

- (void) addPinstoMap;
- (void) addMapToView;
- (void) searchControllerCustomize;
- (void) tabBarCustomize;

- (void) reloadData;
- (void) updateLocation;

@end

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation PlacesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _selectedTabBarItem = kSearchTabBarItem;
  [_tabBar setSelectedItem:[_tabBar.items objectAtIndex:_selectedTabBarItem]];
  
  [self searchControllerCustomize];
  [self tabBarCustomize];
  [self updateLocation];
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  if (_selectedTabBarItem == kFavoritesTabBarItem) {
    _places = [SettingsManager sharedSettingsManager].favorites;
  }
  if (_places.count > 0) {
    [self getPlaces];
  }
  [self setTabBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  _tableViewFrame = _tableView.frame;
  
}

#pragma mark - Networking Methods


- (void)getPlaces {
  
  [MMProgressHUD showWithTitle:@"Загрузка..."];
  [[LocatorHTTPClient sharedLocatorHTTPClient] getPlacesForCity:[SettingsManager sharedSettingsManager].city withSuccessBlock:^(NSArray *items) {
    [MMProgressHUD dismiss];
    
    for (Place *place in items) {
      
      CLLocation *location2 = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
      place.distance = [_locationManager.location distanceFromLocation:location2];
    }
    
    _downloadedPlaces = items;
    _places = [Place sortedPlacesByDistance:items];
    
    [self reloadData];
    
  } failureBlock:^(NSError *error) {
    
    NSLog(@"error - %@",error);
    NSString *textError = @"Проблемы с интернетом";
    if (error.localizedDescription) {
      textError = error.localizedDescription;
    }
    [MMProgressHUD dismissWithError:textError title:@"Ошибка"];
  }];
}

- (void) getDetailsForPlace:(Place*)place {
  [MMProgressHUD showWithTitle:@"Загрузка..."];
  [[LocatorHTTPClient sharedLocatorHTTPClient] getDetailsForPlace:place withSuccessBlock:^(PlaceDetails *placeDetails) {
    [MMProgressHUD dismissWithSuccess:@"Загружено"];
    placeDetails.latitude = place.latitude;
    placeDetails.longitude = place.longitude;
    placeDetails.distance = place.distance;
    
    [self performSegueWithIdentifier:@"DetailsSegue"
                              sender:placeDetails];
  } failureBlock:^(NSError *error) {
    NSLog(@"error - %@",error);
    NSString *textError = @"Ошибка";
    if (error.localizedDescription) {
      textError = error.localizedDescription;
    }
    [MMProgressHUD dismissWithError:textError title:@"Ошибка"];
    
  }];
}


#pragma mark - Interface Methods

- (void) reloadData {
  switch (_selectedTabBarItem) {
    case kTopRateTabBarItem:
    {
      _places = [Place sortedPlacesByRating:_downloadedPlaces];
    }
      break;
    case kSearchTabBarItem:
    {
      _places = [Place sortedPlacesByDistance:_downloadedPlaces];
    }
      break;
    case kFavoritesTabBarItem:
    {
      _places = [SettingsManager sharedSettingsManager].favorites;
    }
      break;
    default:
      break;
  }
  [_tableView  reloadData];
  
  [self addPinstoMap];
}

-(void)addPinstoMap {
  [_mapView removeAllAnnotations];
  
  for (Place *place in _places) {
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:_mapView
                                                          coordinate:CLLocationCoordinate2DMake(place.latitude, place.longitude)
                                                            andTitle:place.name];
    
    annotation.subtitle = place.street;
    annotation.userInfo = place;
    
    [_mapView addAnnotation:annotation];
    
  }
}

- (void)addMapToView {
  RMMapboxSource *onlineSource = [[RMMapboxSource alloc] initWithMapID:@"shizboy.k1leipc9"];
  _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource];
  _mapView.zoom = 4;
  _mapView.delegate = self;
  _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  _mapView.showsUserLocation = YES;
  _mapView.userTrackingMode = RMUserTrackingModeFollow;
  _mapView.alpha = 0;
  [self.view addSubview:_mapView];
}


- (void)searchControllerCustomize {
  self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
  self.searchDisplayController.navigationItem.leftBarButtonItem = self.chooseCityBarButton;
  self.searchDisplayController.navigationItem.rightBarButtonItem = self.mapBarButton;
  self.searchDisplayController.searchResultsTableView.backgroundColor = BACKGROUND_COLOR;
  self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.searchDisplayController.searchBar.placeholder = @"Поиск";
  
  UITextField *txtSearchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
  [txtSearchField setBorderStyle:UITextBorderStyleRoundedRect];
  txtSearchField.layer.borderWidth = 2.0f;
  txtSearchField.layer.borderColor = [ORANGE_COLOR CGColor];
  txtSearchField.backgroundColor = BACKGROUND_COLOR;
  txtSearchField.textColor = [UIColor whiteColor];
}

- (void)tabBarCustomize {
  //    UITabBarItem *firstTab = [self.tabBar.items objectAtIndex:0];
  //    firstTab.image = [[UIImage imageNamed:@"star.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
  //
  //    UITabBarItem *secondTab = [self.tabBar.items objectAtIndex:1];
  //    secondTab.image = [[UIImage imageNamed:@"pin.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
  //
  //    UITabBarItem *thirdTab = [self.tabBar.items objectAtIndex:2];
  //    thirdTab.image = [[UIImage imageNamed:@"heart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
}

- (void)updateLocation {
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [MMProgressHUD showWithTitle:@"Поиск местоположения"];
    [manager startUpdatingLocation];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  manager.delegate = nil;
  [self addMapToView];
  [self getPlaces];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Location Manager error - %@",error);
  [MMProgressHUD dismissWithError:@"Проблема с GPS" title:@"Ошибка"];
}


#pragma mark - UISearchDisplayController

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
  _searchResults = [_places filteredArrayUsingPredicate:resultPredicate];
  return YES;
}


#pragma mark - UITableViewDataSource / UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return _searchResults.count;
    
  } else {
    return _places.count;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  PlaceTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[PlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  Place *place = nil;
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    place = _searchResults[indexPath.row];
  } else {
    place = _places[indexPath.row];
  }
  [cell configureWithPlace:place];
  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  
  Place *place = nil;
  if (self.searchDisplayController.active) {
    place = _searchResults[indexPath.row];
  } else {
    place = _places[indexPath.row];
  }
  
  [self getDetailsForPlace:place];
  
  if (self.searchDisplayController.isActive) {
    [self.searchDisplayController setActive:NO animated:NO];
    
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = 115.0f;
  return  height;
}

#pragma mark - MapViewDelegate

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation {
  if (annotation.isUserLocationAnnotation)
    return nil;
  
  RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"hpin.png"]];
  marker.rightCalloutAccessoryView = [UIButton
                                      buttonWithType:UIButtonTypeDetailDisclosure];
  
  marker.canShowCallout = YES;
  
  return marker;
}


-(void)mapViewRegionDidChange:(RMMapView *)mapView {
  [self.view endEditing:YES];
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control
                       forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map {
  [self getDetailsForPlace:(Place*)annotation.userInfo];
}

#pragma mark - IBActions

- (IBAction)selectViewType:(UINavigationItem*)item {
  
  if (_currentViewType == kListViewType)
  {
    self.searchDisplayController.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"list.png"];
    _currentViewType = kMapViewType;
    _tableView.alpha = 0;
    _mapView.alpha = 1;
  }
  else
  {
    self.searchDisplayController.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"map.png"];
    _currentViewType = kListViewType;
    _tableView.alpha = 1;
    _mapView.alpha = 0;
  }
  
  if (self.searchDisplayController.isActive) {
    [self.searchDisplayController setActive:NO animated:YES];
  }
}


#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
  if (self.searchDisplayController.isActive) {
    [self.searchDisplayController setActive:NO animated:YES];
    
  }
  _selectedTabBarItem = [[tabBar items] indexOfObject:item];
  [self reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if ([segue.identifier isEqualToString:@"DetailsSegue"]) {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    ((PlaceDetailsViewController*)segue.destinationViewController).placeDetails = (PlaceDetails*)sender;
    ((PlaceDetailsViewController*)segue.destinationViewController).locationManager = _locationManager;
    
  }
  
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSArray *visibleCells = [self.tableView visibleCells];
  
  for (PlaceTableViewCell *cell in visibleCells) {
    [cell cellOnTableView:self.tableView didScrollOnView:self.view];
  }
  
  if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height))
  {
    //is bounce
    return;
  }
  
  //expand view
  
  CGFloat differenceFromStart = _startContentOffset.y - scrollView.contentOffset.y;
  CGFloat differenceFromLast = _lastContentOffset.y - scrollView.contentOffset.y;
  _lastContentOffset = scrollView.contentOffset;
  
  if((differenceFromStart) < 0)
  {
    // scroll up
    if(scrollView.isTracking && (abs(((int)differenceFromLast))>1))
    {
      
      if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (!self.searchDisplayController.active) {
          [self setTabBarHidden:YES animated:YES];
        }
      }
      
    }
  }
  else {
    if(scrollView.isTracking && (abs(((int)differenceFromLast))>1))
    {
      if (self.navigationController.navigationBarHidden) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        if (!self.searchDisplayController.active) {
          [self setTabBarHidden:NO animated:YES];
          
        }
      }
    }
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _startContentOffset = _lastContentOffset = scrollView.contentOffset;
}

#pragma mark - Tab Bar


- (void) setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
  if(hidden)
  {
    if(animated)
    {
      self.tableView.frame = self.view.bounds;
      
      [UIView animateWithDuration:0.2
                       animations:^{
                         
                         self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                        self.view.bounds.size.height,
                                                        self.view.bounds.size.width,
                                                        self.tabBar.frame.size.height);
                       }
                       completion:^(BOOL finished) {
                         
                       }];
    }
    else
    {
      
      self.tableView.frame = self.view.bounds;
      self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                     self.view.bounds.size.height,
                                     self.view.bounds.size.width,
                                     self.tabBar.frame.size.height);
    }
  }
  else
  {
    
    if(animated)
    {
      [UIView animateWithDuration:0.2
                       animations:^{
                         self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                                        self.view.bounds.size.height - self.tabBar.frame.size.height,
                                                        self.view.bounds.size.width,
                                                        self.tabBar.frame.size.height);
                       }   completion:^(BOOL finished) {
                         self.tableView.frame = _tableViewFrame;
                       }];
    }
    else
    {
      self.tableView.frame = _tableViewFrame;
      
      self.tabBar.frame = CGRectMake(self.view.bounds.origin.x,
                                     self.view.bounds.size.height - self.tabBar.frame.size.height,
                                     self.view.bounds.size.width,
                                     self.tabBar.frame.size.height);
    }
  }
}


@end


