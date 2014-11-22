//
//  PPCCollectionViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 12.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCCollectionViewController.h"

#pragma mark - PPCCollectionViewController

@interface PPCCollectionViewController () {
    NSUInteger _numberOfItems;
}

- (void)_finishInitialize;

@end

#pragma mark -

@implementation PPCCollectionViewController

+ (Class)defaultCollectionViewCellClass {
    return [PPCollectionViewCell class];
}

#pragma mark Init / Dealloc

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _finishInitialize];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _finishInitialize];
    }
    
    return self;
}

- (void)_finishInitialize {
    _numberOfItems = 0;
}

- (void)dealloc {
    LogTrace();
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    self.collectionView.backgroundColor = [UIColor pp_colorWithRGBHex:PPColorClouds];
}

#pragma mark Actions

- (IBAction)addAction:(id)sender {
    _numberOfItems++;
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_numberOfItems - 1 inSection:0]]];
    } completion:NULL];
}

#pragma mark PSUICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200.0f, 200.0f);
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 50.0f;
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
    
    PSUICollectionViewCell * cell = (PSUICollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PSUICollectionViewCell class]]) {
        PPCollectionViewCell * defaultCell = (PPCollectionViewCell *)cell;
        defaultCell.imageView.image = [UIImage pp_imageWithColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] size:CGSizeMake(100.0f, 100.0f)];
        defaultCell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
        defaultCell.detailTextLabel.text = [NSString stringWithFormat:@"<%d, %d>", indexPath.section, indexPath.row];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _numberOfItems;
}

@end
