//
//  FNTKeyboardViewModelTest.m
//  Spreadit
//
//  Created by Marko Hlebar on 05/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNTKeyboardViewModel.h"
#import "FNTFakeKeyboardProxy.h"

@interface FNTKeyboardViewModelTest : XCTestCase
@property (nonatomic, strong) FNTKeyboardViewModel *viewModel;
@property (nonatomic, strong) NSArray *viewModels;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) FNTFakeKeyboardProxy *keyboardProxy;
@end

@implementation FNTKeyboardViewModelTest

- (void)setUp {
    [super setUp];

    self.viewModel = [FNTKeyboardViewModel new];
    self.keyboardProxy = [FNTFakeKeyboardProxy new];

    __weak typeof(self) weakSelf = self;
    [self.viewModel updateWithContext:self.keyboardProxy
                    viewModelsHandler:^(NSArray *viewModels, NSError *error) {
        weakSelf.viewModels = viewModels;
        weakSelf.error = error;
    }];
}

- (void)tearDown {
    self.viewModel = nil;
    self.keyboardProxy = nil;
    self.viewModels = nil;
    self.error = nil;
    
    [super tearDown];
}

//- (void)testDoesntReturnsViewModelsIfProxyIsEmpty {
//    XCTAssertNil(self.viewModels, @"There should be no view models");
//    XCTAssertNotNil(self.error, @"There should be an error thrown");
//    XCTestExpectation *expectation = [[XCTestExpectation alloc] expectationWithDescription:@""];
//}

@end
