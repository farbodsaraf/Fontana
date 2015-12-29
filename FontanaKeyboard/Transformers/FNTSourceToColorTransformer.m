//
//  FNTSourceToColorTransformer.m
//  Spreadit
//
//  Created by Marko Hlebar on 18/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTSourceToColorTransformer.h"
#import <UIKit/UIKit.h>
#import "UIColor+FNTGenerator.h"

@interface FNTSourceToColorTransformer ()
@property (nonatomic, strong) NSMutableDictionary *sourceDictionary;
@end

@implementation FNTSourceToColorTransformer

- (UIColor *)transformedValue:(NSString *)source {
    UIColor *color = self.sourceDictionary[source];
    if (!color) {
        color = [UIColor fnt_generateColor:source];
        self.sourceDictionary[source] = color;
    }
    return color;
}

- (NSMutableDictionary *)sourceDictionary {
    if (!_sourceDictionary) {
        _sourceDictionary = [NSMutableDictionary new];
    }
    return _sourceDictionary;
}

@end
