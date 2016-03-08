//
//  FNTKeyboardViewController.m
//  FontanaKeyboard
//
//  Created by Marko Hlebar on 29/11/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

@import HockeySDK;

#import "FNTKeyboardViewController.h"
#import "FNTKeyboardViewModel.h"
#import "FNTUsageTutorialView.h"
#import <Masonry/Masonry.h>
#import "FNTKeyboardToolbar.h"
#import "FNTKeyboardItemCell.h"
#import "BIND.h"
#import "UIColor+FNTGenerator.h"
#import "FNTAppTracker.h"

static NSString *const FNTKeyboardViewFooter = @"FNTKeyboardViewFooter";

BND_VIEW_IMPLEMENTATION(FNTInputViewController)

@interface FNTKeyboardViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FNTUsageTutorialViewDelegate, FNTKeyboardToolbarDelegate, FNTKeyboardItemCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) FNTUsageTutorialView *tutorialView;
@property (nonatomic, strong) FNTKeyboardToolbar *toolbar;
@property (nonatomic, strong) FNTUsageTutorialView *donateView;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) BNDBinding *donateBinding;
@property (nonatomic, strong) BNDBinding *undoBinding;
@end

@implementation FNTKeyboardViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self runHockeyApp];
        [self runTagManager];
    }
    return self;
}

- (void)runHockeyApp {
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"c2b76f87dd7f42b3b774ede94ce73636"];
    [[BITHockeyManager sharedHockeyManager] startManager];
}

- (void)runTagManager {
    [[FNTAppTracker sharedInstance] startWithPreviewURL:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@34);
    }];
    
    if (_collectionView.superview) {
        [self constrainViewToToolbar:self.collectionView];
        
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    
    if (_donateView.superview) {
        [self constrainViewToToolbar:self.donateView];
    }

    if (_tutorialView.superview) {
        [self constrainViewToToolbar:self.tutorialView];
    }
}

- (void)constrainViewToToolbar:(UIView *)view {
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.toolbar);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [FNTKeyboardViewModel new];
    
    [self displayResultsView];
}

- (void)loadBindings:(FNTKeyboardViewModel *)viewModel {
    [self.donateBinding unbind];
    [self.undoBinding unbind];
    
    __weak typeof(self) weakSelf = self;
    self.donateBinding = [BINDO(viewModel, donateEnabled) observe:^(id observable, id value, NSDictionary *observationInfo) {
        if ([value boolValue]) {
            [weakSelf displayDonate];
        }
    }];
    
    self.undoBinding = [BINDO(viewModel, undoEnabled) observe:^(id observable, id value, NSDictionary *observationInfo) {
        self.toolbar.undoBarButtonItem.enabled = [value boolValue];
    }];
}

- (void)removeAllSubviews {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    self.collectionView = nil;
    self.activityIndicator = nil;
    self.toolbar = nil;
    self.donateView = nil;
    self.tutorialView = nil;
    self.separator = nil;
}

- (void)displayResultsView {
    [self removeAllSubviews];

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.activityIndicator];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.separator];
    
    [self.view setNeedsUpdateConstraints];
    
    [self loadBindings:(FNTKeyboardViewModel *)self.viewModel];    
}

- (void)displayDonate {
    [self removeAllSubviews];
    
    [self.view addSubview:self.donateView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.separator];
    
    self.donateView.text = self.keyboardViewModel.donateText;
    
    [self.view setNeedsUpdateConstraints];
    
    [self trackScreen:@"Keyboard - Donate"];
}

