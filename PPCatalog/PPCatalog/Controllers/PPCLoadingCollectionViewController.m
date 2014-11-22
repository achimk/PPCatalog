//
//  PPCLoadingCollectionViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCLoadingCollectionViewController.h"

#import "TransitionKit.h"

#define kDefaultLoadNumberOfItems       10
#define kDefaultMaxNumberOfItems        50

#pragma mark - PPCLoadingCollectionViewController

@interface PPCLoadingCollectionViewController () {
    NSUInteger  _numberOfItems;
}

- (void)_finishInitialize;

@end

#pragma mark -

@implementation PPCLoadingCollectionViewController

+ (Class)defaultCollectionViewCellClass {
    return [PPCollectionViewCell class];
}

+ (Class)defaultLoadingCollectionViewCellClass {
    return [PPLoadingCollectionViewCell class];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark Public Methods

- (void)reloadData {
    LogTrace();
    [super reloadData];
}

#pragma mark Subclass Methods

- (void)willChangeState:(PPLoadingState)oldState toState:(PPLoadingState)newState {
    switch (newState) {
        case PPLoadingStateInitial:
        case PPLoadingStateRefresh:
        case PPLoadingStateLoading: {
            LogNotice(@"-> %@", PPStringFromLoadingState(newState));
            break;
        }
        default: {
            LogVerbose(@"-> %@", PPStringFromLoadingState(newState));
            break;
        }
    }
}

- (void)loadDataWithState:(PPLoadingState)state success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    if (PPLoadingStateInitial == state ||
        PPLoadingStateRefresh == state) {
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (state == self.state) {
                _numberOfItems = kDefaultLoadNumberOfItems;
                success();
            }
        });
    }
    else if (PPLoadingStateLoading == state) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (state == self.state) {
                _numberOfItems += kDefaultLoadNumberOfItems;
                success();
            }
        });
    }
    else {
        NSAssert1(NO, @"Unsupporeted state: %@", PPStringFromLoadingState(state));
        failure(nil);
    }
}

- (BOOL)canChangeStateFromState:(PPLoadingState)oldState toState:(PPLoadingState)newState {
    BOOL shouldChange = [super canChangeStateFromState:oldState toState:newState];
    
    if (shouldChange) {
        switch (newState) {
            case PPLoadingStateInitial: {
                return self.appearsFirstTime;
            }
            case PPLoadingStateRefresh: {
                return YES;
            }
            case PPLoadingStateLoading: {
                return kDefaultMaxNumberOfItems > _numberOfItems;
            }
            default: {
                break;
            }
        }
    }
    
    return shouldChange;
}

- (BOOL)shouldShowLoadingCellWithState:(PPLoadingState)state {
    if (kDefaultMaxNumberOfItems > _numberOfItems) {
        return [super shouldShowLoadingCellWithState:state];
    }
    
    return NO;
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
    //[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark PSUICollectionViewDataSource

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewCell * cell = (PSUICollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self isLoadingCell:indexPath]) {
        if ([cell isKindOfClass:[PPLoadingCollectionViewCell class]]) {
            //PPLoadingCollectionViewCell * loadingCell = (PPLoadingCollectionViewCell *)cell;
            //loadingCell.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
    }
    else {
        PPCollectionViewCell * defaultCell = (PPCollectionViewCell *)cell;
        defaultCell.imageView.image = [UIImage pp_imageWithColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] size:CGSizeMake(100.0f, 100.0f)];
        defaultCell.textLabel.text = [NSString stringWithFormat:@"Item: %d", indexPath.row];
        defaultCell.detailTextLabel.text = [NSString stringWithFormat:@"<%d, %d>", indexPath.section, indexPath.row];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.showsLoadingCell) ? _numberOfItems + 1 : _numberOfItems;
}

@end
