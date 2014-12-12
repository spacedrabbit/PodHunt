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
static NSString * kGitHubToken = @"";

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
            
            [self didBeginTokenRequest:^(BOOL success){
                if (success) {
                    // save token to NSUserDefaults
                    [[NSUserDefaults standardUserDefaults] setObject:kGitHubToken forKey:@"githubToken"];
                    
                    if ([[NSUserDefaults standardUserDefaults] synchronize]) {
                        NSLog(@"Github token %@ saved to NSUserDefaults", kGitHubToken);
                        NSLog(@"Saved as: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]);
                    }

                }
            }];
        }
        else{
            NSLog(@"No notification info");
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
-(void)didBeginTokenRequest:(void(^)(BOOL))success{
    
    NSDictionary * tokenParameters = @{
                                        @"client_id"        : kPodHuntClientID,
                                        @"client_secret"    : kPodHuntClientSecret,
                                        @"code"             : kGitHubCode,
                                        @"redirect_uri"     : kGitHubRedirectURL
                                       };
    
    NSMutableURLRequest * githubURLTokenRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                                URLString:kGitHubTokenURL
                                                                                               parameters:tokenParameters
                                                                                                    error:nil];
    [githubURLTokenRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"]; // this is fucking critical, apparently
    // otherwise you just get a bunch of xml request issues
    AFURLSessionManager * sessionManager = [[AFURLSessionManager alloc] init];
    NSURLSessionDataTask * task = [sessionManager  dataTaskWithRequest:githubURLTokenRequest
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
    {
        if (!error)
        {
            NSLog(@"Token recovered");
            kGitHubToken = [responseObject objectForKey:@"access_token"];
            NSLog(@"The token: %@", kGitHubToken);
            
            success(YES);
        }
        else
        {
            NSLog(@"Error encountered: %@", error);
        }
    }];
    [task resume];
    
}

// gets the range of the code in the url, which are the last X characters
-(NSString *) urlCodeParser:(NSURL *)url
{
    NSString *  codeURL  = [url absoluteString];
    NSRange     codeRange= [codeURL rangeOfString:@"code="];
    return [codeURL substringWithRange:NSMakeRange(NSMaxRange(codeRange), codeURL.length - NSMaxRange(codeRange))];
}


@end
