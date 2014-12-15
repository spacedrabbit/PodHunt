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

@interface LandingPage_VC ()

@property (strong,  nonatomic)      UIView      * rootView;
@property (strong,  nonatomic)      UIView      * contentView;

@property (weak,    nonatomic)      UIButton    * loginButton;

@property (strong,  nonatomic)      UserSplashPage * splashPage;
@property (strong,  nonatomic)      UITableView * splashStarTable;
@property (strong,  nonatomic)      UITableView * splashForkTable;

@property (strong, nonatomic)       GitHubAPIRequestManager * sharedAPIManager;

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

    
    [self.contentView.layer setBorderColor:[UIColor bloodOrangeRed].CGColor];
    [self.contentView.layer setBorderWidth:3.0];
    
    UIBarButtonItem * profileView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(sideBarButton:)];
    self.navigationItem.leftBarButtonItem = profileView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - Navigation

// -- NavBar item to log in -- //
- (void)loginButton:(id)sender {
    
    gitHubLogin_VC * loginScreen = [[gitHubLogin_VC alloc] init];
    [self presentViewController:loginScreen animated:YES completion:^{
        NSLog(@"Done");
    }];
    
}

-(void) sideBarButton:(id)sender{

    UserSplashPageController * userProfileView = [[UserSplashPageController alloc] init];
    [self.navigationController showViewController:userProfileView sender:self];
    
}

// -- misc methods -- //
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
