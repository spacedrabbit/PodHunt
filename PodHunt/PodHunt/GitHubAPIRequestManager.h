//
//  GitHubAPIRequestManager.h
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitHubAPIRequestManager : NSObject

+(instancetype)sharedManager;
-(void)useToken:(NSString *)token;
-(void) getCurrentlyLoggedinUserInfo:(void(^)(NSDictionary *))info;

@end
