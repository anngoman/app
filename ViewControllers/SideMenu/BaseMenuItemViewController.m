//
//  BaseMenuItemViewController.m
//  HLocator
//
//  Created by Anna on 19.11.15.
//  Copyright © 2015 victorsharov. All rights reserved.
//

#import "BaseMenuItemViewController.h"
#import "SWRevealViewController.h"

@interface BaseMenuItemViewController ()

@end

@implementation BaseMenuItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  SWRevealViewController *revealViewController = self.revealViewController;
  if ( revealViewController )
  {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector( revealToggle: )];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
  }
    // Do any additional setup after loading the view.
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
