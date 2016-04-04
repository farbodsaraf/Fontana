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
#import "FNTStringMarkupTransformer.h"
#import "FNTError.h"
#import "NSString+FNTAccessors.h"
#import "FNTBINGScraperSearchQuery.h"
#import "FNTAppTracker.h"
#import "FNTWikiItem.h"

static NSString *const kFNTDonateDeepLink = @"fontanakey://donate";
static NSString *const kFNTHelpUsageDeepLink = @"fontanakey://usage";
static NSString *const kFNTHelpInstallationDeepLink = @"fontanakey://installation";

static NSString *const kFNTAppGroup = @"group.com.fontanakey.app";

static NSString *const kFNTSearchEngineKey = @"searchEngine";
static NSString *const kFNTGoogleSearch = @"google";
static NSString *const kFNTBINGSearch = @"bing";

@interface FNTKeyboardViewModel () <FNTPleaseDonateReminderDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) BNDViewModelsBlock viewModelsHandler;
@property (nonatomic, strong) id <FNTSearchQuery> currentQuery;
@property (nonatomic, strong) NSArray *contextItems;
@property (nonatomic, strong) FNTContextItem *currentContextItem;
@property (nonatomic, strong) FNTHistoryStack *historyStack;
@property (nonatomic, strong) NSMutableArray *undoStack;
@property (nonatomic, strong) FNTPleaseDonateReminder *donateReminder;

@property (nonatomic, copy) NSString *originalText;
@property (nonatomic, copy) NSString *currentText;

@property (nonatomic, copy) NSString *currentQueryString;
@end

@implementation FNTKeyboardViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _historyStack = [FNTHistoryStack stackForGroup:kFNTAppGroup];
        _donateReminder = [FNTPleaseDonateReminder reminderForGroup:kFNTAppGroup];
        _donateReminder.delegate = self;
        _donateEnabled = NO;
    }
    return self;
}

- (Class)queryClass {
    NSString *searchEngine = [FNTAppTracker variableForKey:kFNTSearchEngineKey];
    if ([searchEngine isEqualToString:kFNTBINGSearch]) {
        return FNTBINGScraperSearchQuery.class;
    }
    else if ([searchEngine isEqualToString:kFNTGoogleSearch]) {
        return FNTGoogleScraperSearchQuery.class;
    }
    return FNTGoogleScraperSearchQuery.class;
}

- (void)updateWithContext:(NSObject <UITextDocumentProxy> *)documentProxy
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler {
    self.viewModelsHandler = viewModelsHandler;
    _documentProxy = documentProxy;
    [self findLinksInDocument:_documentProxy];
}

- (void)findLinksInDocument:(NSObject <UITextDocumentProxy> *)documentProxy {
    __weak typeof(self) weakSelf = self;
    [self.documentProxy fnt_readText:^(NSString *textBeforeCursor, NSString *textAfterCursor) {
        NSString *allText = [textBeforeCursor stringByAppendingString:textAfterCursor];
        [weakSelf handleText:allText];
    }];
}

- (void)handleText:(NSString *)text {
    if (!text || text.fnt_isEmpty) {
        NSError *error = [FNTError errorWithCode:FNTErrorCodeInvalidQuery
                                         message:@"The query string is empty."];
        [self handleError:error];
        return;
    }
    
    self.originalText = text;
    self.currentText = [self textWithMarkupText:text];
    
    if (![self.currentText isEqualToString:self.originalText]) {
        [self replaceTextWithText:self.currentText];
    }
    
    FNTContextParser *parser = [FNTContextParser new];
    self.contextItems = [parser parseContext:self.currentText];
    
    if (self.contextItems.count == 0) {
        NSError *error = [FNTError errorWithCode:FNTErrorCodeInvalidQuery
                                         message:@"No valid markup found."];
        [self handleError:error];
        return;
    }
    
    self.currentContextItem = [self.contextItems firstObject];
    [self performQuery:self.currentContextItem.query];
}

- (NSString *)textWithMarkupText:(NSString *)text {
    FNTStringMarkupTransformer *transformer = (FNTStringMarkupTransformer *)[NSValueTransformer valueTransformerForName:@"FNTStringMarkupTransformer"];
    NSString *transformedText = [transformer transformedValue:text];
    return transformedText;
}

