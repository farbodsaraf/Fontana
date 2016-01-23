//
//  FNTItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTItem.h"

@interface FNTItem ()
@property (nonatomic, copy) NSDictionary *dictionary;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *snippet;
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
    displayLink = [displayLink stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    displayLink = [displayLink stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    
    NSArray *components = [displayLink componentsSeparatedByString:@"."];
    if (components.count >= 2) {
        NSString *source = components[components.count - 2];
        return [NSString stringWithFormat:@":%@:", source];
    }
    
    return @":unknown:";
}

@end
