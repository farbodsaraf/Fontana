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

@end

@implementation FNTContextParserTest

- (void)testEmptyStringReturnsEmptyArray {
    NSArray *items = [FNTContextParser parseContext:@""];
    XCTAssertTrue(items.count == 0, @"Parsing empty string returns empty items array");
}

- (void)testStringWithOnePotentialResultReturnsOneItem {
    NSArray *items = [FNTContextParser parseContext:@":mean streets:"];
    XCTAssertTrue(items.count == 1, @"Parsing empty string returns empty items array");
    
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 0, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 13, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringInFront {
    NSArray *items = [FNTContextParser parseContext:@"Hey :mean streets:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 13, @"Parses the correct length");
}

- (void)testStringWithOnePotentialResultReturnsOneItemWithPaddedStringAround {
    NSArray *items = [FNTContextParser parseContext:@"Hey :mean streets:    "];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 13, @"Parses the correct length");
}

- (void)testStringWithTwoPotentialResults {
    NSArray *items = [FNTContextParser parseContext:@"Hey :mean streets::the godfather:"];
    FNTContextItem *item = items[0];
    XCTAssertTrue([item.query isEqualToString:@"mean streets"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 4, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 13, @"Parses the correct length");
    
    item = items[1];
    XCTAssertTrue([item.query isEqualToString:@"the godfather"], @"Parses the correct query");
    XCTAssertTrue(item.range.location == 18, @"Parses the correct location");
    XCTAssertTrue(item.range.length == 14, @"Parses the correct length");
}

@end
