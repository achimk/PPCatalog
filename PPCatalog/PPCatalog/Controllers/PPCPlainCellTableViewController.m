//
//  PPCPlainCellTableViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCPlainCellTableViewController.h"

NSString * const kTableViewCellAddIdentifier                = @"tableViewCellAddIdentifier";
NSString * const kTableViewCellIdentifier                   = @"tableViewCellIdentifier";
NSString * const kTableViewRightDetailCellIdentifier        = @"tableViewRightDetailCellIdentifier";
NSString * const kTableViewSubtitleDetailCellIdentifier     = @"tableViewSubtitleDetailCellIdentifier";

@interface PPCPlainCellTableViewController () {
    NSUInteger  _addCount;
}

@property (nonatomic, readwrite, strong) NSArray * cellClasses;
@property (nonatomic, readwrite, strong) NSArray * cellClassNames;
@property (nonatomic, readwrite, strong) NSArray * cellClassReuseIdentifiers;
@end

#pragma mark -

@implementation PPCPlainCellTableViewController

@synthesize cellClasses = _cellClasses;
@synthesize cellClassNames = _cellClassNames;
@synthesize cellClassReuseIdentifiers = _cellClassReuseIdentifiers;

+ (UITableViewStyle)defaultTableViewStyle {
    return UITableViewStylePlain;
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    }
    
    _addCount = 0;
    
    self.cellClasses = @[[PPTableViewCell class],
                         [PPTableViewCell class],
                         [PPRightDetailTableViewCell class],
                         [PPSubtitleDetailTableViewCell class]];
    
    self.cellClassNames = @[@"Add Cell",
                            @"Plain Cell",
                            @"Right Detail Cell",
                            @"Subtitle Detail Cell"];
    
    self.cellClassReuseIdentifiers = @[kTableViewCellIdentifier,
                                       kTableViewCellIdentifier,
                                       kTableViewRightDetailCellIdentifier,
                                       kTableViewSubtitleDetailCellIdentifier];
    
    for (Class cellClass in self.cellClasses) {
        NSString * identifier = [self.cellClassReuseIdentifiers objectAtIndex:[self.cellClasses indexOfObject:cellClass]];
        [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

#pragma mark Actions

- (IBAction)addAction:(id)sender {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_addCount inSection:0];
    _addCount++;
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellClassReuseIdentifiers[indexPath.section]];
    
    if (0 == indexPath.row % 3) {
        cell.textLabel.text = @"No Accessory";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (1 == indexPath.row % 3) {
        cell.textLabel.text = @"Disclosure Indicator";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (2 == indexPath.row % 3) {
        cell.textLabel.text = @"Checkmark";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.detailTextLabel.text = @"Detail text";
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellClassNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (0 == section) ? _addCount : 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.cellClassNames[section];
}

@end
