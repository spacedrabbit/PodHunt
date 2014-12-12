//
//  gitHubLogin_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UIColor+HoneyPotColorPallette.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"

static NSString *const kPodHuntClientID        = @"f875979cd4ba7a025fbf";
static NSString *const kPodHuntClientSecret    = @"99819e450ce4ebb5c9790de502e4009482278633";

static NSString *const kGitHubAuthURL   = @"https://github.com/login/oauth/authorize"   ; //GET
static NSString *const kGitHubTokenURL  = @"https://github.com/login/oauth/access_token"; //POST

@interface gitHubLogin_VC () <GitHubLoginDelegate>

//@property (strong, nonatomic) GitHubLogin * rootView;

@end

@implementation gitHubLogin_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    GitHubLogin * rootView = [[[NSBundle mainBundle] loadNibNamed:@"gitHubLogin" owner:self options:nil] firstObject];
    [self setView:rootView];
    
    rootView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)didBeginLogin:(void (^)(BOOL))completion{
    NSLog(@"Did it begin");
    NSDictionary * loginParameters = @{ @"client_id"    : kPodHuntClientID,
                                        @"redirect_uri" : @"gitLog",
                                            @"scope"   : @"admin:org",
                                       };

    AFHTTPSessionManager * authenticationManager = [AFHTTPSessionManager manager];
    authenticationManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSURLSessionDataTask * authTask = [authenticationManager GET:kGitHubAuthURL
                                                      parameters:loginParameters
                                                         success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
    }
                                                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                             NSLog(@"The error: %@", error);
    }];
    [authTask resume];

    
}


@end
