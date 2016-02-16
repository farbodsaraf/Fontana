//
//  FNTStringMarkupTransformerTests.m
//  Spreadit
//
//  Created by Marko Hlebar on 16/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNTStringMarkupTransformer.h"

@interface FNTStringMarkupTransformerTests : XCTestCase
@property (nonatomic, strong) FNTStringMarkupTransformer *transformer;
@end

@implementation FNTStringMarkupTransformerTests

- (void)setUp {
    [super setUp];
    
    self.transformer = (FNTStringMarkupTransformer *)[NSValueTransformer valueTransformerForName:@"FNTStringMarkupTransformer"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testTransformsNormalStrings {
    NSString *transformedString = [self.transformer transformedValue:@"Madonna"];
    XCTAssertEqualObjects(transformedString, @":Madonna:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@"Michael Jackson"];
    XCTAssertEqualObjects(transformedString, @":Michael Jackson:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@" Michael Jackson"];
    XCTAssertEqualObjects(transformedString, @":Michael Jackson:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@" Michael Jackson "];
    XCTAssertEqualObjects(transformedString, @":Michael Jackson:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@":Michael Jackson "];
    XCTAssertEqualObjects(transformedString, @":Michael Jackson:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@":Michael Jackson:"];
    XCTAssertEqualObjects(transformedString, @":Michael Jackson:", @"Should transform normal string");
    
    transformedString = [self.transformer transformedValue:@"Madonna and Michael Jackson cool"];
    XCTAssertEqualObjects(transformedString, @":Madonna and Michael Jackson cool:", @"Should transform normal string");
}

- (void)testSentenceStrings {
    NSString *transformedString = [self.transformer transformedValue:@"Yo check :Madonna:"];
    XCTAssertEqualObjects(transformedString, @"Yo check :Madonna:", @"Should not transform transformed string");
    
    transformedString = [self.transformer transformedValue:@":Madonna: yo check"];
    XCTAssertEqualObjects(transformedString, @":Madonna: yo check", @"Should not transform transformed string");
    
    transformedString = [self.transformer transformedValue:@"Yo :Madonna: check"];
    XCTAssertEqualObjects(transformedString, @"Yo :Madonna: check", @"Should not transform transformed string");

    transformedString = [self.transformer transformedValue:@"Yo check out this chick : Madonna :"];
    XCTAssertEqualObjects(transformedString, @"Yo check out this chick : Madonna :", @"Should not transform transformed string");
}

- (void)testStringsThatAreLongWithNoMarkup {
    NSString *transformedString = [self.transformer transformedValue:@"Yo check Madonna and other stuff"];
    XCTAssertEqualObjects(transformedString, @"Yo check Madonna and other stuff", @"Should not transform long string");
}

@end
