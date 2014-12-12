//
//  gitHubLogin.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "GitHubLogin.h"
#import "UIColor+HoneyPotColorPallette.h"

@interface GitHubLogin()
@end

@implementation GitHubLogin

-(instancetype)init{
    
    self = [super init];
    if (self) {
        NSLog(@"Im a thing");
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    _containerView = [[UIView alloc] init];
    _iconImageVIew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GitHub_Logo"]];
    [_iconImageVIew setContentMode:UIViewContentModeScaleAspectFit];
    
    _loginButton = [[UIButton alloc] init];
    
    [self addSubview:_containerView];
    [self.containerView addSubview:_iconImageVIew];
    [self.containerView addSubview:_loginButton];
    
    [_loginButton setUserInteractionEnabled:YES];
    [_loginButton setReversesTitleShadowWhenHighlighted:YES];
    [_loginButton setTitle:@"Login with Github" forState:UIControlStateNormal];
    [_loginButton setTitle:@"ohh you did it now..." forState:UIControlStateHighlighted];
    [_loginButton setBackgroundColor:[UIColor roosterGobbletRed]];
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [_loginButton.layer setCornerRadius:15.0];
    [_loginButton.layer setShadowColor:[UIColor roosterFeatherGreen].CGColor];
    [_loginButton.layer setShadowOffset:CGSizeMake(1, 1)];
    [_loginButton.layer setShadowRadius:1.0];
    [_loginButton.layer setShadowOpacity:1.0];
    
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.iconImageVIew setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loginButton   setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsParams = NSDictionaryOfVariableBindings(_containerView, _iconImageVIew, _loginButton);
    NSArray * containterConstraints = @[
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_containerView]-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsParams],
                                        
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_containerView]-20-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsParams]
                                        
                                        ];
    
    [self.containerView setBackgroundColor:[UIColor eggShellWhite]];
    [self addVisualConstraints:containterConstraints];

    NSArray * imageViewConstraints = @[
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_iconImageVIew]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsParams],
                                       
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_iconImageVIew(<=200.0)]-[_loginButton(==40.0)]"
                                                                               options: NSLayoutFormatAlignAllCenterX
                                                                               metrics:nil
                                                                                 views:viewsParams],
                                       [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_loginButton]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsParams]
                                       ];
    [self addVisualConstraints:imageViewConstraints];
    
    [self.loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) addVisualConstraints:(NSArray *)constraints{
    
    //--- adds each array of layout constraints --//
    for (NSArray *loCst in constraints) {
        [self addConstraints:loCst];
    }
}
-(void)addNonFormattedConstraints:(NSArray*)constraints{
    for (NSLayoutConstraint *constraint in constraints) {
        [self addConstraint:constraint];
    }
}

- (void)loginButton:(id)sender {
    NSLog(@"Yes, button pressed");
    [self.delegate didBeginLogin:^(BOOL success){
        if(success){
            
        }
    }];
}
@end
