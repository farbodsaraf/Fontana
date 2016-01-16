//
//  FNTFakeKeyboardProxy.h
//  Spreadit
//
//  Created by Marko Hlebar on 31/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNTFakeKeyboardProxy : NSObject <UITextDocumentProxy>
@property (nullable, nonatomic, readonly) NSString *documentContextBeforeInput;
@property (nullable, nonatomic, readonly) NSString *documentContextAfterInput;
@property (nonatomic) NSInteger pointerLocation;
@property (nonatomic, strong)  NSMutableString * _Nonnull text;
@end
