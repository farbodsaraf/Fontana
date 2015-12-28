//
//  FNTSourceToColorTransformer.m
//  Spreadit
//
//  Created by Marko Hlebar on 18/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTSourceToColorTransformer.h"
#import <UIKit/UIKit.h>

@implementation FNTSourceToColorTransformer

- (UIColor *)transformedValue:(NSString *)source {
    return [UIColor colorWithWhite:0.8 alpha:1.0];
//    
//    if ([source isEqualToString:@":imdb:"]) {
//        return [UIColor yellowColor];
//    }
//    else if ([source isEqualToString:@":spotify:"]) {
//        return [UIColor greenColor];
//    }
//    return [UIColor grayColor];
}

@end
