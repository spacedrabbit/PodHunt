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

static NSString * const kPodsEndPoint = @"http://search.cocoapods.org/api/pods";
static NSString * const kPodsAcceptHeader = @"application/vnd.cocoapods.org+picky.hash.json; version=1";

// The API pattern is: http://metrics.cocoapods.org/api/v1/pods/PODNAME.json
static NSString * const kPodsMetrics = @"http://metrics.cocoapods.org/api/v1/pods/";

@interface LandingPage_VC () <GitHubLoginViewControllerDelegate>

@property (strong, nonatomic) UIView * rootView;
@property (strong, nonatomic) UIView * contentView;
@property (weak, nonatomic) UIButton * loginButton;

@end

@implementation LandingPage_VC

-(instancetype)init{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 44.0)];
        [self.view addSubview:_contentView];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)loginButton:(id)sender {
    
    gitHubLogin_VC * loginScreen = [[gitHubLogin_VC alloc] init];
    loginScreen.delegate = self;
    [self presentViewController:loginScreen animated:YES completion:^{
        NSLog(@"Done");
    }];
    
}

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

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
