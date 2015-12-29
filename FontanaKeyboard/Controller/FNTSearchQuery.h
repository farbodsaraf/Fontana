//
//  FNTSearchQuery.h
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FNTItemResultBlock)(NSArray *, NSError *);

@protocol FNTSearchQuery <NSObject>
+ (instancetype)queryWithSearchTerm:(NSString *)searchTerm
                         itemsBlock:(FNTItemResultBlock)itemsBlock;
- (NSString *)searchURLFormat;
- (Class)parserClass;
@end
