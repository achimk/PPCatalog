//
//  PPCLayoutCollectionViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 13.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCLayoutCollectionViewController.h"

#define kDefultNumberOfSections     4

@interface PPCCollectionReusableView : PSUICollectionReusableView
@property (nonatomic, readwrite, strong) UILabel * textLabel;
- (void)_finishInitialize;
@end

@implementation PPCCollectionReusableView

@synthesize textLabel = _textLabel;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _finishInitialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _finishInitialize];
    }
    
    return self;
}

- (void)_finishInitialize {
    _textLabel = [UILabel new];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textLabel.numberOfLines = 1;
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = UITextAlignmentCenter;
    _textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [self addSubview:_textLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f));
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font forWidth:frame.size.width lineBreakMode:self.textLabel.lineBreakMode];
    frame.origin.y = floorf((frame.size.height - size.height) * 0.5f + frame.origin.y);
    frame.size.height = size.height;
    self.textLabel.frame = frame;
}

@end

#pragma mark -

@interface PPCLayoutCollectionViewController ()
@end

#pragma mark -

@implementation PPCLayoutCollectionViewController

+ (Class)defaultCollectionViewCellClass {
    return [PPCollectionViewCell class];
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorClouds];
    [self.collectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([PPCollectionViewCell class])];
    [self.collectionView registerClass:[PPCCollectionReusableView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:PSTCollectionElementKindSectionHeader];
    [self.collectionView registerClass:[PPCCollectionReusableView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:PSTCollectionElementKindSectionFooter];
}

#pragma mark PSUICollectionViewDelegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark PSUICollectionViewDataSource

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PSUICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PPCollectionViewCell class]) forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PPCollectionViewCell class]]) {
        PPCollectionViewCell * defaultCell = (PPCollectionViewCell *)cell;
        defaultCell.imageView.image = [UIImage pp_imageWithColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] size:CGSizeMake(100.0f, 100.0f)];
        defaultCell.textLabel.text = [NSString stringWithFormat:@"Item %d - %d", indexPath.section, indexPath.row];
        defaultCell.detailTextLabel.text = [indexPath description];
    }
    
    return cell;
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
    
    if ([kind isEqualToString:PSTCollectionElementKindSectionHeader]) {
        PPCCollectionReusableView * defaultView = (PPCCollectionReusableView *)view;
        defaultView.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorAsbestos];
        defaultView.textLabel.text = [NSString stringWithFormat:@"header: %d", indexPath.section];
    }
    else if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
        PPCCollectionReusableView * defaultView = (PPCCollectionReusableView *)view;
        defaultView.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorAsbestos];
        defaultView.textLabel.text = [NSString stringWithFormat:@"Footer: %d", indexPath.section];
    }
    
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return kDefultNumberOfSections + 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kDefultNumberOfSections - section;
}

@end
