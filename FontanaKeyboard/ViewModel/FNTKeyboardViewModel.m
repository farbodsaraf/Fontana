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
#import "FNTBINGSearchQuery.h"
#import "FNTGoogleScraperSearchQuery.h"
#import "FNTHistoryStack.h"
#import "FNTPleaseDonateReminder.h"

static NSString *const kFNTAppGroup = @"group.com.fontanakey.app";

@interface FNTKeyboardViewModel () <FNTPleaseDonateReminderDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@property (nonatomic, strong) id <FNTSearchQuery> currentQuery;
@property (nonatomic, strong) NSArray *contextItems;
@property (nonatomic, strong) FNTContextItem *currentContextItem;
@property (nonatomic, strong) FNTHistoryStack *historyStack;
@property (nonatomic, strong) NSMutableArray *undoStack;
@property (nonatomic, strong) FNTPleaseDonateReminder *donateReminder;
@end

@implementation FNTKeyboardViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queryClass = FNTGoogleScraperSearchQuery.class;
        _historyStack = [FNTHistoryStack stackForGroup:kFNTAppGroup];
        _donateReminder = [FNTPleaseDonateReminder reminderForGroup:kFNTAppGroup];
        _donateReminder.delegate = self;
        _donateEnabled = NO;
    }
    return self;
}

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
    FNTContextParser *parser = [FNTContextParser parserWithOptions:FNTContextParserOptionsOptionalMarkup];
    self.contextItems = [parser parseContext:text];
    self.currentContextItem = [self.contextItems firstObject];
    [self performQuery:self.currentContextItem.query];
}

- (void)performQuery:(NSString *)queryString {
    if (!queryString) {
        NSError *error = [NSError errorWithDomain:@"com.fontana.keyboard"
                                             code:404
                                         userInfo:nil];
        [self handleError:error];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.currentQuery = [self.queryClass queryWithSearchTerm:queryString
                                                  itemsBlock:^(NSArray *items, NSError *error) {
                                                      if (!error) {
                                                          [weakSelf handleItems:items];
                                                      }
                                                      else {
                                                          [weakSelf handleError:error];
                                                      }
                                                  }];
    [self.donateReminder bump];
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
    BNDViewModel *itemModel = model;
    FNTItem *item = itemModel.model;
    NSString *text = [NSString stringWithFormat:@"\n%@", item.link.absoluteString];
    [self.documentProxy insertText:text];    
    [self.historyStack pushItem:item];
    [self.undoStack insertObject:text atIndex:0];
    [self raiseUndoStackDidChange];
}

- (NSMutableArray *)undoStack {
    if (!_undoStack) {
        _undoStack = [NSMutableArray new];
    }
    return _undoStack;
}

- (BOOL)isUndoEnabled {
    return self.undoStack.count > 0;
}

- (void)undo {
    if (self.undoStack.count == 0) {
        return;
    }
    
    NSString *undoText = [self.undoStack firstObject];
    [self.documentProxy fnt_deleteText:undoText];
    [self.undoStack removeObjectAtIndex:0];
    [self raiseUndoStackDidChange];
}

- (void)clear {
    [self.historyStack clear];
}

- (void)raiseUndoStackDidChange {
    [self willChangeValueForKey:@"undoEnabled"];
    [self didChangeValueForKey:@"undoEnabled"];
}

#pragma mark - FNTPleaseDonateReminderDelegate

- (void)reminderShouldRemindToDonate:(FNTPleaseDonateReminder *)reminder {
    self.donateEnabled = YES;
}

@end
