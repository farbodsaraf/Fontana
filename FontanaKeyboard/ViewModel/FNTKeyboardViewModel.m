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

static NSString *const kFNTDonateDeepLink = @"fontanakey://donate";
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
@property (nonatomic, strong) NSString *usageTutorialText;
@end

@implementation FNTKeyboardViewModel

- (instancetype)init {
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
    if (!text || text.fnt_isEmpty) {
        NSError *error = [FNTError errorWithCode:FNTErrorCodeInvalidQuery
                                         message:@"The query string is empty."];
        [self handleError:error];
        return;
    }
    
    NSString *transformedText = [self replaceTextWithMarkupText:text];
    FNTContextParser *parser = [FNTContextParser new];
    self.contextItems = [parser parseContext:transformedText];
    self.currentContextItem = [self.contextItems firstObject];
    [self performQuery:self.currentContextItem.query];
}

- (NSString *)replaceTextWithMarkupText:(NSString *)text {
    FNTStringMarkupTransformer *transformer = (FNTStringMarkupTransformer *)[NSValueTransformer valueTransformerForName:@"FNTStringMarkupTransformer"];
    
    NSString *transformedText = [transformer transformedValue:text];
    
    if ([transformedText isEqualToString:text]) {
        return transformedText;
    }
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                              [self.documentProxy deleteBackward];
                          }];
 
    [self.documentProxy insertText:transformedText];
    return transformedText;
}

- (void)performQuery:(NSString *)queryString {
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

- (NSString *)messageForQueryError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        return NSLocalizedString(@"😢 Something is wrong 😢\n\nPlease check your internet connection.", @"Keyboard URL error string");
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

#pragma mark - Usage tutorial text

- (NSString *)usageTutorialText {
    if (!_usageTutorialText) {
        NSString *localizedUsageFormat = NSLocalizedString(@"type\n:%@:\n\nthen press 🌐\nand select Search - Fontana", @"Keyboard Usage String");
        NSArray *randomTerms = self.randomTerms;
        NSString *randomTerm = randomTerms[arc4random()%randomTerms.count ];
        _usageTutorialText = [NSString stringWithFormat:localizedUsageFormat, randomTerm];
    }
    return _usageTutorialText;
}

#pragma mark - Donate text

- (NSAttributedString *)donateText {
    NSString *link = @"Please donate to remove this message.";
    NSString *format = [self donateFormat];
    NSString *string = [NSString stringWithFormat:format, link];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]
                       range:NSMakeRange(0, string.length)];
    
    NSRange linkRange = [string rangeOfString:link];
    [attrString addAttribute:NSLinkAttributeName
                       value:kFNTDonateDeepLink
                       range:linkRange];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16]
                       range:linkRange];
    
    [attrString endEditing];
    
    return attrString.copy;
}

- (NSString *)donateFormat {
    return @"😴 We wake up early to save your time 😴\n\n%@\n\nFontana -> More\nor tap the link above.";
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
