//
//  FNTKeyboardViewModel.h
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <BIND/BIND.h>

@class FNTKeyboardItemCellModel;
@class FNTContextItem;
@interface FNTKeyboardViewModel : BNDViewModel <BNDDataController>

@property (nonatomic, readonly) NSObject <UITextDocumentProxy> *documentProxy;
@property (nonatomic, strong, readonly) FNTContextItem *currentContextItem;
@property (nonatomic, strong) Class queryClass;
@property (nonatomic, getter=isUndoEnabled) BOOL undoEnabled;

- (void)updateWithContext:(NSObject <UITextDocumentProxy> *)documentProxy
        viewModelsHandler:(BNDViewModelsBlock)viewModelsHandler;

- (void)apply:(FNTKeyboardItemCellModel *)model;
- (void)undo;

@end
