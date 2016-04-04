//
//  NSString+FNTAccessors.h
//  Spreadit
//
//  Created by Marko Hlebar on 16/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FNTAccessors)
- (NSUInteger)fnt_wordCount;
- (BOOL)fnt_isEmpty;

/**
 *  Transforms a string such as michael jackson to Michael_Jackson
 *
 *  @return a string with an underscore.
 */
- (NSString *)fnt_underscoredCapitalizedString;
@end
