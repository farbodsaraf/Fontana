//
//  FNTKeyboardViewController.m
//  FontanaKeyboard
//
//  Created by Marko Hlebar on 29/11/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

#import "FNTKeyboardViewController.h"
#import "FNTItem.h"
#import "FNTKeyboardViewModel.h"
#import "FNTKeyboardItemCellModel.h"

BND_VIEW_IMPLEMENTATION(FNTInputViewController) 

@interface FNTKeyboardViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIButton *fontanaButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation FNTKeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [FNTKeyboardViewModel new];
    
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
    
    [self.view addSubview:self.collectionView];
    self.collectionView.hidden = NO;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_collectionView);
    NSString *horizontalFormat = @"|-[_collectionView]-|";
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
    NSString *verticalFormat = @"V:|-[_collectionView]-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalFormat
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary]];
    
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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self linkify];
}

- (void)linkify {
    [self.keyboardViewModel updateWithContext:self.textDocumentProxy
                            viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                                [self.collectionView reloadData];
                                self.collectionView.hidden = NO;
                            }];
}

- (FNTKeyboardViewModel *)keyboardViewModel {
    return (FNTKeyboardViewModel*)self.viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
    
    NSLog(@"MEMORY WARNING!!!");
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
    
    self.collectionView.hidden = YES;
    self.fontanaButton.hidden = NO;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keyboardViewModel.children.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *nibName = @"FNTKeyboardItemCell";
    [self registerNib:nibName];
    BNDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:nibName
                                                                           forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
    }
    
    cell.viewModel = self.keyboardViewModel.children[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width, 100);
}

- (void)registerNib:(NSString *)cellName {
    UINib *nib = [UINib nibWithNibName:cellName bundle:NSBundle.mainBundle];
    [self.collectionView registerNib:nib
     forCellWithReuseIdentifier:cellName];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FNTKeyboardItemCellModel *itemModel = self.keyboardViewModel.children[indexPath.row];
    FNTItem *item = itemModel.model;
    NSString *text = [NSString stringWithFormat:@"\n%@", item.link.absoluteString];
    [self.textDocumentProxy insertText:text];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
