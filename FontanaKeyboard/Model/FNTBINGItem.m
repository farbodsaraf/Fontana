//
//  FNTBINGItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 29/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTBINGItem.h"

@interface FNTItem (Protected)
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *snippet;

- (NSString *)sourceFromDisplayLink:(NSString *)displayLink;
@end


@implementation FNTBINGItem

- (void)loadWithDictionary:(NSDictionary *)dictionary {
    self.link = [NSURL URLWithString:dictionary[@"Url"]];
    self.snippet = dictionary[@"Description"];
    self.source = [self sourceFromDisplayLink:dictionary[@"DisplayUrl"]];
    self.title = dictionary[@"Title"];
}

@end
