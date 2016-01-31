//
//  FNTItemTest.m
//  Spreadit
//
//  Created by Marko Hlebar on 21/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNTItem.h"

@interface FNTItem (Protected)
- (NSString *)sourceFromDisplayLink:(NSString *)displayLink;
@end

@interface FNTItemTest : XCTestCase
@property (nonatomic) FNTItem *item;
@end

@implementation FNTItemTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.item = [FNTItem new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.item = nil;
}

- (void)testPossibleDisplayLinkSources {
    NSString *link = @"http://www.google.com";
    NSString *source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":google:"], @"Source should be google");
    
    link = @"http://youtu.be";
    source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":youtu:"], @"Source should be youtu");
    
    link = @"https://carm.org/who-god";
    source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":carm:"], @"Source should be carm");
    
    link = @"https://ja.m.wiktionary.org";
    source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":wiktionary:"], @"Source should be wiktionary");
    
    link = @"https://ja.m.wiktionary.akita.jp";
    source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":wiktionary:"], @"Source should be wiktionary");
    
    link = @"http://www.lyricsmode.com/lyrics/m/melanie/i_dont_eat_animals.html";
    source = [self.item sourceFromDisplayLink:link];
    XCTAssert([source isEqualToString:@":lyricsmode:"], @"Source should be lyricsmode");
}

@end
