//
//  ViewController.m
//  App States
//
//  Created by Zuhayeer Musa on 6/27/15.
//  Copyright (c) 2015 Zuhayeer Musa. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UserTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize refresh control
    if (self.refreshControl == nil) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    
        refreshControl.tintColor = [UIColor darkGrayColor];
        
        [self.tableView addSubview:refreshControl];
        [self.tableView sendSubviewToBack:refreshControl];
        self.refreshControl = refreshControl;
    }
}

-(void)onRefresh:(id)sender {
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableCell";
    
    UserTableViewCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    if(indexPath.row == 1){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:0.75];
    }
    else if (indexPath.row == 2){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:0.75];
    }
    else if (indexPath.row == 3){
        cell.opacityFilter.backgroundColor = [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:0.75];
    }
    cell.uploadersName.text = @"Danish Shaik";
    cell.appName.text = @"Spotify";
    
    cell.opacityFilter.layer.cornerRadius = 3;
    cell.opacityFilter.layer.masksToBounds = YES;
    cell.backgroundImageView.layer.cornerRadius = 3;
    cell.backgroundImageView.layer.masksToBounds = YES;
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.noiseporn.com/wp-content/uploads/spotifyroyalties.jpg"]
                                placeholderImage:[UIImage imageNamed:@"profile"] options:SDWebImageRefreshCached];
    cell.roundedView.layer.cornerRadius = 3;
    cell.profileImage.layer.cornerRadius = 22;
    cell.profileImage.layer.masksToBounds = YES;
    cell.profileImage.layer.borderWidth = 0;
    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/514108659660759040/PwcLTe3q_400x400.jpeg"]
                         placeholderImage:[UIImage imageNamed:@"profile"] options:SDWebImageRefreshCached];
    
    cell.userName.text = @"No Church in the Wild, Kanye West";
    cell.userName.textColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}




@end
