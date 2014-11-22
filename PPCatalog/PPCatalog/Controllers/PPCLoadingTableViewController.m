//
//  PPCLoadingTableViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 22.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCLoadingTableViewController.h"

#import "TransitionKit.h"

#define kDefaultLoadNumberOfRows        10
#define kDefaultMaxNumberOfRows         50

#pragma mark - PPCLoadingTableViewController

@interface PPCLoadingTableViewController () {
    NSUInteger  _numberOfRows;
}

- (void)_finishInitialize;

@end

#pragma mark -

@implementation PPCLoadingTableViewController

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
    _numberOfRows = 0;
}

- (void)dealloc {
    LogTrace();
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];
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
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            if (state == self.state) {
                _numberOfRows = kDefaultLoadNumberOfRows;
                success();
            }
        });
    }
    else if (PPLoadingStateLoading == state) {
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            if (state == self.state) {
                _numberOfRows += kDefaultLoadNumberOfRows;
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
                return kDefaultMaxNumberOfRows > _numberOfRows;
            }
            default: {
                break;
            }
        }
    }
    
    return shouldChange;
}

- (BOOL)shouldShowLoadingCellWithState:(PPLoadingState)state {
    if (kDefaultMaxNumberOfRows > _numberOfRows) {
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
        NSAssert1(indexPath.row < _numberOfRows, @"Invalid index path for row: %d", indexPath.row);
        cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"<%d, %d>", indexPath.section, indexPath.row];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.showsLoadingCell) ? _numberOfRows + 1 : _numberOfRows;
}

@end
