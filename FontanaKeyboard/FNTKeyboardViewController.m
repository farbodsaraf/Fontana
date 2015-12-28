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
#import "FNTUsageTutorialView.h"
#import <Masonry/Masonry.h>
#import "FNTHistoryStack.h"
#import "FNTKeyboardToolbar.h"
@import HockeySDK;

static NSString *const kFNTAppGroup = @"group.com.fontanakey.app";
static NSString *const kFNTKeyboardItemCell = @"FNTKeyboardItemCell";
static NSString *const FNTKeyboardViewFooter = @"FNTKeyboardViewFooter";

BND_VIEW_IMPLEMENTATION(FNTInputViewController)

@interface FNTKeyboardViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FNTUsageTutorialViewDelegate, FNTKeyboardToolbarDelegate>
@property (nonatomic, strong) UIButton *finishTutorialButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) FNTUsageTutorialView *tutorialView;
@property (nonatomic, strong) FNTHistoryStack *historyStack;
@property (nonatomic, strong) FNTKeyboardToolbar *toolbar;
@end

@implementation FNTKeyboardViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _historyStack = [FNTHistoryStack stackForGroup:kFNTAppGroup];
        [self runHockeyApp];
    }
    return self;
}

- (void)runHockeyApp {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"c2b76f87dd7f42b3b774ede94ce73636"];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (_collectionView.superview) {
        [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@34);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.toolbar);
        }];
        
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }

    if (_tutorialView.superview) {
        [self.tutorialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.finishTutorialButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.bottom.offset(0);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [FNTKeyboardViewModel new];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.activityIndicator];
    [self.view addSubview:self.toolbar];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)displayNoResults {
    [self.collectionView removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
    
    [self.view addSubview:self.tutorialView];
    [self.view addSubview:self.finishTutorialButton];
    self.finishTutorialButton.alpha = 0;
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    CGSize itemSize = self.view.frame.size;
    itemSize.width = self.isPortrait ? itemSize.width : itemSize.width / 2;
    itemSize.height = 80;
    flowLayout.itemSize = itemSize;
    
    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

- (BOOL)isPortrait {
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    return self.view.frame.size.width == fminf(boundsSize.width, boundsSize.height);
}

- (FNTUsageTutorialView *)tutorialView {
    if (!_tutorialView) {
        _tutorialView = [FNTUsageTutorialView new];
        _tutorialView.delegate = self;
        [_tutorialView start];
    }
    return _tutorialView;
}

- (FNTKeyboardToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[[NSBundle mainBundle] loadNibNamed:@"FNTKeyboardToolbar" owner:self options:nil] objectAtIndex:0];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (UIButton *)finishTutorialButton {
    if (!_finishTutorialButton) {
        _finishTutorialButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_finishTutorialButton setTitle:NSLocalizedString(@"OK", @"Title for 'Finish Tutorial' button") forState:UIControlStateNormal];
        [_finishTutorialButton sizeToFit];
        [_finishTutorialButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
        _finishTutorialButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _finishTutorialButton;
}

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityIndicator;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self registerNib:kFNTKeyboardItemCell];
        [_collectionView registerClass:UICollectionReusableView.class
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:FNTKeyboardViewFooter];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self linkify];
}

- (void)linkify {
    [self.activityIndicator startAnimating];
    [self.keyboardViewModel updateWithContext:self.textDocumentProxy
                            viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                                if (!error) {
                                    [self.collectionView reloadData];
                                    [self.activityIndicator stopAnimating];
                                }
                                else {
                                    [self displayNoResults];
                                }
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keyboardViewModel.children.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BNDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFNTKeyboardItemCell
                                                                            forIndexPath:indexPath];
    cell.viewModel = self.keyboardViewModel.children[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                            withReuseIdentifier:FNTKeyboardViewFooter
                                                                   forIndexPath:indexPath];
        footer.backgroundColor = UIColor.clearColor;
        return footer;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    return CGSizeMake(flowLayout.itemSize.width, 34);
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
    
    [self.historyStack pushItem:item];
}

#pragma mark - FNTUsageTutorialViewDelegate

- (void)tutorialViewDidFinish:(FNTUsageTutorialView *)tutorialView {
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.finishTutorialButton.alpha = 1;
                     }];
}

#pragma mark - FNTKeyboardToolbarDelegate

- (void)toolbarDidSelectNextKeyboard:(id)toolbar {
    [self advanceToNextInputMode];
}

@end
