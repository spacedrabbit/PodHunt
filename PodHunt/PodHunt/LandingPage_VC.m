//
//  LandingPage_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UIColor+HoneyPotColorPallette.h"
#import "LandingPage_VC.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"
#import "UserSplashPage.h"
#import "GitHubAPIRequestManager.h"

@interface LandingPage_VC () <GitHubLoginViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

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
        [_contentView addSubview:_splashPage];
        
        _splashPage.tableDelegate = self;
        _splashStarTable = _splashPage.starredTable;
        _splashForkTable = _splashPage.forkedTable;
    }
    return self;
}

-(void)loadView
{
    _rootView = [[UIView alloc] init];
    [_rootView setBackgroundColor:[UIColor whiteColor]];
    [self setView:_rootView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * gitLogoLogin = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"GitHub-Mark"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(loginButton:)];
    
    self.navigationItem.title = @"PodHunt";
    self.navigationItem.rightBarButtonItem = gitLogoLogin;
    
    [self.contentView.layer setBorderColor:[UIColor seafoamGreen].CGColor];
    [self.contentView.layer setBorderWidth:3.0];
    
    // -- set up views according to logged in status -- //
    if ([self currentlyLoggedIn])
    {
        NSLog(@"Logged in");;
    }
    else{
        NSLog(@"No users authenticated");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL) currentlyLoggedIn{
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"githubToken"]) {
        NSLog(@"Key found");
        return YES;
    };
    return NO;
}


#pragma mark - Navigation

// -- NavBar item to log in -- //
- (void)loginButton:(id)sender {
    
    gitHubLogin_VC * loginScreen = [[gitHubLogin_VC alloc] init];
    loginScreen.delegate = self;
    [self presentViewController:loginScreen animated:YES completion:^{
        NSLog(@"Done");
    }];
    
}

// -- delegate method of the GitHubLogin class -- //
-(void)didFinishLoggingIn{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"];
        UIAlertView * finishedLogin =[[UIAlertView alloc] initWithTitle:@"Login Successful!"
                                                                message:[NSString stringWithFormat:@"You have logged in with token: %@", token]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [finishedLogin show];
    }];
}

// -- misc methods -- //
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
