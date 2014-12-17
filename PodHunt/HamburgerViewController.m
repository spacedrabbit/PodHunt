//
//  HamburgerViewController.m
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UIColor+HoneyPotColorPallette.h"
#import "UserSplashPageController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "gitHubLogin_VC.h"
#import "HamburgerViewController.h"
#import "HamburgerView.h"
#import "AppDelegate.h"
#import "LandingPage_VC.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) HamburgerView * rootTable;
@property (strong, nonatomic) UIVisualEffectView * fancyView;

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
        
        _fancyView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [self.view insertSubview:_fancyView aboveSubview:_rootTable];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillLayoutSubviews{
    
    [_rootTable setBackgroundColor:[UIColor eggShellWhite]];
    [_rootTable setContentOffset:CGPointMake(0.0, -100)];
    [_rootTable setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
    
    [_fancyView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray * fancyViewConstraints = @[ [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_fancyView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_fancyView)],
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_fancyView(==100)]"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_fancyView)]
                                       ];
    for (NSArray * constraints in fancyViewConstraints) {
        [self.view addConstraints:constraints];
    }
    UIImageView * cocoaPod = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cocoabeen"]];
    [_fancyView addSubview:cocoaPod];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HamburgerView * table = ((HamburgerView *)tableView);
    UITableViewCell * cell = [table dequeueReusableCellWithIdentifier:table.basicCell.reuseIdentifier];
    
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Go Home";
        }else{
            cell.textLabel.text = @"Browse Pods";
        }
    }else{
        if (indexPath.section == 0) {
            cell.textLabel.text = @"Login With GitHub";
        }else{
            cell.textLabel.text = @"Other things";
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UINavigationController * rootNav = (UINavigationController *)self.mm_drawerController.centerViewController;
//    
//    if ( [rootNav.visibleViewController isKindOfClass:[LandingPage_VC class]]) {
//       // [self.mm_drawerController.navigationController popToRootViewControllerAnimated:YES];
//        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    }
    
    UIViewController * dstvc;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            LandingPage_VC * mainPage = [[LandingPage_VC alloc] init];
            dstvc = mainPage;
            
        }else{
            UserSplashPageController * userProfileView = [[UserSplashPageController alloc] init];
            dstvc = userProfileView;
        }
    }
    else
    {
        gitHubLogin_VC * loginScreen = [[gitHubLogin_VC alloc] init];
        dstvc = loginScreen;
    }
    
    [UIView animateWithDuration:.4 animations:^{
        [self.mm_drawerController.centerViewController showViewController:dstvc sender:self];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        }
    }];
}
-(BOOL)transitioningFrom:(UIViewController *)origin to:(UIViewController *)destination
{
    
    return YES;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==1 ){
        return 40.0;
    }
    return 0.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    if (section == 1) {
       
        [footerView setBackgroundColor:[UIColor beigerThanBeige]];
        
    }
    return footerView;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
