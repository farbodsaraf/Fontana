//
//  FNTKeyboardItemCellModel.h
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import <BIND/BIND.h>

@interface FNTKeyboardItemCellModel : BNDViewModel
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSAttributedString *attributedText;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSURL *thumbnailURL;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) UIImage *faviconImage;
@property (nonatomic, copy, readonly) NSString *source;
@end
