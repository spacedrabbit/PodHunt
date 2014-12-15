//
//  HamburgerView.m
//  PodHunt
//
//  Created by Louis Tur on 12/15/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import "HamburgerView.h"
#import "UIColor+HoneyPotColorPallette.h"

@interface HamburgerView ()

@end

@implementation HamburgerView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _basicCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basicCell"];
        [_basicCell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        self.separatorColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsZero;
        
        _headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
    }
    return self;
}
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    UITableViewCell * newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basicCell"];
    return newCell;
}
-(NSInteger)numberOfSections{
    return 2;
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)rowHeight{
    return 34.0;
}
-(id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier{
    return [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
}

-(UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section{

    
    UITableViewHeaderFooterView * header = [self dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    UIFont * headerFont = [UIFont fontWithName:@"Avenir" size:24.0];
    NSAttributedString * textString = [[NSAttributedString alloc] initWithString:@"Search Repos"
                                                                     attributes:@{ NSFontAttributeName: headerFont,
                                                                                   NSForegroundColorAttributeName : [UIColor deepOrange],
                                                                                }];
    [header setLayoutMargins:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    if (section == 0) {
        header.textLabel.attributedText = textString;
    }
    else if (section == 1){
        header.textLabel.attributedText = textString;
    }
    
    return header;
}
-(CGFloat)sectionHeaderHeight{
    return 44.0;
}
@end
