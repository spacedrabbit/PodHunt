//
//  UserSplashPageController.m
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UserSplashPageController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AFNetworking/AFNetworking.h>
#import "UIColor+HoneyPotColorPallette.h"
#import "LandingPage_VC.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"
#import "UserSplashPage.h"
#import "GitHubAPIRequestManager.h"

@interface GitHubProfileCache : NSURLCache <AFImageCache>

@property (weak, nonatomic) UIImage * cachedProfileImage;

@end


@implementation GitHubProfileCache

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIImage *)cachedImageForRequest:(NSURLRequest *)request{
    
    NSCachedURLResponse * fullResponse = [self cachedResponseForRequest:request];
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)fullResponse.response;
    
    
    if (httpResponse.statusCode == 200)
    {
        NSLog(@"Good status, sending image back");
        return [UIImage imageWithData:fullResponse.data];
    }
    return nil;
}
-(void)cacheImage:(UIImage *)image forRequest:(NSURLRequest *)request{
    
    NSCachedURLResponse * profileImageResponse = [[NSCachedURLResponse alloc] init];
    [self storeCachedResponse:profileImageResponse forRequest:request];
    
}

@end

@interface UserSplashPageController () <GitHubLoginViewControllerDelegate>

@property (strong,  nonatomic)      UIView      * rootView;
@property (strong,  nonatomic)      UIView      * contentView;

@property (weak,    nonatomic)      UIButton    * loginButton;

@property (strong,  nonatomic)      UserSplashPage * splashPage;
@property (strong,  nonatomic)      UITableView * splashStarTable;
@property (strong,  nonatomic)      UITableView * splashForkTable;

@property (strong, nonatomic)       GitHubAPIRequestManager * sharedAPIManager;
@property (strong, nonatomic)       GitHubProfileCache * profileCache;


@end

@implementation UserSplashPageController

-(instancetype)init{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height - 44.0)];
        [self.view addSubview:_contentView];
        
        _splashPage = [[UserSplashPage alloc] initWithFrame:_contentView.bounds];
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
    
    [self.contentView.layer setBorderColor:[UIColor bloodOrangeRed].CGColor];
    [self.contentView.layer setBorderWidth:3.0];
    [self.contentView setBackgroundColor:[UIColor eggShellWhite]];
    
    self.profileCache = [[GitHubProfileCache alloc] init];
    [UIImageView setSharedImageCache:self.profileCache];
    
}
-(void)viewDidLayoutSubviews{
    
}
-(void)viewWillLayoutSubviews{
    [self.splashPage.profileView setBackgroundColor:[UIColor eggShellWhite]];
    [self.splashPage.profileView.layer setBorderColor:[UIColor bloodOrangeRed].CGColor];
    [self.splashPage.profileView.layer setBorderWidth:3.0];
    [self.splashPage.profileView.layer setCornerRadius:11.0];
    
    if ([self currentlyLoggedIn])
    {
        NSLog(@"Logged in");
        [self getUserInfo:^(BOOL complete){
        }];
    }
    else{
        NSLog(@"No users authenticated");
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self currentlyLoggedIn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) getUserInfo:(void(^)(BOOL))completion{
    
    [self.sharedAPIManager useToken: [[NSUserDefaults standardUserDefaults] stringForKey:@"githubToken"]];
    [self.sharedAPIManager getCurrentlyLoggedinUserInfo:^(NSDictionary * userInfo) {
        
        NSURL * profileImageURL =[NSURL URLWithString:[userInfo objectForKey:@"avatar_url"]];
        
        [self.splashPage.profileImage setImageWithURL:profileImageURL];
        [self.splashPage.profileImage.layer setMasksToBounds:YES];
        
    }];
}
-(BOOL) currentlyLoggedIn{
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"githubToken"]) {
        NSLog(@"Key found");
        [self.sharedAPIManager useToken:[[NSUserDefaults standardUserDefaults] stringForKey:@"githubToken"]];
        return YES;
    };
    return NO;
}

- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
    
    //source: http://stackoverflow.com/questions/7399343/making-a-uiimage-to-a-circle-form?rq=1
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
        
        //need better handling of this token... probably need the API manager to just talk to GitHub view
        [self.sharedAPIManager useToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
