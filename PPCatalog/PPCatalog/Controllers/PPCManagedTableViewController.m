//
//  PPCManagedTableViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCManagedTableViewController.h"

#import "AppDelegate.h"
#import "PPCEventEntity.h"

#pragma mark - PPCManagedTableViewController

@interface PPCManagedTableViewController ()
- (void)_finishInitialize;
@end

#pragma mark -

@implementation PPCManagedTableViewController

+ (Class)defaultTableViewCellClass {
    return [PPSubtitleDetailTableViewCell class];
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

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
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

#pragma mark Actions

- (IBAction)addAction:(id)sender {
    [NSEntityDescription insertNewObjectForEntityForName:[PPCEventEntity entityName] inManagedObjectContext:self.managedObjectContext];
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    PPCEventEntity * eventEntity = [self objectForViewIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %d", indexPath.row];
    cell.detailTextLabel.text = eventEntity.timeStamp.description;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        NSManagedObject * object = [self objectForViewIndexPath:indexPath];
        [self.managedObjectContext deleteObject:object];
    }
}

@end
