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
// specifically, the notification of the call back from mobileSafari
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
 *      This class is involved in all aspects of the Authentication process.
 *      - Defines a protocol to let its delegate know of important events
 *          - Code authorization began
 *          - Token Request began
 *      - It has an owner, similar to the notification handler
 *      - It handles the authentication process in it's implementation
 *          - Begins authentication request
 *          - Begins token request after authentication is completed
 *
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
-(void) didbeginTokenRequestForAccessCode:(NSString *)accessCode completion:(void (^)(BOOL))success;

@end

@interface PodHuntAuthenticationHandler : NSObject

@property   (weak,  nonatomic)           id<PodHuntAuthenticationHandlerDelegate>  owner ;
@property   (       nonatomic)           BOOL shouldSaveTokenInUserDefaults;

-(void)     assignOwnershipTo:          (id<PodHuntAuthenticationHandlerDelegate>)owner ;
-(void)     beginGitHubAuthentication:  (void(^)(BOOL))success                          ;
-(void)     beginGitHubTokenRequestForAccessCode:(NSString *)accessCode completion:(void (^)(BOOL, NSString *))success;

-(BOOL)         saveToken       :   (NSString *)token;
-(NSString *)   urlCodeParser   :   (NSURL *)url;

@end

// -- Implementation -- //
@implementation PodHuntAuthenticationHandler

// -- Assigning delegate status -- //
-(void)assignOwnershipTo:(id<PodHuntAuthenticationHandlerDelegate>)owner
{
    self.owner = owner;
    self.shouldSaveTokenInUserDefaults = YES; // make no if no saving is needed
}

// -- GET request to GitHub with basic URL parameters -- //
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
    [[UIApplication sharedApplication] openURL:authenticationRequest.URL];
}

// -- POST request to get a token. -- This method is called by the delegate after success on access_code request -- //
-(void)beginGitHubTokenRequestForAccessCode:(NSString *)accessCode completion:(void (^)(BOOL, NSString *))success{
    
    kGitHubCode = accessCode;
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
    [githubURLTokenRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // this is fucking critical, apparently
    // otherwise you just get a bunch of xml request issues
    
    AFURLSessionManager * sessionManager = [[AFURLSessionManager alloc] init];
    NSURLSessionDataTask * task = [sessionManager  dataTaskWithRequest:githubURLTokenRequest
                                                     completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                   {
                                       if (!error)
                                       {
                                           if ([responseObject objectForKey:@"access_token"])
                                           {
                                               // -- Good response returns us JSON with an "access_token" -- //
                                               kGitHubToken = [responseObject objectForKey:@"access_token"];
                                               NSLog(@"Token successfully issued: %@", kGitHubToken);
                                               
                                               // -- this bubbles back up to the delegate, who called this method -- //
                                               success(YES, kGitHubToken);
                                           }
                                           else if ([responseObject objectForKey:@"error"])
                                           {
                                               // -- Bad response returns JSON with "error" key -- //
                                               NSString * errorMessage = [NSString stringWithFormat:@"There was an error: %@\n\nDescription from Git: %@\n\nURL: %@", responseObject[@"error"], responseObject[@"error_description"], responseObject[@"error_uri"]];
                                               
                                               UIAlertView * badCodeAlert = [[UIAlertView alloc] initWithTitle:@"Error Authenticating"
                                                                                                       message:errorMessage
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"Dismiss"
                                                                                             otherButtonTitles:nil];
                                               
                                               [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                   [badCodeAlert show];
                                               }];
                                               
                                           }else
                                           {
                                               NSLog(@"Something weird happened with the token request...");
                                           }
                                       }
                                       else
                                       {
                                           NSLog(@"Error encountered: %@", error);
                                           success(NO, @"Token Error");
                                       }
                                   }];
    [task resume];
}

// -- Some helpers -- //
-(NSString *) urlCodeParser:(NSURL *)url
{
    NSString *  codeURL  = [url absoluteString];
    NSRange     codeRange= [codeURL rangeOfString:@"code="];
    return [codeURL substringWithRange:NSMakeRange(NSMaxRange(codeRange), codeURL.length - NSMaxRange(codeRange))];
}
-(BOOL)saveToken:(NSString *)token
{
    if (self.shouldSaveTokenInUserDefaults)
    {
        [[NSUserDefaults standardUserDefaults] setObject:kGitHubToken forKey:@"githubToken"];
        if ([[NSUserDefaults standardUserDefaults] synchronize])
        {
            NSLog(@"Saved as: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]);
            return YES;
        }
    }
    return NO;
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
//@property (weak,   nonatomic)

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

#pragma mark - ViewController Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Authentication Handler Delegate Methods

// -- This gets call on button press -- //
-(void)didBeginCodeRequest:(void (^)(BOOL))sucess
{
    [self.authenticationHandler beginGitHubAuthentication:nil];
}

// -- Calls the Auth handler's Token request method. If the request is successful,
// -- saveToken is called to save the token in NSUserDefaults, and then this
// -- dismisses the view
-(void)didbeginTokenRequestForAccessCode:(NSString *)accessCode completion:(void (^)(BOOL))success
{
    [self.authenticationHandler beginGitHubTokenRequestForAccessCode:accessCode
                                                          completion:^(BOOL tokenRecovered, NSString * token)
    {
        if (tokenRecovered) {
            [self.authenticationHandler saveToken:token];
            [self.delegate didFinishLoggingIn]; // dismisses view
        }
    }];
}

#pragma mark - Notification Handler Delegate Methods
// -- The Notification Handler listens for the app to return from Safari, then calls this method
// -- on it's delegate. This method in turn calls didBeginTokenRequestForAccessCode of the
// -- Authentication Handler Delegate method.
-(void)didReceiveCodeNotificationResponse:(NSDictionary *)noteInfo
{
    NSString * returnedGitHubCode = [self.authenticationHandler urlCodeParser:noteInfo[@"url"]];
    [self didbeginTokenRequestForAccessCode:returnedGitHubCode completion:nil];
}

// -- MISC METHODS -- //
-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