- (void)replaceTextWithText:(NSString *)text {
    if (self.currentText) {
        [self.documentProxy fnt_deleteText:self.currentText];
    }
    
    if (text) {
        [self.documentProxy insertText:text];
    }
    
}

- (void)performQuery:(NSString *)queryString {
    self.currentQueryString = queryString;
    
    if (![self hasFullAccess]) {
        [self handleError:[self noFullAccessError]];
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

- (id)messageForQueryError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        return [self networkError];
    }
    else if(error.code == FNTErrorCodeNoFullAccess) {
        return [self fullAccessErrorText];
    }
    return self.usageTutorialText;
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
    if (self.currentQueryString) {
        NSDictionary *itemDictionary = @{
                                         @"searchTerm" : self.currentQueryString
                                         };
        FNTItem *wikiItem = [[FNTWikiItem alloc] initWithDictionary:itemDictionary];
        [self handleItems:@[wikiItem]];
    }
    else {
        self.viewModelsHandler(nil, error);
    }
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

- (void)restoreOriginalTextIfNeeded {
    if (!self.originalText) {
        return;
    }
    
    if (!self.isUndoEnabled && ![self.originalText isEqualToString:self.currentText]) {
        [self replaceTextWithText:self.originalText];
    }
}

- (void)raiseUndoStackDidChange {
    [self willChangeValueForKey:@"undoEnabled"];
    [self didChangeValueForKey:@"undoEnabled"];
}

#pragma mark - Full Access

- (BOOL)hasFullAccess {
    return !![UIPasteboard generalPasteboard];
}

- (NSError *)noFullAccessError {
    return [FNTError errorWithCode:FNTErrorCodeNoFullAccess
                           message:@"Full access not allowed"];
}

- (NSAttributedString *)fullAccessErrorText {
    return [self attributedStringWithFormat:[self fullAccessErrorFormat]
                                       link:@"Please enable Full Access to perform search."
                                    linkURL:kFNTHelpInstallationDeepLink];
}

#pragma mark - Network issues

- (NSString *)networkError {
    return @"😢 No Internet connection 😢\n\nThis keyboard requires internet connection to work.";
}

- (NSString *)fullAccessErrorFormat {
    return @"☝️ This keyboard requires full access ☝️\n\n%@\n\nFontana > More > How do I use this app?\nor tap the link above.";
}

#pragma mark - Usage tutorial text

- (NSAttributedString *)usageTutorialText {
    return [self attributedStringWithFormat:[self usageFormat]
                                       link:@"How do I use this keyboard?"
                                    linkURL:kFNTHelpUsageDeepLink];
}

- (NSString *)usageFormat {
    return @"😭 We couldn't find any results 😭\n\n%@\n\nFontana > More > How do I use this app?\nor tap the link above.";
}

#pragma mark - Donate text

- (NSAttributedString *)donateText {
    return [self attributedStringWithFormat:[self donateFormat]
                                       link:@"Please donate to remove this message."
                                    linkURL:kFNTDonateDeepLink];
}

- (NSAttributedString *)attributedStringWithFormat:(NSString *)format
                                              link:(NSString *)link
                                           linkURL:(NSString *)linkURL {
    NSString *string = [NSString stringWithFormat:format, link];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]
                       range:NSMakeRange(0, string.length)];
    
    NSRange linkRange = [string rangeOfString:link];
    [attrString addAttribute:NSLinkAttributeName
                       value:linkURL
                       range:linkRange];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16]
                       range:linkRange];
    
    [attrString endEditing];
    
    return attrString.copy;
}

- (NSString *)donateFormat {
    return @"😴 We wake up early to save your time 😴\n\n%@\n\nFontana > More\nor tap the link above.";
}

- (NSArray *)randomTerms {
    return @[
             @"Michael Jackson",
             @"Godzilla",
             @"Godfather",
             @"Madonna",
             @"Cry me a river"
             ];
}

#pragma mark - FNTPleaseDonateReminderDelegate

- (void)reminderShouldRemindToDonate:(FNTPleaseDonateReminder *)reminder {
    self.donateEnabled = YES;
}

@end
