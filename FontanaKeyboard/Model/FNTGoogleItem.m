//
//  FNTGoogleItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTGoogleItem.h"

@interface FNTItem (Protected)
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *thumbnailURL;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *snippet;

- (NSString *)sourceFromDisplayLink:(NSString *)displayLink;
@end

@implementation FNTGoogleItem

- (void)loadWithDictionary:(NSDictionary *)dictionary {
    self.link = [NSURL URLWithString:dictionary[@"link"]];
    self.title = [dictionary[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.thumbnailURL = [self thumbnailURLForItem:dictionary];
    self.source = [self sourceFromDisplayLink:dictionary[@"displayLink"]];
    self.snippet = dictionary[@"snippet"];
}

- (NSURL *)thumbnailURLForItem:(NSDictionary *)item {
    NSDictionary *pagemap = item[@"pagemap"];
    NSDictionary *thumb = [pagemap[@"cse_thumbnail"] firstObject];
    NSString *thumbUrlString = thumb[@"src"];
    return thumbUrlString ? [NSURL URLWithString:thumbUrlString] : nil;
}

@end
