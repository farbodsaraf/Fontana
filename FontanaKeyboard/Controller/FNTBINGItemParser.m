//
//  FNTBINGItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTBINGItemParser.h"
#import "FNTBINGItem.h"

@implementation FNTBINGItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError **)error {
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    NSArray *results = JSON[@"d"][@"results"];
    NSMutableArray *items = [NSMutableArray new];
    for (NSDictionary *dictionary in results) {
        FNTBINGItem *item = [[FNTBINGItem alloc] initWithDictionary:dictionary];
        [items addObject:item];
    }
    
    return items.copy;
}

@end
