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
        
        self.separatorColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsZero;
        
        self.alwaysBounceVertical = NO;
    }
    return self;
}
-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    UITableViewCell * newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basicCell"];
    newCell.backgroundColor = [UIColor clearColor];
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

-(UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section
{
    UITableViewHeaderFooterView * header = [self dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    UIFont * headerFont = [UIFont fontWithName:@"Arial" size:100.0];
    NSAttributedString * textString = [[NSAttributedString alloc] initWithString:@"Search Repos"
                                                                     attributes:@{ NSFontAttributeName: headerFont,
                                                                                   NSForegroundColorAttributeName : [UIColor deepOrange],
                                                                                }];
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
