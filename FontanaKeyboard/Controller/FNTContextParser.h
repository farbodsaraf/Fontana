//
//  FNTContextParser.h
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FNTContextItem : NSObject
@property (nonatomic, readonly) NSRange range;
@property (nonatomic, copy, readonly) NSString *query;
@end

typedef NS_ENUM(NSUInteger, FNTContextParserOptions) {
    FNTContextParserOptionsMarkup,
    FNTContextParserOptionsOptionalMarkup,
};

@interface FNTContextParser : NSObject

/**
 *  Max optional words before markup is needed. 
 *  @default 5
 */
@property (nonatomic) NSUInteger maxOptionalWordsCount;
@property (nonatomic, readonly) FNTContextParserOptions options;
- (NSArray *)parseContext:(NSString *)context;
@end
