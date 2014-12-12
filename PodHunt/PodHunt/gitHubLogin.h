    //
//  gitHubLogin.h
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GitHubLoginDelegate <NSObject>

-(void)didBeginLogin;

@end


@interface GitHubLogin : UIView


@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIImageView *iconImageVIew;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) id<GitHubLoginDelegate> delegate;


@end
