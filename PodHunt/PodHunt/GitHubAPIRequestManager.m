//
//  GitHubAPIRequestManager.m
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "GitHubAPIRequestManager.h"
#import <AFNetworking/AFNetworking.h>

// -------------------  CocoaPods API Call Constants ------------------------------- //
// The API pattern is: http://metrics.cocoapods.org/api/v1/pods/PODNAME.json
static NSString * const kPodsMetrics = @"http://metrics.cocoapods.org/api/v1/pods/";
static NSString * const kPodsEndPoint = @"http://search.cocoapods.org/api/pods";
static NSString * const kPodsAcceptHeader = @"application/vnd.cocoapods.org+picky.hash.json; version=1";

// --------------------- GitHub API Call Constants ------------------------------- //
static NSString * const kGitAcceptHeader = @"application/vnd.github.v3+json";
static NSString * const kGitAPIEndPoint = @"https://api.github.com";
static NSString * const kGitPOSTJSONContentType = @"application/json";
static NSString * const kGitOAuthTokenHeader = @"Authorization: token ";// + token

static NSString * kGitHubToken = @"";

@interface GitHubAPIRequestManager()

@property (strong, nonatomic) NSString * gitHubToken;

@end

@implementation GitHubAPIRequestManager

+(instancetype)sharedManager
{
    static GitHubAPIRequestManager * _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GitHubAPIRequestManager alloc] init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"]) {
            kGitHubToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"githubToken"];
            NSLog(@"User Token Found");
        }else{
            NSLog(@"Manager Instantiated Without Token");
        }
        
    });
    return _sharedManager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)useToken:(NSString *)token{
    _gitHubToken = token;
    kGitHubToken = token;
}

-(void)getCurrentlyLoggedinUserInfo:(void (^)(NSDictionary *))info{
    
    NSOperationQueue * userQueue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest * currentUserRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                                             URLString:[NSString stringWithFormat:@"%@/user", kGitAPIEndPoint]
                                                                                            parameters:@{ @"access_token" : kGitHubToken }
                                                                                                 error:nil];
    [currentUserRequest setValue:kGitAcceptHeader forHTTPHeaderField:@"Accept"];
    AFHTTPRequestOperation * userRequest = [[AFHTTPRequestOperation alloc] initWithRequest:currentUserRequest];
    userRequest.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [userRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         info(responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"Request failed: %@", error);
         info(nil);
     }];
    
    [userQueue addOperation:userRequest];
}


@end
