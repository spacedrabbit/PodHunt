//
//  HamburgerView.h
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerView : UITableView

@property (weak, nonatomic) id<UITableViewDataSource> dataSource;
@property (weak, nonatomic) id<UITableViewDelegate>   delegate;


@property (strong, nonatomic) UITableViewCell * basicCell;
@property (strong, nonatomic) UITableViewHeaderFooterView * headerView;

@end
