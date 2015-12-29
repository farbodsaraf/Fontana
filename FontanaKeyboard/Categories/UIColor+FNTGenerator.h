//
//  UIColor+FNTGenerator.h
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FNTGenerator)
+ (UIColor *)fnt_generateColor:(NSString *)identifier;
+ (UIColor *)fnt_teal;
+ (UIColor *)fnt_tealLowerAlpha;

+ (UIColor *)fnt_lightTeal;
@end
