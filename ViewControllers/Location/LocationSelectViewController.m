//
//  citySelectViewController.m
//  app
//
//  Created by Victor Sharov on 05/04/15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "LocationSelectViewController.h"
#import "LocatorHTTPClient.h"
#import "MMProgressHUD.h"
#import "City.h"
#import "SettingsManager.h"

@interface LocationSelectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *cities;
@property (weak, nonatomic) IBOutlet UITableView *tablewView;

@end

@implementation LocationSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCities];
}

- (void)loadCities {
    [MMProgressHUD showWithTitle:@"Загрузка городов..."];
    [[LocatorHTTPClient sharedLocatorHTTPClient] getCitiesWithSuccessBlock:^(NSArray *items) {
        [MMProgressHUD dismissWithSuccess:@"Загружено"];
        _cities = [NSMutableArray arrayWithArray:items];
        [_tablewView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error - %@",error);
        NSString *textError = @"Проблемы с интернетом";
        if (error.localizedDescription) {
            textError = error.localizedDescription;
        }
        [MMProgressHUD dismissWithError:textError title:@"Ошибка"];
    }];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

  City *city = _cities[indexPath.row];
    cell.textLabel.text = city.name;
    cell.backgroundColor = ([city isEqual:[SettingsManager sharedSettingsManager].city])?SELECTED_BACKGROUND_COLOR:BACKGROUND_COLOR;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([SettingsManager sharedSettingsManager].city == nil) {
        [self performSegueWithIdentifier:@"PlacesSegue" sender:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [SettingsManager sharedSettingsManager].city =  _cities[indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
