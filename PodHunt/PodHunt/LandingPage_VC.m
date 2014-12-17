//
//  LandingPage_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+HoneyPotColorPallette.h"
#import "LandingPage_VC.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"
#import "UserSplashPageController.h"
#import "UserSplashPage.h"
#import "GitHubAPIRequestManager.h"

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>

@interface LandingPage_VC ()

@property (strong,  nonatomic)      UIView      * rootView;
@property (strong,  nonatomic)      UIView      * contentView;

@property (weak,    nonatomic)      UIButton    * loginButton;

@property (strong,  nonatomic)      UserSplashPage * splashPage;
@property (strong,  nonatomic)      UITableView * splashStarTable;
@property (strong,  nonatomic)      UITableView * splashForkTable;

@property (strong, nonatomic)       GitHubAPIRequestManager * sharedAPIManager;

@property (strong, nonatomic)       UIViewController * leftMenuViewController;

@end

@implementation LandingPage_VC

-(instancetype)init{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 44.0)];
        [self.view addSubview:_contentView];
        
        _splashPage = [[UserSplashPage alloc] initWithFrame:_contentView.bounds];
        [_splashPage setBackgroundColor:[UIColor eggShellWhite]];
        [_contentView addSubview:_splashPage];
        
        _splashStarTable = _splashPage.starredTable;
        _splashForkTable = _splashPage.forkedTable;
        
        _sharedAPIManager = [GitHubAPIRequestManager sharedManager];
    }
    return self;
}

-(void)loadView
{
    _rootView = [[UIView alloc] init];
    [self setView:_rootView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PodHunt";
    self.leftMenuViewController = [[UIViewController alloc] init];
    
    [self.contentView.layer setBorderColor:[UIColor bloodOrangeRed].CGColor];
    [self.contentView.layer setBorderWidth:3.0];

    // -- MMDrawerBarButton -- //
    UIBarButtonItem * hamburger = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftMenu)];
    self.navigationItem.leftBarButtonItem = hamburger;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// -- MMDrawerMenu -- // 
-(void) leftMenu{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

// -- misc methods -- //
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