- (void)displayNoResultsForError:(NSError *)error {
    [self removeAllSubviews];
    
    [self.view addSubview:self.tutorialView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.separator];
    
    self.tutorialView.text = [self.keyboardViewModel messageForQueryError:error];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)trackScreen:(NSString *)screenName {
    [FNTAppTracker trackEvent:FNTAppTrackerScreenViewEvent
                     withTags:@{
                                FNTAppTrackerScreenNameTag : screenName
                                }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    CGSize itemSize = self.view.frame.size;
    itemSize.width = self.isPortrait ? itemSize.width : itemSize.width / 2;
    itemSize.height = 66;
    flowLayout.itemSize = itemSize;
    
    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

- (BOOL)isPortrait {
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    return self.view.frame.size.width == fminf(boundsSize.width, boundsSize.height);
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [UIView new];
        _separator.backgroundColor = UIColor.fnt_teal;
    }
    return _separator;
}

- (FNTUsageTutorialView *)tutorialView {
    if (!_tutorialView) {
        _tutorialView = [FNTUsageTutorialView new];
        _tutorialView.delegate = self;
        [_tutorialView start];
    }
    return _tutorialView;
}

- (FNTUsageTutorialView *)donateView {
    if (!_donateView) {
        _donateView = [FNTUsageTutorialView new];
        _donateView.delegate = self;
        [_donateView start];
    }
    return _donateView;
}

- (FNTKeyboardToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[[NSBundle mainBundle] loadNibNamed:@"FNTKeyboardToolbar" owner:self options:nil] objectAtIndex:0];
        _toolbar.delegate = self;
    }
    return _toolbar;
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
    
    __weak typeof(self) weakSelf = self;
    [self.keyboardViewModel updateWithContext:self.textDocumentProxy
                            viewModelsHandler:^(NSArray *viewModels, NSError *error) {
                                [weakSelf handleViewModels:viewModels error:error];
                            }];
}

- (void)handleViewModels:(NSArray *)viewModels error:(NSError *)error {
    if (!error) {
        [self.collectionView reloadData];
        [self.activityIndicator stopAnimating];
        [self trackScreen:@"Keyboard - Results"];
    }
    else {
        [self displayNoResultsForError:error];
        
        NSString *localizedDescription = error.localizedDescription ?: @"No Error Description";
        NSString *screenString = [NSString stringWithFormat:@"Keyboard - Tutorial - %@", localizedDescription];
        [self trackScreen:screenString];
    }
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
    BNDViewModel *viewModel = self.keyboardViewModel.children[indexPath.row];
    [self registerNib:viewModel.identifier];
    FNTKeyboardItemCell *cell = (FNTKeyboardItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:viewModel.identifier
                                                                            forIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.delegate = self;
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
    [self.keyboardViewModel apply:itemModel];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [FNTAppTracker trackEvent:FNTAppTrackerActionEvent
                     withTags:@{
                                FNTAppTrackerEventActionTag : @"Keyboard - didTapToAddURL"
                                }];
}

#pragma mark - FNTUsageTutorialViewDelegate

- (void)tutorialViewDidFinish:(FNTUsageTutorialView *)tutorialView {

}

#pragma mark - FNTKeyboardToolbarDelegate

- (void)toolbarDidSelectNextKeyboard:(id)toolbar {
    [self.keyboardViewModel restoreOriginalTextIfNeeded];
    [self advanceToNextInputMode];
}

- (void)toolbarDidUndo:(id)toolbar {
    [self.keyboardViewModel undo];
}

#pragma mark - FNTOpenURLProtocol

- (void)tutorial:(FNTUsageTutorialView *)tutorialView willOpenURL:(NSURL *)url {
    [self sender:tutorialView wantsToOpenURL:url];
}

- (void)sender:(id)sender wantsToOpenURL:(NSURL*)url {
    //    TODO: this should open a preview UIWebView instead.
    if([url.scheme isEqualToString:@"fontanakey"]) {
        UIResponder* responder = self;
        while ((responder = [responder nextResponder]) != nil) {
            if([responder respondsToSelector:@selector(openURL:)] == YES) {
                [responder performSelector:@selector(openURL:)
                                withObject:url];
            }
        }
        
        NSString *action = [NSString stringWithFormat:@"Keyboard - openInternalUrl - %@", url.absoluteString];
        [FNTAppTracker trackEvent:FNTAppTrackerActionEvent
                         withTags:@{
                                    FNTAppTrackerEventActionTag : action
                                    }];
    }
    else {
        [FNTAppTracker trackEvent:FNTAppTrackerActionEvent
                         withTags:@{
                                    FNTAppTrackerEventActionTag : @"Keyboard - openUrl"
                                    }];
    }
    //    [self advanceToNextInputMode];
}

@end
