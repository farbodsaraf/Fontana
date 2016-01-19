//
//  NSObject+FNTTextDocumentProxyAdditions.h
//  Spreadit
//
//  Created by Marko Hlebar on 01/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (UITextDocumentProxyAdditions)

- (void)fnt_readText:(void(^)(NSString *textBeforeCursor, NSString *textAfterCursor))returnBlock;
- (void)fnt_deleteText:(NSString *)text;

@end
