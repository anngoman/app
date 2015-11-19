//
//  PlaceCaliansViewController.m
//  app
//
//  Created by Anna Goman on 09.05.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlaceCaliansViewController.h"

@interface PlaceCaliansViewController ()

@end

@implementation PlaceCaliansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    NSMutableString *calians = [NSMutableString string];
    for (int i = 0; i<self.calians.count; i++) {
        NSDictionary *calian = self.calians[i];
        [calians appendString:[calian objectForKey:@"name"]];
        if (i<self.calians.count-1) {
            [calians appendString:@", "];
        }
    }
    NSString *str = [NSString stringWithString:calians];
    self.caliansTextView.text = str;
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Do any additional setup after loading the view.
}

 -(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
