//
//  FNTKeyboardItemCellModel.m
//  Spreadit
//
//  Created by Marko Hlebar on 02/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardItemCellModel.h"
#import "FNTItem.h"

@interface FNTKeyboardItemCellModel ()
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSAttributedString *attributedText;
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

- (void)setThumbnailURL:(NSURL *)thumbnailURL {
    _thumbnailURL = thumbnailURL;
    [self downloadImageWithURL:_thumbnailURL];
}

- (void)downloadImageWithURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   if (image) {
                                       self.image = image;
                                   }
                               }
                           }];
}

- (NSAttributedString *)attributedText {
    if (!_attributedText) {
        FNTItem *item = self.model;
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

@end
