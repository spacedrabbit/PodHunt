//
//  UserSplashPage.m
//  PodHunt
//
//  Created by Louis Tur on 12/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "UserSplashPage.h"

@interface UserSplashPage ()

@property (strong, nonatomic) UIView * baseView;

@property (strong, nonatomic) UIScrollView * starredRepoView;
@property (strong, nonatomic) UIScrollView * forkedRepoView;

@end

@implementation UserSplashPage

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        _baseView = [[UIView alloc] init];
        [self addSubview:_baseView];
        
    }
    return self;
    
}

-(void)layoutSubviews{
    
    CGRect parentViewFrame      = self.frame;
    CGSize profileViewBounds    = CGSizeMake(parentViewFrame.size.width, fabs(parentViewFrame.size.height/3.0));
    CGSize profileImageBounds   = CGSizeMake( fabs(profileViewBounds.width / 2.5 ) , profileViewBounds.height);
    
    self.profileView        = [[UIView       alloc] init];
    self.forkedRepoView     = [[UIScrollView alloc] init];
    self.starredRepoView    = [[UIScrollView alloc] init];
    self.starredTable       = [[UITableView  alloc] init];
    self.forkedTable        = [[UITableView  alloc] init];
    self.profileImage       = [[UIImageView  alloc] init];
    
    [self.baseView          setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.profileView       setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.forkedRepoView    setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.starredRepoView   setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.profileImage      setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.baseView          addSubview: self.profileView    ];
    [self.baseView          addSubview: self.starredRepoView];
    [self.baseView          addSubview: self.forkedRepoView ];
    [self.profileView       addSubview: self.profileImage   ];
    [self.forkedRepoView    addSubview: self.forkedTable    ];
    [self.starredRepoView   addSubview: self.starredTable   ];
    
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFit];
    
    //[self.profileImage      setBackgroundColor: [UIColor orangeColor]];
    //[self.profileView       setBackgroundColor: [UIColor purpleColor]];
    //[self.starredRepoView   setBackgroundColor: [UIColor blueColor  ]];
    
    NSArray * baseViewConstraints = @[  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_baseView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_baseView)],
                                        [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_baseView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:NSDictionaryOfVariableBindings(_baseView)]
                                      ];
    NSArray * profileViewConstraints = @[   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_profileView]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_profileView)],
                                            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_profileView(==height)]"
                                                                                    options:0
                                                                                    metrics:@{
                                                                                              @"height" : [NSNumber numberWithFloat:profileViewBounds.height] }
                                                                                      views:NSDictionaryOfVariableBindings(_profileView)]
                                         ];
    NSArray * scrollViewConstraints = @[    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_forkedRepoView]-[_starredRepoView]-|"
                                                                                    options:NSLayoutFormatDirectionLeftToRight
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_forkedRepoView,_starredRepoView)],
                                            [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_profileView]-[_forkedRepoView]-[_starredRepoView]-|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_profileView, _forkedRepoView,_starredRepoView)]
                                            ];
    NSArray * profileImageConstraints = @[ [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_profileImage(==width)]"
                                                                                   options:0
                                                                                   metrics:@{ @"width" : [NSNumber numberWithFloat: profileImageBounds.width] }
                                                                                     views:NSDictionaryOfVariableBindings(_profileImage)],
                                           [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_profileImage]-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(_profileImage)]
                                          ];
    [self addVisualConstraints:baseViewConstraints];
    [self addVisualConstraints:profileViewConstraints];
    [self addVisualConstraints:scrollViewConstraints];
    [self addVisualConstraints:profileImageConstraints];
    
}

// -- Autolayout helpers -- //
-(void) addVisualConstraints:(NSArray *)constraints
{
    //--- adds each array of layout constraints --//
    for (NSArray *loCst in constraints) {
        [self addConstraints:loCst];
    }
}
@end
