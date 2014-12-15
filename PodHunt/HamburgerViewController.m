//
//  HamburgerViewController.m
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UIColor+HoneyPotColorPallette.h"
#import "HamburgerViewController.h"
#import "HamburgerView.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) HamburgerView * rootTable;

@end

@implementation HamburgerViewController

-(instancetype)init{
    self = [super init];
    if (self)
    {
        _rootTable = [[HamburgerView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _rootTable.dataSource = self;
        _rootTable.delegate = self;
        [self.view addSubview:_rootTable];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillLayoutSubviews{
    
    [_rootTable setBackgroundColor:[UIColor eggShellWhite]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HamburgerView * table = ((HamburgerView *)tableView);
    UITableViewCell * cell = [table dequeueReusableCellWithIdentifier:table.basicCell.reuseIdentifier];
    
    if(indexPath.section == 0){
        cell.textLabel.text = @"THis is section 1";
    }else{
        cell.textLabel.text = @"THis is section Else";
    }
    
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rootTable numberOfSections];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootTable numberOfRowsInSection:section];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.rootTable headerViewForSection:section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.rootTable sectionHeaderHeight];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.rootTable rowHeight];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
