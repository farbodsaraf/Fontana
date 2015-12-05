//
//  FNTKeyboardViewModel.m
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardViewModel.h"
#import "FNTItem.h"
#import "FNTKeyboardItemCellModel.h"
#import "FNTGoogleSearchQuery.h"

@interface FNTKeyboardViewModel ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@property (nonatomic, strong) FNTGoogleSearchQuery *currentQuery;
@end

@implementation FNTKeyboardViewModel

- (void)updateWithContext:(NSString *)contextString
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    [self findLinks:contextString];
    self.viewModelsHandler = viewModelsHandler;
}

static NSString * const kLinkSeparator = @":";

- (void)findLinks:(NSString *)string {
    NSMutableString *linkString = [NSMutableString new];
    
    BOOL readLink = NO;
    for (NSUInteger pointer = 0; pointer < string.length; pointer++) {
        NSString *substring = [string substringWithRange:NSMakeRange(pointer, 1)];
        
        if ([substring isEqualToString:kLinkSeparator]) {
            readLink = !readLink;
            continue;
        }
        
        if (readLink) {
            [linkString appendString:substring];
        }
    }
    
    NSLog(@"%@", linkString);
    
    [self performQuery:linkString];
}

- (void)performQuery:(NSString *)queryString {
    __weak typeof(self) weakSelf = self;
    self.currentQuery = [FNTGoogleSearchQuery queryWithSearchTerm:queryString
                                                       itemsBlock:^(NSArray *items, NSError *error) {
                                                           if (!error) {
                                                               [weakSelf handleItems:items];
                                                           }
                                                       }];
}

- (void)handleItems:(NSArray *)items {
    self.items = items;
    for (FNTItem *item in items) {
        FNTKeyboardItemCellModel *cellModel = [FNTKeyboardItemCellModel viewModelWithModel:item];
        [self addChild:cellModel];
    }
    
    self.viewModelsHandler(self.children, nil);
}

@end
