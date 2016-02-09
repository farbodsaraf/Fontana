//
//  FNTKeyboardItemCellModel.m
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardItemCellModel.h"
#import "FNTItem.h"
#import "NSURL+FNTBaseURL.h"

typedef void(^FNTImageBlock)(UIImage *);

static NSString *const kFNTKeyboardItemCell = @"FNTKeyboardItemCell";
static NSString *const kFNTKeyboardItemPlainCell = @"FNTKeyboardItemPlainCell";

@interface FNTKeyboardItemCellModel ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *faviconImage;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, copy) NSURL *faviconURL;

@end

@implementation FNTKeyboardItemCellModel
BINDINGS(FNTItem,
         BINDModel(link, ~>, url),
         BINDModel(thumbnailURL, ~>, thumbnailURL),
         BINDModel(source, ~>, source),
         nil
         )

- (instancetype)initWithModel:(FNTItem *)model {
    self = [super initWithModel:model];
    if (self) {
        _text = [NSString stringWithFormat:@"%@", model.title];
    }
    return self;
}

- (UIImage *)image {
    if (!self.thumbnailURL) {
        return nil;
    }
    
    if (!_image) {
        __weak typeof(self) weakSelf = self;
        [self downloadImageWithURL:self.thumbnailURL imageBlock:^(UIImage *image) {
            weakSelf.image = image ?: [UIImage imageNamed:@"icon_iphone"];
        }];
    }
    return _image;
}

- (UIImage *)faviconImage {
    if (!_faviconImage) {
        __weak typeof(self) weakSelf = self;
        [self downloadImageWithURL:self.faviconURL imageBlock:^(UIImage *image) {
            weakSelf.faviconImage = image ?: [UIImage imageNamed:@"icon_iphone"];
        }];
    }
    return _faviconImage;
}

- (void)downloadImageWithURL:(NSURL *)url imageBlock:(FNTImageBlock)imageBlock {
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:5];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               UIImage *image = nil;
                               if (data) {
                                   image = [UIImage imageWithData:data];
                               }
                               imageBlock(image);
                           }];
}

- (NSAttributedString *)attributedText {
    if (!_attributedText) {
        FNTItem *item = self.model;
        
        if (!item.link || !item.title) {
            return nil;
        }
        
        NSString *link = item.link.absoluteString;
        NSString *string = [NSString stringWithFormat:@"%@\n%@", item.title, link];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString beginEditing];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12]
                           range:NSMakeRange(0, string.length)];
        
        NSRange linkRange = [string rangeOfString:link];
        [attrString addAttribute:NSLinkAttributeName
                           value:link
                           range:linkRange];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10]
                           range:linkRange];
        
        [attrString endEditing];
        
        _attributedText = attrString.copy;
    }
    return _attributedText;
}

- (NSString *)identifier {
    return self.thumbnailURL ? kFNTKeyboardItemCell : kFNTKeyboardItemPlainCell;
}

- (NSURL *)faviconURL {
    if (!_faviconURL) {
        FNTItem *item = self.model;
        _faviconURL = [item.link fnt_urlByAddingPath:@"favicon.ico"];
    }
    return _faviconURL;
}

@end
