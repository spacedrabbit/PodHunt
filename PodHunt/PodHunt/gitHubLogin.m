//
//  gitHubLogin.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "gitHubLogin.h"
#import "UIColor+HoneyPotColorPallette.h"

@interface gitHubLogin()
@end

@implementation gitHubLogin

-(instancetype)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) setUpConstraintsForView{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    NSDictionary *viewsParams = NSDictionaryOfVariableBindings(_containerView, _iconImageVIew, _loginButton);
    NSArray * containterConstraints = @[
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_containerView]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:viewsParams],
                                        
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_containerView]-|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsParams]

    ];

    [self.containerView setBackgroundColor:[UIColor eggShellWhite]];
    [self addVisualConstraints:containterConstraints];
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



- (IBAction)loginButton:(id)sender {
}
@end
