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

#pragma mark - Pod Notification Handler (Private Class) -
/**********************************************************************************
 *
 *          Private classes, no biggie
 *
 ***********************************************************************************/

// -- PROTOCOL -- //
@class PodHuntNotificationHandler;
@protocol PodHuntNotificationHandlerDelegate <NSObject>
    -(void) didReceiveCodeNotificationResponse:(NSDictionary *)noteInfo;
@end

// -- INTERFACE -- //
@interface PodHuntNotificationHandler : NSObject
    @property (weak, nonatomic) id<PodHuntNotificationHandlerDelegate> owner;
    -(void) assignOwnershipTo:(id<PodHuntNotificationHandlerDelegate>)owner;
@end

// -- IMPLEMENTATION -- //
@implementation PodHuntNotificationHandler
-(void) assignOwnershipTo:(id<PodHuntNotificationHandlerDelegate>) owner
{
    self.owner = owner;
    [self registerForNotifications];
}
-(void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"gitRedirect"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification)
     {
         if (notification)
        {
            [self.owner didReceiveCodeNotificationResponse:notification.userInfo];
        }
         else{
             NSLog(@"Error getting back a notification");
         }
     }];
}
@end

#pragma mark - Pod Auth Handler (Private Class) -
/**********************************************************************************
 *
 *          Private classes, no biggie
 *
 ***********************************************************************************/
// -- Interface -- //
@class PodHuntAuthenticationHandler;
@protocol PodHuntAuthenticationHandlerDelegate <NSObject>
-(void) didBeginCodeRequest:(void(^)(BOOL))sucess;
-(void) didbeginTokenRequest:(void(^)(BOOL))success;
@end

@interface PodHuntAuthenticationHandler : NSObject

@property (weak, nonatomic) id<PodHuntAuthenticationHandlerDelegate> owner;
-(void) assignOwnershipTo:(id<PodHuntAuthenticationHandlerDelegate>) owner;
@end

// -- Implementation -- //
@implementation PodHuntAuthenticationHandler

-(void)assignOwnershipTo:(id<PodHuntAuthenticationHandlerDelegate>)owner{
    self.owner = owner;
}

@end


#pragma mark - PodHunt Main VC -

/**********************************************************************************
 *
 *          Main VC
 *
 ***********************************************************************************/

// -- CONSTANTS -- //
static NSString *const kPodHuntClientID        = @"f875979cd4ba7a025fbf";
static NSString *const kPodHuntClientSecret    = @"99819e450ce4ebb5c9790de502e4009482278633";

static NSString *const kGitHubAuthURL   = @"https://github.com/login/oauth/authorize"   ; //GET
static NSString *const kGitHubTokenURL  = @"https://github.com/login/oauth/access_token"; //POST

static NSString *const kGitHubRedirectURL = @"gitlog://redirectedURL";

static NSString * kGitHubCode = @"";
static NSString * kGitHubToken = @"";
// -- CONSTANTS -- //


@interface gitHubLogin_VC () <PodHuntNotificationHandlerDelegate, PodHuntAuthenticationHandlerDelegate>

@property (strong, nonatomic) PodHuntNotificationHandler    * notificationHandler;
@property (strong, nonatomic) PodHuntAuthenticationHandler  * authenticationHandler;
@property (strong, nonatomic) GitHubLogin                   * loginView;

@end

@implementation gitHubLogin_VC

-(instancetype)init
{
    self = [super init];
    if (self) {
        _notificationHandler = [PodHuntNotificationHandler new];
        [_notificationHandler assignOwnershipTo:self];
        
        _authenticationHandler = [PodHuntAuthenticationHandler new];
        [_authenticationHandler assignOwnershipTo:self];
    }
    return self;
}

-(void)loadView
{
    //self.loginView = [[[NSBundle mainBundle] loadNibNamed:@"gitHubLogin" owner:self options:nil] firstObject];
    self.loginView = [[GitHubLogin alloc] init];
    [self setView:self.loginView];
    [self.loginView.loginButton addTarget:self action:@selector(didBeginLogin) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ViewController Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Authentication Handler Delegate Methods -

-(void)didBeginCodeRequest:(void (^)(BOOL))sucess{
    
}
-(void)didbeginTokenRequest:(void (^)(BOOL))success{
    
}

#pragma mark - Notification Handler Delegate Methods -
-(void)didReceiveCodeNotificationResponse:(NSDictionary *)noteInfo
{
    kGitHubCode = [self urlCodeParser:noteInfo[@"url"]];
    [self didBeginTokenRequest:^(BOOL success){
        if (success) {
            [[NSUserDefaults standardUserDefaults] setObject:kGitHubToken forKey:@"githubToken"];
            if ([[NSUserDefaults standardUserDefaults] synchronize])
            {
                NSLog(@"Github token %@ saved to NSUserDefaults", kGitHubToken);
                NSLog(@"Saved as: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]);
            }
        }
    }];
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
