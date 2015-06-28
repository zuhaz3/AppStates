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
@property (nonatomic, strong) NSString *deeplink;

@end
