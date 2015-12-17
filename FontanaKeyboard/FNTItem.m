//
//  FNTItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTItem.h"

@implementation FNTItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _link = [NSURL URLWithString:dictionary[@"link"]];
        _title = [dictionary[@"title"] copy];
        _thumbnailURL = [self thumbnailURLForItem:dictionary];
        _source = [self sourceFromDisplayLink:dictionary[@"displayLink"]];
        _snippet = dictionary[@"snippet"];
    }
    return self;
}

- (NSURL *)thumbnailURLForItem:(NSDictionary *)item {
    NSDictionary *pagemap = item[@"pagemap"];
    NSDictionary *thumb = [pagemap[@"cse_thumbnail"] firstObject];
    NSString *thumbUrlString = thumb[@"src"];
    return thumbUrlString ? [NSURL URLWithString:thumbUrlString] : nil;
}

- (NSString *)sourceFromDisplayLink:(NSString *)displayLink {
    NSArray *components = [displayLink componentsSeparatedByString:@"."];
    if (components.count >= 2) {
        return [NSString stringWithFormat:@":%@:", components[1]];
    }
    return @":unknown:";
}

@end
