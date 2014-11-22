//
//  PPCManagedLoadingCollectionViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 02.01.2014.
//  Copyright (c) 2014 Joachim Kret. All rights reserved.
//

#import "PPCManagedLoadingCollectionViewController.h"

#import "TransitionKit.h"
#import "PPCEventEntity.h"

#define kDefaultLoadNumberOfItems       10
#define kDefaultMaxNumberOfItems        50

#pragma mark - PPCManagedLoadingCollectionViewController

@interface PPCManagedLoadingCollectionViewController ()
- (void)_finishInitialize;
@end

#pragma mark -

@implementation PPCManagedLoadingCollectionViewController

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
}

- (void)dealloc {
    LogTrace();
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

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
    
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
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            if (state != self.state) {
                return;
            }
            
            NSManagedObjectContext * privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            privateContext.parentContext = self.managedObjectContext;
            
            [privateContext performBlock:^{
                NSFetchRequest * fetchRequest = [NSFetchRequest new];
                fetchRequest.entity = [NSEntityDescription entityForName:[PPCEventEntity entityName] inManagedObjectContext:privateContext];
                fetchRequest.returnsObjectsAsFaults = YES;
                fetchRequest.includesPropertyValues = NO;
                
                NSError * error = nil;
                NSArray * objects = [privateContext executeFetchRequest:fetchRequest error:&error];
                
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                        LogError(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    });
                }
                else {
                    for (NSManagedObject * managedObject in objects) {
                        [privateContext deleteObject:managedObject];
                    }
                    
                    for (NSInteger i = 0; i < kDefaultLoadNumberOfItems; i++) {
                        [NSEntityDescription insertNewObjectForEntityForName:[PPCEventEntity entityName] inManagedObjectContext:privateContext];
                    }
                    
                    if ([privateContext save:&error]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success();
                        });
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(error);
                            LogError(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        });
                    }
                }
            }];
        });
    }
    else if (PPLoadingStateLoading == state) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            if (state != self.state) {
                return;
            }
            
            NSManagedObjectContext * privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            privateContext.parentContext = self.managedObjectContext;
            
            [privateContext performBlock:^{
                for (NSInteger i = 0; i < kDefaultLoadNumberOfItems; i++) {
                    [NSEntityDescription insertNewObjectForEntityForName:[PPCEventEntity entityName] inManagedObjectContext:privateContext];
                }
                
                NSError * error = nil;
                
                if ([privateContext save:&error]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success();
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                        LogError(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    });
                }
            }];
        });
    }
    else {
        NSAssert1(NO, @"Unsupported state", PPStringFromLoadingState(state));
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
                return [self.fetchedResultsController.fetchedObjects count] < kDefaultMaxNumberOfItems;
            }
            default: {
                break;
            }
        }
    }
    
    return shouldChange;
}

- (BOOL)shouldShowLoadingCellWithState:(PPLoadingState)state {
    if ([self.fetchedResultsController.fetchedObjects count] < kDefaultMaxNumberOfItems) {
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
        PPCEventEntity * eventEntity = [self objectForViewIndexPath:indexPath];
        
        PPCollectionViewCell * defaultCell = (PPCollectionViewCell *)cell;
        defaultCell.imageView.image = [UIImage pp_imageWithColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] size:CGSizeMake(100.0f, 100.0f)];
        defaultCell.textLabel.text = [NSString stringWithFormat:@"Item: %d", indexPath.row];
        defaultCell.detailTextLabel.text = eventEntity.timeStamp.description;
    }
    
    return cell;
}

@end
