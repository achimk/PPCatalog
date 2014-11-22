//
//  PPCSheetViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 13.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCSheetViewController.h"

#pragma mark -

@interface PPCSheetContainerView : UIView
- (void)finishInitialize;
@end

@implementation PPCSheetContainerView

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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0f].CGPath;
    self.layer.mask = maskLayer;
}

@end

#pragma mark - 

@interface PPCSheetBackgroundView : UIView
- (void)finishInitialize;
@end

@implementation PPCSheetBackgroundView

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

#pragma mark - PPCSheetController

@interface PPCSheetController : PPSheetController
@end

@implementation PPCSheetController

+ (Class)defaultBackgroundViewClass {
    return [PPCSheetBackgroundView class];
}

+ (Class)defaultContainerViewClass {
    return [PPCSheetContainerView class];
}

#pragma mark Initialize

- (void)finishInitialize {
    [super finishInitialize];
    
    self.callAppearanceMethods = YES;
}

@end

#pragma mark - PPCContentViewController

@interface PPCContentViewController : PPViewController
@end

#pragma mark -

@implementation PPCContentViewController

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

#pragma mark - PPCSheetViewController

@interface PPCSheetViewController () <PPSheetControllerDelegate>

@property (nonatomic, readwrite, strong) PPCSheetController * sheetController;
@property (nonatomic, readwrite, strong) PPCContentViewController * contentViewController;

@end

#pragma mark -

@implementation PPCSheetViewController

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

- (PPCSheetController *)sheetController {
    if (!_sheetController) {
        _sheetController = [PPCSheetController new];
        _sheetController.delegate = self;
    }
    
    return _sheetController;
}

- (PPCContentViewController *)contentViewController {
    if (!_contentViewController) {
        _contentViewController = [PPCContentViewController new];
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
    [self.sheetController presentWithViewController:self.contentViewController];
}

#pragma mark PPSheetControllerDelegate

- (UIEdgeInsets)containerMarginInsetsInSheetController:(PPSheetController *)sheetController forViewController:(UIViewController *)viewController {
    return UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
}

- (UIEdgeInsets)containerPaddingInsetsInSheetController:(PPSheetController *)sheetController forViewController:(UIViewController *)viewController {
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
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
