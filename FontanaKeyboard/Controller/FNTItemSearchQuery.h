//
//  FNTItemSearchQuery.h
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FNTSearchQuery.h"

@interface FNTItemSearchQuery : NSObject <FNTSearchQuery>
@property (nonatomic, copy, readonly) FNTItemResultBlock itemsBlock;
@property (nonatomic, copy, readonly) NSString *searchTerm;

- (instancetype)initWithSearchTerm:(NSString *)searchTerm
                        itemsBlock:(FNTItemResultBlock)itemsBlock;
//- (void)handleData:(NSData *)data;
- (void)handleData:(NSData *)data error:(NSError *)error;
@end
