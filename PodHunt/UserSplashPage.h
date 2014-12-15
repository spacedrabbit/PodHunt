//
//  UserSplashPage.h
//  PodHunt
//
//  Created by Louis Tur on 12/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSplashPage : UIView

@property (strong, nonatomic) id<UITableViewDataSource,UITableViewDelegate> tableDelegate;

@property (strong, nonatomic) UIImageView * profileImage;
@property (strong, nonatomic) UIView * profileView;
@property (strong, nonatomic) UITableView * starredTable;
@property (strong, nonatomic) UITableView * forkedTable;

@end
