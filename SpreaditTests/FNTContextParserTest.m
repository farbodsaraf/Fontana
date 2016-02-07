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

#pragma mark - FNTContextParserOptionsMarkup

- (void)testEmptyStringReturnsEmptyArray {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@""];
    XCTAssertTrue(items.count == 0, @"Parsing empty string returns empty items array");
}

- (void)testStringWithOnePotentialResultReturnsOneItem {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@":mean streets:"];
    XCTAssertTrue(items.count == 1, @"Parsing empty string returns empty items array");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringInFront {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@"Hey :mean streets:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringAround {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@"Hey :mean streets:    "];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

- (void)testStringWithTwoPotentialResults {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
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
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@": mean streets:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 15, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithDeformedMarkupInBack {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@":mean streets :"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 15, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithDeformedMarkupInBoth {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsMarkup];
    NSArray *items = [self.contextParser parseContext:@": mean streets :"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 16, @"Parses the correct length");
}

#pragma mark - FNTContextParserOptionsOptionalMarkup

- (void)testEmptyStringReturnsEmptyArrayOptional {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    NSArray *items = [self.contextParser parseContext:@""];
    XCTAssertTrue(items.count == 0, @"Parsing empty string returns empty items array");
}

- (void)testStringWithOnePotentialResultReturnsOneItemOptional {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    NSArray *items = [self.contextParser parseContext:@"mean streets"];
    XCTAssertTrue(items.count == 1, @"Parsing a string with one result returns one item");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 12, @"Parses the correct length");
}

- (void)testStringWithMaxWordsInContextReturnsContext {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    NSArray *items = [self.contextParser parseContext:@"mean streets are super mean"];
    XCTAssertTrue(items.count == 1, @"Parsing a string with max words returns an item");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets are super mean"], @"Parses the correct query");
}

- (void)testStringWithTooManyWordsInContextReturnsNoItems {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    NSArray *items = [self.contextParser parseContext:@"mean streets are super fucking mean"];
    XCTAssertTrue(items.count == 0, @"Parsing a string with too many words returns empty items array");
}

- (void)testStringWithMarkupReturnsItems {
    self.contextParser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    NSArray *items = [self.contextParser parseContext:@":mean streets:"];
    XCTAssertTrue(items.count == 1, @"Parsing a string with too many words returns empty items array");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length"); 
}

@end
