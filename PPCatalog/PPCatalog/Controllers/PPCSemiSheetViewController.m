//
//  PPCSemiSheetViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 18.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCSemiSheetViewController.h"

#pragma mark - PPCSemiSheetContainerView

@interface PPCSemiSheetContainerView : UIView
@property (nonatomic, readwrite, assign) PPSheetContainerPosition containerPosition;
- (void)finishInitialize;
@end

@implementation PPCSemiSheetContainerView

@synthesize containerPosition = _containerPosition;

#pragma mark Init

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self finishInitialize];
    }
    
    return self;
}

- (void)finishInitialize {
    self.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorAlizarin alpha:1.0f];
    self.containerPosition = PPSheetContainerPositionTop;
}

#pragma mark Accessors

- (void)setContainerPosition:(PPSheetContainerPosition)containerPosition {
    _containerPosition = containerPosition;
    [self setNeedsLayout];
}

#pragma mark View

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.containerPosition) {
        case PPSheetContainerPositionTop: {
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
            self.layer.mask = maskLayer;
            break;
        }
        case PPSheetContainerPositionLeft: {
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
            self.layer.mask = maskLayer;
            break;
        }
        case PPSheetContainerPositionBottom: {
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
            self.layer.mask = maskLayer;
            break;
        }
        case PPSheetContainerPositionRight: {
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
            self.layer.mask = maskLayer;
            break;
        }
        default: {
            break;
        }
    }
}

@end

#pragma mark - PPCSemiSheetBackgroundView

@interface PPCSemiSheetBackgroundView : UIView
- (void)finishInitialize;
@end

@implementation PPCSemiSheetBackgroundView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self finishInitialize];
    }
    
    return self;
}

- (void)finishInitialize {
    self.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorGreenSea alpha:0.7f];
}

@end

#pragma mark - PPCSemiSheetController

@interface PPCSemiSheetController : PPSemiSheetController
@end

@implementation PPCSemiSheetController

+ (Class)defaultBackgroundViewClass {
    return [PPCSemiSheetBackgroundView class];
}

+ (Class)defaultContainerViewClass {
    return [PPCSemiSheetContainerView class];
}

#pragma mark Initialize

- (void)finishInitialize {
    [super finishInitialize];
    
    self.callAppearanceMethods = YES;
}

#pragma mark Accessors

- (void)setContainerPosition:(PPSheetContainerPosition)containerPosition {
    if (containerPosition != _containerPosition) {
        [super setContainerPosition:containerPosition];
        [self configureViewForContainerView:_containerView];
    }
}

#pragma mark Subclass Methods

- (void)configureViewForContainerView:(UIView *)containerView {
    [super configureViewForContainerView:containerView];
    
    if ([containerView isKindOfClass:[PPCSemiSheetContainerView class]]) {
        PPCSemiSheetContainerView * customContainerView = (PPCSemiSheetContainerView *)containerView;
        customContainerView.containerPosition = self.containerPosition;
    }
}

@end

#pragma mark - PPCSemiContentViewController

@interface PPCSemiContentViewController : PPViewController
@end

#pragma mark -

