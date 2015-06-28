//
//  UserTableViewCell.h
//  App States
//
//  Created by Zuhayeer Musa on 6/27/15.
//  Copyright (c) 2015 Zuhayeer Musa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIView *roundedView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *opacityFilter;
@property (strong, nonatomic) IBOutlet UILabel *uploadersName;
@property (strong, nonatomic) IBOutlet UILabel *appName;

@end
