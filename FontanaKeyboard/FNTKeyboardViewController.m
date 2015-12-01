//
//  FNTKeyboardViewController.m
//  FontanaKeyboard
//
//  Created by Marko Hlebar on 29/11/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardViewController.h"
#import "FNTItem.h"
#import "NSObject+FNTTextDocumentProxyAdditions.h"
#import "FNTKeyboardViewModel.h"

BND_VIEW_IMPLEMENTATION(FNTInputViewController) 

@interface FNTKeyboardViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIButton *fontanaButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *results;
@end

@implementation FNTKeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.fontanaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.fontanaButton setTitle:NSLocalizedString(@"LINKIFY", @"Linkify button")
                        forState:UIControlStateNormal];
    [self.fontanaButton sizeToFit];
    self.fontanaButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fontanaButton addTarget:self
                           action:@selector(linkify)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.fontanaButton];
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.fontanaButton
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.fontanaButton
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
    
    [self.view addConstraints:@[centerXConstraint, centerYConstraint]];
    
    self.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView);
    NSString *horizontalFormat = @"|-[_tableView]-|";
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    NSString *verticalFormat = @"V:|-[_tableView]-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    self.tableView.hidden = NO;
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

- (void)linkify {
    NSObject *proxy = self.textDocumentProxy;
    [proxy fnt_readText:^(NSString *stringBeforeCursor, NSString *stringAfterCursor){
        [self findLinks:stringBeforeCursor];
    }];
}

- (FNTKeyboardViewModel *)keyboardViewModel {
    return (FNTKeyboardViewModel*)self.viewModel;
}

NSString * const kLinkSeparator = @":";

- (void)findLinks:(NSString *)string {
    NSMutableString *linkString = [NSMutableString new];
    
    BOOL readLink = NO;
    for (NSUInteger pointer = 0; pointer < string.length; pointer++) {
        NSString *substring = [string substringWithRange:NSMakeRange(pointer, 1)];

        if ([substring isEqualToString:kLinkSeparator]) {
            readLink = !readLink;
            continue;
        }
        
        if (readLink) {
            [linkString appendString:substring];
        }
    }
    
    NSLog(@"%@", linkString);
    
    [self searchForLinks:linkString];
}

NSString *const kGoogleSearchString = @"https://www.googleapis.com/customsearch/v1?key=AIzaSyAy5gxcPstj94UatXV_8bgUL_rZjgcjt7Y&cx=017888679784784333058:un3lzj234sa&q=%@&start=1";

- (void)searchForLinks:(NSString *)linkString {
    NSString *urlString = [NSString stringWithFormat:kGoogleSearchString, linkString];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   [self handleData:data];
                               }
                           }];
}

- (void)handleData:(id)data {
    self.results = [self serializeData:data];
    [self.tableView reloadData];
    self.tableView.hidden = NO;
}

- (NSArray *)serializeData:(id)data {
    id JSON = [NSJSONSerialization JSONObjectWithData:data
                                              options:0
                                                error:nil];
    NSArray *items = JSON[@"items"];
    NSMutableArray *serializedItems = [NSMutableArray new];
    for (NSDictionary *item in items) {
        FNTItem *serializedItem = [[FNTItem alloc] initWithDictionary:item];
        [serializedItems addObject:serializedItem];
    }
    return serializedItems.copy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
    
    NSString *text = [self.textDocumentProxy documentContextBeforeInput];
    NSLog(@"%@", text);
    
    self.tableView.hidden = YES;
    self.fontanaButton.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
    }
    
    FNTItem *item = self.results[indexPath.row];
    cell.textLabel.text = item.title;
    if (item.thumbnailURL) {
        [self downloadImageToCell:cell
                          withURL:item.thumbnailURL];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FNTItem *item = self.results[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"\n%@", item.link.absoluteString];
    [self.textDocumentProxy insertText:text];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)downloadImageToCell:(UITableViewCell *)cell withURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response,
                                               NSData * _Nullable data,
                                               NSError * _Nullable connectionError) {
                               if (data) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   if (image) {
                                       cell.imageView.image = image;
                                       [cell setNeedsLayout];
                                   }
                               }
                           }];
}

@end
