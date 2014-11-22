//
//  PPCManagedCollectionViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCManagedCollectionViewController.h"

#import "AppDelegate.h"
#import "PPCEventEntity.h"

#pragma mark - PPCManagedCollectionViewController

@interface PPCManagedCollectionViewController ()
- (void)_finishInitialize;
@end

#pragma mark -

@implementation PPCManagedCollectionViewController

+ (Class)defaultCollectionViewCellClass {
    return [PPCollectionViewCell class];
}

#pragma mark Dealloc

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

- (void)viewWillAppear:(BOOL)animated {
    self.changeType = PPFetchedResultsChangeTypeUpdate;
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.changeType = PPFetchedResultsChangeTypeIgnore;
}

#pragma mark Accessors

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[PPCCoreDataStore sharedInstance] childContextForParentContext:[[PPCCoreDataStore sharedInstance] privateContext] withConcurrencyType:NSMainQueueConcurrencyType];
    }
    
    return _managedObjectContext;
}

- (Class)entityClass {
    return [PPCEventEntity class];
}

- (NSArray *)sortDescriptors {
    return [PPCEventEntity sortDescriptors];
}

#pragma mark Actions

- (IBAction)addAction:(id)sender {
    [NSEntityDescription insertNewObjectForEntityForName:[PPCEventEntity entityName] inManagedObjectContext:self.managedObjectContext];
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
    
    if ([cell isKindOfClass:[PPCollectionViewCell class]]) {
        PPCEventEntity * eventEntity = [self objectForViewIndexPath:indexPath];
        
        PPCollectionViewCell * defaultCell = (PPCollectionViewCell *)cell;
        defaultCell.imageView.image = [UIImage pp_imageWithColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] size:CGSizeMake(100.0f, 100.0f)];
        defaultCell.textLabel.text = [NSString stringWithFormat:@"Item: %d", indexPath.row];
        defaultCell.detailTextLabel.text = eventEntity.timeStamp.description;
    }
    
    return cell;
}

@end
