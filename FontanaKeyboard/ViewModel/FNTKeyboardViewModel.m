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
#import "FNTContextParser.h"
#import "NSObject+FNTTextDocumentProxyAdditions.h"

@interface FNTKeyboardViewModel ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@property (nonatomic, strong) FNTGoogleSearchQuery *currentQuery;
@property (nonatomic, strong) NSArray *contextItems;
@property (nonatomic, strong) FNTContextItem *currentContextItem;
@end

@implementation FNTKeyboardViewModel

- (void)updateWithContext:(NSObject <UITextDocumentProxy> *)documentProxy
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    _documentProxy = documentProxy;
    
    [self findLinksInDocument:_documentProxy];
    self.viewModelsHandler = viewModelsHandler;
}

- (void)findLinksInDocument:(NSObject <UITextDocumentProxy> *)documentProxy {
    __weak typeof(self) weakSelf = self;
    [self.documentProxy fnt_readText:^(NSString *textBeforeCursor, NSString *textAfterCursor) {
        NSString *allText = [textBeforeCursor stringByAppendingString:textAfterCursor];
        [weakSelf handleText:allText];
    }];
}

- (void)handleText:(NSString *)text {
    self.contextItems = [FNTContextParser parseContext:text];
    self.currentContextItem = [self.contextItems firstObject];
    [self performQuery:self.currentContextItem.query];
}

- (void)performQuery:(NSString *)queryString {
    if (!queryString) {
        NSError *error = [NSError errorWithDomain:@"com.fontana.keyboard"
                                             code:404
                                         userInfo:nil];
        [self handleError:error];
    }
    
    __weak typeof(self) weakSelf = self;
    self.currentQuery = [FNTGoogleSearchQuery queryWithSearchTerm:queryString
                                                       itemsBlock:^(NSArray *items, NSError *error) {
                                                           if (!error) {
                                                               [weakSelf handleItems:items];
                                                           }
                                                           else {
                                                               [weakSelf handleError:error];
                                                           }
                                                       }];
}

- (void)handleItems:(NSArray *)items{
    self.items = items;
    for (FNTItem *item in items) {
        FNTKeyboardItemCellModel *cellModel = [FNTKeyboardItemCellModel viewModelWithModel:item];
        [self addChild:cellModel];
    }
    
    self.viewModelsHandler(self.children, nil);
}

- (void)handleError:(NSError *)error {
    self.viewModelsHandler(nil, error);
}

- (void)apply:(FNTKeyboardItemCellModel *)model {
    
}

- (void)nextContextItem {
    
}

@end
