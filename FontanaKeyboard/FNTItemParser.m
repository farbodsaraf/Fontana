//
//  FNTItemParser.m
//  Spreadit
//
//  Created by Marko Hlebar on 23/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTItemParser.h"
#import "FNTItem.h"

@implementation FNTItemParser

+ (NSArray *)parseData:(NSData *)data error:(NSError **)error {
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    NSArray *items = JSON[@"items"];
    NSMutableArray *serializedItems = [NSMutableArray new];
    for (NSDictionary *item in items) {
        FNTItem *serializedItem = [[FNTItem alloc] initWithDictionary:item];
        [serializedItems addObject:serializedItem];
    }
    return serializedItems.copy;
}

@end
