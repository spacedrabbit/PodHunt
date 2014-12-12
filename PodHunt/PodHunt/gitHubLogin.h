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


@property (retain, nonatomic) IBOutlet UIView *containerView;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) id<GitHubLoginDelegate> delegate;


@end
