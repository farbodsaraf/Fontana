//
//  FNTWikiItem.m
//  Spreadit
//
//  Created by Marko Hlebar on 04/04/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import "FNTWikiItem.h"
#import "NSString+FNTAccessors.h"

NSString * const kFNTWikiItemURLFormat = @"https://en.wikipedia.org/wiki/%@";
NSString * const kFNTWikiItemTitleFormat = @"%@ - Wikipedia, the free encyclopedia";
NSString * const kFNTWikiSearchTermKey = @"searchTerm";

@interface FNTItem (Protected)
@property (nonatomic, copy) NSURL *link;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSURL *faviconURL;
@end

@implementation FNTWikiItem

- (void)loadWithDictionary:(NSDictionary *)dictionary {
    NSString *searchTerm = dictionary[kFNTWikiSearchTermKey];
    NSParameterAssert(searchTerm);
    NSString *linkString = [NSString stringWithFormat:kFNTWikiItemURLFormat, [searchTerm fnt_underscoredCapitalizedString]];
    self.link = [NSURL URLWithString:linkString];
    self.title = [NSString stringWithFormat:kFNTWikiItemTitleFormat, [searchTerm capitalizedString]];
    self.source = @":wikipedia:";
    self.faviconURL = [[NSBundle mainBundle] URLForResource:@"wikipedia" withExtension:@"ico"];
}

@end
