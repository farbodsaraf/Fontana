//
//  FNTContextParserTest.m
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNTContextParser.h"

@interface FNTContextParserTest : XCTestCase
@property (nonatomic) FNTContextParser *contextParser;
@end

@implementation FNTContextParserTest

- (void)setUp {
    [super setUp];
    
    self.contextParser = [FNTContextParser new];
}

#pragma mark - FNTContextParserOptionsMarkup

- (void)testEmptyStringReturnsEmptyArray {
    NSArray *items = [self.contextParser parseContext:@""];
    XCTAssertTrue(items.count == 0, @"Parsing empty string returns empty items array");
}

- (void)testStringWithOnePotentialResultReturnsOneItem {
    NSArray *items = [self.contextParser parseContext:@":mean streets:"];
    XCTAssertTrue(items.count == 1, @"Parsing empty string returns empty items array");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringInFront {
    NSArray *items = [self.contextParser parseContext:@"Hey :mean streets:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringAround {
    NSArray *items = [self.contextParser parseContext:@"Hey :mean streets:    "];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithTwoPotentialResults {
    NSArray *items = [self.contextParser parseContext:@"Hey :mean streets::the godfather:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
    
    item = items[1];
    XCTAssertTrue([item.query isEqualToString:@"the godfather"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 18, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 15, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithDeformedMarkupInFront {
    NSArray *items = [self.contextParser parseContext:@": mean streets:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 15, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithDeformedMarkupInBack {
    NSArray *items = [self.contextParser parseContext:@":mean streets :"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 15, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithDeformedMarkupInBoth {
    NSArray *items = [self.contextParser parseContext:@": mean streets :"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 16, @"Parses the correct length");
}

- (void)testStringWithTooManyWordsInContextReturnsNoItems {
    NSArray *items = [self.contextParser parseContext:@"mean streets are super fucking mean"];
    XCTAssertTrue(items.count == 0, @"Parsing a string with too many words returns empty items array");
}

- (void)testStringWithMarkupReturnsItems {
    NSArray *items = [self.contextParser parseContext:@":mean streets:"];
    XCTAssertTrue(items.count == 1, @"Parsing a string with too many words returns empty items array");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length"); 
}

@end
