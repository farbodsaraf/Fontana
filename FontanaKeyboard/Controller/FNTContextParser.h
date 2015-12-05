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

@interface FNTContextParser : NSObject
+ (NSArray *)parseContext:(NSString *)context;
@end
