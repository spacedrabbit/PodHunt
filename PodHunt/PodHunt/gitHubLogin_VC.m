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

static NSString *const kGitHubRedirectURL = @"gitlog://redirectedURL";

static NSString * kGitHubCode = @"";

@interface gitHubLogin_VC () <GitHubLoginDelegate>

//@property (strong, nonatomic) GitHubLogin * rootView;

@end

@implementation gitHubLogin_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GitHubLogin * rootView = [[[NSBundle mainBundle] loadNibNamed:@"gitHubLogin" owner:self options:nil] firstObject];
    [self setView:rootView];
    
    rootView.delegate = self;
    
    // notification is posted from AppDelegate.m
    [[NSNotificationCenter defaultCenter] addObserverForName:@"gitRedirect"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
    {
        if (note)
        {
            kGitHubCode = [self urlCodeParser:note.userInfo[@"url"]];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didBeginLogin{
    
    NSDictionary * requestParameters =  @{
                                            @"client_id"    : kPodHuntClientID,
                                            @"scope"        : @"admin:org",
                                            @"redirect_uri" : kGitHubRedirectURL
                                         };
    
    AFHTTPRequestSerializer * gitRequestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest * authenticationRequest = [ gitRequestSerializer requestWithMethod:@"GET"
                                                                                 URLString:kGitHubAuthURL
                                                                                parameters:requestParameters
                                                                                     error:nil
                                                   ];


    
    [[UIApplication sharedApplication] openURL:authenticationRequest.URL];
    
}

// gets the range of the code in the url, which are the last X characters
-(NSString *) urlCodeParser:(NSURL *)url
{
    NSString *  codeURL  = [url absoluteString];
    NSRange     codeRange= [codeURL rangeOfString:@"code="];
    return [codeURL substringWithRange:NSMakeRange(NSMaxRange(codeRange), codeURL.length - NSMaxRange(codeRange))];
    
}


@end
