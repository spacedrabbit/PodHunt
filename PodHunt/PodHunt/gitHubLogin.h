//
//  gitHubLogin.h
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gitHubLogin : UIView


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
-(void) setUpConstraintsForView;
- (IBAction)loginButton:(id)sender;

@end
