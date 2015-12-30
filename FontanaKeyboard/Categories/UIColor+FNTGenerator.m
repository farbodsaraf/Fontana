//
//  UIColor+FNTGenerator.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "UIColor+FNTGenerator.h"

@implementation UIColor (FNTGenerator)

//Borrowed from https://github.com/kolinkrewinkel/Polychromatic/blob/master/Polychromatic/Utilities/PLYColorGeneration.m
static uint64_t FNV1aHash(NSString *stringToHash) {
    // http://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function
    const uint8_t *bytes = (uint8_t *)stringToHash.UTF8String;
    uint64_t hash = 14695981039346656037ULL;
    for (uint8_t byte = *bytes; byte != '\0'; byte = *(++bytes)) {
        hash ^= byte;
        hash *= 1099511628211ULL;
    }
    
    return hash;
}

+ (UIColor * )fnt_generateColor:(NSString *)identifier {
    NSUInteger numberOfDifferentColors = 4096;
    NSUInteger shortHashValue = FNV1aHash(identifier) % numberOfDifferentColors;
    CGFloat hueValue = (CGFloat)shortHashValue/(CGFloat)numberOfDifferentColors;
    
    return [UIColor colorWithHue:hueValue
                      saturation:0.5f
                      brightness:0.7f
                           alpha:1.f];
}

+ (UIColor *)fnt_teal {
    static UIColor *_fnt_teal = nil;
    if (!_fnt_teal) {
        _fnt_teal = [UIColor colorWithRed:0
                                    green:131./255
                                     blue:130./255
                                    alpha:1.0];
    }
    return _fnt_teal;
}

+ (UIColor *)fnt_tealLowerAlpha {
    static UIColor *_fnt_tealLowerAlpha = nil;
    if (!_fnt_tealLowerAlpha) {
        _fnt_tealLowerAlpha = [UIColor colorWithRed:80./255
                                              green:80./255
                                               blue:80./255
                                              alpha:0.8];
    }
    return _fnt_tealLowerAlpha;
}

+ (UIColor *)fnt_lightTeal {
    static UIColor *_fnt_lightTeal = nil;
    if (!_fnt_lightTeal) {
        _fnt_lightTeal = [UIColor colorWithRed:47./255
                                         green:143./255
                                          blue:140./255
                                         alpha:1.0];
    }
    return _fnt_lightTeal;
}

@end
