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
 *      This class does a number of things:
 *      1 - Makes the VC it's "owner" meaning that it will handle notifications for it
 *      2 - Registers itself as the notification handler for @"gitRedirect" events
 *      3 - Performs an AppDelegate rotation
 *          3.1 - Saves a reference to the current UIApplicationDelegate (AppDelegate.m)
 *          3.2 - Sets itself to the new UIApplicationDelegate
 *          3.3 - Returns delegate status to AppDelegate.m after authentication completes
 *      4 - When it receives the @"gitRedirect" notification (when control returns from 
 *          mobileSafari), it passes the userInfo dictionary to it's owner for further 
 *          processing of the access_code into a token
 *
 ***********************************************************************************/

// -- PROTOCOL -- //
@class PodHuntNotificationHandler;

@protocol PodHuntNotificationHandlerDelegate <NSObject, UIApplicationDelegate>

-(void) didReceiveCodeNotificationResponse:(NSDictionary *)noteInfo;

@end

// -- INTERFACE -- //
@interface PodHuntNotificationHandler : NSObject

@property (weak,    nonatomic)  id<PodHuntNotificationHandlerDelegate> owner;
@property (strong, nonatomic)   id<UIApplicationDelegate> applicationDelegate;
-(void) saveReferenceToAppDelegate;
-(void) assignOwnershipTo:(id<PodHuntNotificationHandlerDelegate>)owner;

@end

// -- IMPLEMENTATION -- //
@implementation PodHuntNotificationHandler
-(void) assignOwnershipTo:(id<PodHuntNotificationHandlerDelegate>) owner
{
    self.owner = owner;
    [self registerForNotifications];
    [self saveReferenceToAppDelegate];
    
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
-(void)saveReferenceToAppDelegate
{
    self.applicationDelegate = [UIApplication sharedApplication].delegate;
    [[UIApplication sharedApplication] setDelegate:(id<UIApplicationDelegate>)self]; //forgot where I saw this..
    // but I believe it means that self is definitely going to be the ApplicationDelegate, so don't worry compiler
}

// -- UIAPPLICATION DELEGATE METHOD -- //
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    NSLog(@"Handling URL");
    if ( [[url absoluteString] hasPrefix:@"gitlog"] ) {
        NSLog(@"The url: %@", url);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gitRedirect"
                                                            object:nil
                                                          userInfo:@{ @"url" : url }];
        
        [[UIApplication sharedApplication] setDelegate:self.applicationDelegate]; // reassigning to original delegate
    }
    
    return YES;
}
@end


/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/


/**********************************************************************************
 *
 *          Authentication Handler
 *
 ***********************************************************************************/
#pragma mark - Pod Auth Handler (Private Class) -
// -- CONSTANTS -- //
static NSString *const kPodHuntClientID        = @"f875979cd4ba7a025fbf";
static NSString *const kPodHuntClientSecret    = @"99819e450ce4ebb5c9790de502e4009482278633";

static NSString *const kGitHubAuthURL   = @"https://github.com/login/oauth/authorize"   ; //GET
static NSString *const kGitHubTokenURL  = @"https://github.com/login/oauth/access_token"; //POST

static NSString *const kGitHubRedirectURL = @"gitlog://redirectedURL";

static NSString * kGitHubCode = @"";
static NSString * kGitHubToken = @"";
// -- CONSTANTS -- //

// -- Interface -- //
@class PodHuntAuthenticationHandler;
@protocol PodHuntAuthenticationHandlerDelegate <NSObject>

-(void) didBeginCodeRequest:(void(^)(BOOL))sucess;
-(void)didbeginTokenRequest:(NSString *)token completion:(void (^)(BOOL))success;

@end

@interface PodHuntAuthenticationHandler : NSObject

@property   (weak, nonatomic)           id<PodHuntAuthenticationHandlerDelegate>  owner ;

-(void)     assignOwnershipTo:          (id<PodHuntAuthenticationHandlerDelegate>)owner ;
-(void)     beginGitHubAuthentication:  (void(^)(BOOL))success                          ;
-(void)     beginGitHubTokenRequest:    (void(^)(BOOL))success                          ;

-(NSString *) urlCodeParser:            (NSURL *)url;

@end

// -- Implementation -- //
@implementation PodHuntAuthenticationHandler

-(void)assignOwnershipTo:(id<PodHuntAuthenticationHandlerDelegate>)owner
{
    self.owner = owner;
}

-(void)beginGitHubAuthentication:(void (^)(BOOL))success
{
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
    
    if ([[UIApplication sharedApplication] openURL:authenticationRequest.URL])
    {
        success(YES);
    };
}

-(void)beginGitHubTokenRequest:(void (^)(BOOL))success{
    
    //    [self.authenticationHandler didBeginTokenRequest:^(BOOL success){
    //        if (success) {
    //            [[NSUserDefaults standardUserDefaults] setObject:kGitHubToken forKey:@"githubToken"];
    //            if ([[NSUserDefaults standardUserDefaults] synchronize])
    //            {
    //                NSLog(@"Github token %@ saved to NSUserDefaults", kGitHubToken);
    //                NSLog(@"Saved as: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]);
    //            }
    //        }
    //    }];
    
}

-(NSString *) urlCodeParser:(NSURL *)url
{
    NSString *  codeURL  = [url absoluteString];
    NSRange     codeRange= [codeURL rangeOfString:@"code="];
    return [codeURL substringWithRange:NSMakeRange(NSMaxRange(codeRange), codeURL.length - NSMaxRange(codeRange))];
}



@end


/*--------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------*/


/**********************************************************************************
 *
 *          Main VC
 *
 ***********************************************************************************/
#pragma mark - PodHunt Main VC -

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
    self.loginView = [[GitHubLogin alloc] init];
    [self setView:self.loginView];
    [self.loginView.loginButton addTarget:self action:@selector(didBeginCodeRequest:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - ViewController Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Authentication Handler Delegate Methods

-(void)didBeginCodeRequest:(void (^)(BOOL))sucess
{
    [self.authenticationHandler beginGitHubAuthentication:^(BOOL success) {
        if (!success) {
            NSLog(@"Application could not open URL");
        }
    }];
}
-(void)didbeginTokenRequestForAccessCode:(NSString *)accessCode completion:(void (^)(BOOL))success{
    [self.authenticationHandler beginGitHubTokenRequest:^(BOOL success){
        
    }];
}

#pragma mark - Notification Handler Delegate Methods
-(void)didReceiveCodeNotificationResponse:(NSDictionary *)noteInfo
{
    NSString * returnedGitHubCode = [self.authenticationHandler urlCodeParser:noteInfo[@"url"]];
    [self didbeginTokenRequestForAccessCode:returnedGitHubCode completion:^(BOOL success) {
        
    }];
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


@end
