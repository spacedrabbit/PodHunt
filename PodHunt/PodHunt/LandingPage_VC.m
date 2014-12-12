//
//  LandingPage_VC.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "LandingPage_VC.h"
#import "gitHubLogin_VC.h"
#import "GitHubLogin.h"

@interface LandingPage_VC ()

- (IBAction)loginButton:(id)sender;

@end

@implementation LandingPage_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
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


- (IBAction)loginButton:(id)sender {
    
    gitHubLogin_VC * loginScreen = [[gitHubLogin_VC alloc] init];

    [self presentViewController:loginScreen animated:YES completion:^{
        NSLog(@"Done");
    }];
    
}
@end
