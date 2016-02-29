//
//  FNTAttributedLabel.m
//  Spreadit
//
//  Created by Marko Hlebar on 19/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTAttributedLabel.h"
#import "UIColor+FNTGenerator.h"

@implementation FNTAttributedLabel

- (NSDictionary *)activeLinkAttributes {
    return @{
             NSForegroundColorAttributeName: UIColor.fnt_yellow,
             NSUnderlineStyleAttributeName: @(YES),
             };
}

- (NSDictionary *)linkAttributes {
    return @{
             NSForegroundColorAttributeName: [UIColor fnt_teal],
             NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
             };
}

@end
