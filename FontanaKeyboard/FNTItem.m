//
//  FNTItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTItem.h"
#import "NSURL+FNTBaseURL.h"

@interface FNTItem ()
@property (nonatomic, copy) NSDictionary *dictionary;
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *thumbnailURL;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *snippet;
@property (nonatomic, copy) NSURL *faviconURL;
@end

NSString *const kFNTItemDictionary = @"kFNTItemDictionary";

@implementation FNTItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _dictionary = dictionary.copy;
        [self loadWithDictionary:dictionary];
    }
    return self;
}

- (void)loadWithDictionary:(NSDictionary *)dictionary {
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    NSDictionary *dictionary = [decoder decodeObjectForKey:kFNTItemDictionary];
    return [self initWithDictionary:dictionary];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dictionary forKey:kFNTItemDictionary];
}

- (NSString *)sourceFromDisplayLink:(NSString *)displayLink {
    NSURL *link = [NSURL URLWithString:displayLink];
    return [NSString stringWithFormat:@":%@:", link.fnt_domainName];
}

- (NSURL *)faviconURL {
    if (!_faviconURL) {
        _faviconURL = [self.link fnt_urlByAddingPath:@"favicon.ico"];
    }
    return _faviconURL;
}

@end