@implementation PPCSemiContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorAlizarin alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LogNotice(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LogNotice(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    LogNotice(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    LogNotice(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

#pragma mark - PPCSemiSheetViewController

@interface PPCSemiSheetViewController () <PPSheetControllerDelegate>

@property (nonatomic, readwrite, strong) PPCSemiSheetController * sheetController;
@property (nonatomic, readwrite, strong) PPCSemiContentViewController * contentViewController;

@end

@implementation PPCSemiSheetViewController

@synthesize segmentedControl = _segmentedControl;
@synthesize widthSlider = _widthSlider;
@synthesize heightSlider = _heightSlider;
@synthesize durationSlider = _durationSlider;
@synthesize widthLabel = _widthLabel;
@synthesize heightLabel = _heightLabel;
@synthesize durationLabel = _durationLabel;
@synthesize animatedSwitch = _animatedSwitch;
@synthesize callAppearanceSwitch = _callAppearanceSwitch;
@synthesize showButton = _showButton;

@synthesize sheetController = _sheetController;
@synthesize contentViewController = _contentViewController;

#pragma mark Views

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animatedSwitch.on = self.sheetController.animates;
    self.callAppearanceSwitch.on = self.sheetController.callAppearanceMethods;
    self.durationSlider.value = self.sheetController.animationDuration;
    
    self.widthLabel.text = [NSString stringWithFormat:@"Width: %3.0f", self.widthSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"Height: %3.0f", self.heightSlider.value];
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %1.2f", self.durationSlider.value];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LogVerbose(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LogVerbose(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    LogVerbose(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    LogVerbose(@"-> %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

#pragma mark Accessors

- (PPCSemiSheetController *)sheetController {
    if (!_sheetController) {
        _sheetController = [PPCSemiSheetController new];
        _sheetController.delegate = self;
    }
    
    return _sheetController;
}

- (PPCSemiContentViewController *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [PPCSemiContentViewController new];
    }
    
    return _contentViewController;
}

#pragma mark Actions

- (IBAction)widthSliderChange:(id)sender {
    self.widthLabel.text = [NSString stringWithFormat:@"Width: %3.0f", self.widthSlider.value];
}

- (IBAction)heightSliderChange:(id)sender {
    self.heightLabel.text = [NSString stringWithFormat:@"Height: %3.0f", self.heightSlider.value];
}

- (IBAction)durationSliderChange:(id)sender {
    self.durationLabel.text = [NSString stringWithFormat:@"Duration: %1.2f", self.durationSlider.value];
}

- (IBAction)showAction:(id)sender {
    self.sheetController.animates = self.animatedSwitch.isOn;
    self.sheetController.callAppearanceMethods = self.callAppearanceSwitch.isOn;
    self.sheetController.animationDuration = self.durationSlider.value;
    self.sheetController.containerPosition = self.segmentedControl.selectedSegmentIndex;
    [self.sheetController presentWithViewController:self.contentViewController];
}

#pragma mark PPSheetControllerDelegate

- (UIEdgeInsets)containerMarginInsetsInSheetController:(PPSheetController *)sheetController forViewController:(UIViewController *)viewController {
    switch (self.sheetController.containerPosition) {
        case PPSheetContainerPositionTop: {
            return UIEdgeInsetsMake(0.0f, 20.0f, 20.0f, 20.0f);
        }
        case PPSheetContainerPositionLeft: {
            return UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 20.0f);
        }
        case PPSheetContainerPositionBottom: {
            return UIEdgeInsetsMake(20.0f, 20.0f, 0.0f, 20.0f);
        }
        case PPSheetContainerPositionRight: {
            return UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 0.0f);
        }
        default: {
            return UIEdgeInsetsZero;
        }
    }
}

- (UIEdgeInsets)containerPaddingInsetsInSheetController:(PPSheetController *)sheetController forViewController:(UIViewController *)viewController {
    switch (self.sheetController.containerPosition) {
        case PPSheetContainerPositionTop: {
            return UIEdgeInsetsMake(0.0f, 10.0f, 10.0f, 10.0f);
        }
        case PPSheetContainerPositionLeft: {
            return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 10.0f);
        }
        case PPSheetContainerPositionBottom: {
            return UIEdgeInsetsMake(10.0f, 10.0f, 0.0f, 10.0f);
        }
        case PPSheetContainerPositionRight: {
            return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 0.0f);
        }
        default: {
            return UIEdgeInsetsZero;
        }
    }
}

- (CGSize)containerSizeInSheetController:(PPSheetController *)sheetController forViewController:(UIViewController *)viewController {
    return CGSizeMake(floorf(self.widthSlider.value), floorf(self.heightSlider.value));
}

- (void)sheetController:(PPSheetController *)sheetController willPresentViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)sheetController:(PPSheetController *)sheetController didPresentViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)sheetController:(PPSheetController *)sheetController willDismissViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)sheetController:(PPSheetController *)sheetController didDismissViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (BOOL)sheetController:(PPSheetController *)sheetController shouldDismissViewController:(UIViewController *)viewController {
    return YES;
}

@end
