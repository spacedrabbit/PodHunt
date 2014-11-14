//
//  gitHubLogin_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UIColor+HoneyPotColorPallette.h"
#import "gitHubLogin_VC.h"
#import "gitHubLogin.h"

@interface gitHubLogin_VC ()

@end

@implementation gitHubLogin_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * nibs = [[NSBundle mainBundle] loadNibNamed:@"gitHubLogin"
                                                   owner:self
                                                 options:nil];
    gitHubLogin *loginView = [nibs firstObject];
    [loginView setFrame:self.view.bounds];
    NSLog(@"Frame: %@", loginView.containerView);
    //[loginView setUpConstraintsForView];
    [self setView:loginView];
    [self.view setBackgroundColor:[UIColor eggYolkYellow]];

    NSLog(@"In the VC");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
