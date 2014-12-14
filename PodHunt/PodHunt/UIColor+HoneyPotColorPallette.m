//
//  UIColor+HoneyPotColorPallette.m
//
//  Created by Louis Tur on 10/24/14.
//

#import "UIColor+HoneyPotColorPallette.h"

@implementation UIColor (HoneyPotColorPallette)

+(UIColor *)colorFromHexValue:(NSString *)hexString{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    //via: http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
}

+(UIColor *)eggShellWhite{
    return [UIColor colorWithRed:1.0 green:250.0/255.0 blue:213.0/255.0 alpha:1.0];
}
+(UIColor *)eggYolkYellow{
    return [UIColor colorWithRed:255.0/255.0 green:211.0/255.0 blue:78.0/255.0 alpha:1.0];
}
+(UIColor *)cookedEggYellow{
    return [UIColor colorWithRed:219.0/255.0 green:158.0/255.0 blue:54.0/255.0 alpha:1.0];
}
+(UIColor *)roosterGobbletRed{
    return [UIColor colorWithRed:189.0/255.0 green:73.0/255.0 blue:50.0/255.0 alpha:1.0];
}
+(UIColor *)roosterFeatherGreen{
    return [UIColor colorWithRed:16.0/255.0 green:91.0/255.0 blue:99.0/255.0 alpha:1.0];
}
+(UIColor *) deepNavy{
    return [UIColor colorWithRed:26.0/255.0 green:33.0/255.0 blue:44.0/255.0 alpha:1.0];
}
+(UIColor *) seafoamGreen{
    return [UIColor colorWithRed:29.0/255.0 green:120.0/255.0 blue:114.0/255.0 alpha:1.0];
}
+(UIColor *) wiltedLettuceGreen{
    return [UIColor colorWithRed:113.0/255.0 green:176.0/255.0 blue:149.0/255.0 alpha:1.0];
}
+(UIColor *) beigerThanBeige{
    return [UIColor colorWithRed:222.0/255.0 green:219.0/255.0 blue:167.0/255.0 alpha:1.0];
}
+(UIColor *) bloodOrangeRed{
    return [UIColor colorWithRed:209/255.0 green:63/255.0 blue:50/255.0 alpha:1.0];
}
+(UIColor *) dirtyChaiBrown{
    return [UIColor colorWithRed:207/255.0 green:194.0/255.0 blue:145.0/255.0 alpha:1.0];
}
+(UIColor *) wayTooMuchMilkBrown{
    return [UIColor colorWithRed:1.0 green:246/255.0 blue:197/255.0 alpha:1.0];
}
+(UIColor *) oceanBlue{
    return [UIColor colorWithRed:161/255.0 green:232/255.0 blue:217/255.0 alpha:1.0];
}
+(UIColor *) deepOrange{
    return [UIColor colorWithRed:1.0 green:113/255.0 blue:44/255.0 alpha:1.0];
}
+(UIColor *) balancedBrown{
    return [UIColor colorWithRed:105.0/255.0 green:93/255.0 blue:70/255.0 alpha:1.0];
}

@end
