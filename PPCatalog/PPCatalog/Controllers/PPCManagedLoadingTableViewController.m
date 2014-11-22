//
//  PPCManagedLoadingTableViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 23.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCManagedLoadingTableViewController.h"

#import "TransitionKit.h"
#import "PPCEventEntity.h"

#define kDefaultLoadNumberOfRows        10
#define kDefaultMaxNumberOfRows         50

#pragma mark - PPCManagedLoadingTableViewController

@interface PPCManagedLoadingTableViewController ()
- (void)_finishInitialize;
@end

#pragma mark -

@implementation PPCManagedLoadingTableViewController

+ (Class)defaultTableViewCellClass {
    return [PPSubtitleDetailTableViewCell class];
}

+ (Class)defaultLoadingTableViewCellClass {
    return [PPLoadingTableViewCell class];
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
        NSManagedObjectContext * context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        context.parentContext = [[PPCCoreDataStore sharedInstance] privateContext];
        _managedObjectContext = context;
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
                    
                    for (NSInteger i = 0; i < kDefaultLoadNumberOfRows; i++) {
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
                for (NSInteger i = 0; i < kDefaultLoadNumberOfRows; i++) {
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
        NSAssert1(NO, @"Unsupported state: %@", PPStringFromLoadingState(state));
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
                return [self.fetchedResultsController.fetchedObjects count] < kDefaultMaxNumberOfRows;
            }
            default: {
                break;
            }
        }
    }
    
    return shouldChange;
}

- (BOOL)shouldShowLoadingCellWithState:(PPLoadingState)state {
    if ([self.fetchedResultsController.fetchedObjects count] < kDefaultMaxNumberOfRows) {
        return [super shouldShowLoadingCellWithState:state];
    }
    
    return NO;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([self isLoadingCell:indexPath]) {
        if ([cell isKindOfClass:[PPLoadingTableViewCell class]]) {
            //PPLoadingTableViewCell * loadingCell = (PPLoadingTableViewCell *)cell;
            //loadingCell.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
    }
    else {
        NSAssert1(indexPath.row < [self.fetchedResultsController.fetchedObjects count], @"Invalid index path for row: %d", indexPath.row);
        PPCEventEntity * eventEntity = [self objectForViewIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
        cell.detailTextLabel.text = eventEntity.timeStamp.description;
    }
    
    return cell;
}

@end
