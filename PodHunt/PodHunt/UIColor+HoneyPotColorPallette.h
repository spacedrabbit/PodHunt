//
//  UIColor+HoneyPotColorPallette.h
//
//  Created by Louis Tur on 10/24/14.
//

#import <UIKit/UIKit.h>

@interface UIColor (HoneyPotColorPallette)

// -- Honey Pot -- //
+(UIColor *) eggShellWhite;
+(UIColor *) eggYolkYellow;
+(UIColor *) cookedEggYellow;
+(UIColor *) roosterGobbletRed;
+(UIColor *) roosterFeatherGreen;

// -- Deminc -- //
+(UIColor *) deepNavy;
+(UIColor *) seafoamGreen;
+(UIColor *) wiltedLettuceGreen;
+(UIColor *) beigerThanBeige;
+(UIColor *) bloodOrangeRed;

// -- Afternoon Chai -- //
+(UIColor *) dirtyChaiBrown;
+(UIColor *) wayTooMuchMilkBrown;
+(UIColor *) oceanBlue;
+(UIColor *) deepOrange;
+(UIColor *) balancedBrown;

// -- Hex Converter -- //
+(UIColor *) colorFromHexValue:(NSString *)hexString;

@end
