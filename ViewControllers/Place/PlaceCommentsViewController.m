//
//  PlaceCommentsViewController.m
//  app
//
//  Created by Anna Goman on 09.05.15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "PlaceCommentsViewController.h"
#import "PlaceComment.h"
#import "CommentsTableViewCell.h"

static NSString* CellIdentifier = @"CommentsCell";


@interface PlaceCommentsViewController ()

@end

@implementation PlaceCommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeComments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(CommentsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PlaceComment *comment = self.placeComments[indexPath.row];
    cell.nameLabel.text = comment.nickName;
    cell.commentLabel.text = comment.text;
    cell.dateLabel.text = comment.date;
    [cell.commentLabel sizeToFit];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     CommentsTableViewCell *sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:sizingCell atIndexPath:indexPath];
    
    CGFloat height = 40 + sizingCell.commentLabel.frame.size.height;
    return  height;
}




@end
