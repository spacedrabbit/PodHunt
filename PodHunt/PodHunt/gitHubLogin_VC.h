//
//  gitHubLogin_VC.h
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GitHubLoginViewControllerDelegate <NSObject>

-(void) didFinishLoggingIn;

@end

@interface gitHubLogin_VC : UIViewController

@property (weak, nonatomic) id<GitHubLoginViewControllerDelegate> delegate;

@end
