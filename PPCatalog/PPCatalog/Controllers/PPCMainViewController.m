//
//  PPCMainViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCMainViewController.h"

#import "AppDelegate.h"

#import "PPCRotationsTableViewController.h"

#import "PPCPlainCellTableViewController.h"
#import "PPCGroupCellTableViewController.h"
#import "PPCLoadingTableViewController.h"
#import "PPCManagedTableViewController.h"
#import "PPCManagedLoadingTableViewController.h"

#import "PPCCollectionViewController.h"
#import "PPCCollectionLayoutsViewController.h"
#import "PPCLoadingCollectionViewController.h"
#import "PPCManagedCollectionViewController.h"
#import "PPCManagedLoadingCollectionViewController.h"

#import "PPCSSIDViewController.h"

typedef enum {
    kMainSectionRotation        = 0,
    kMainSectionUtilities,
    kMainSectionSheetControllers,
    kMainSectionTableViewControllers,
    kMainSectionCollectionViewControllers,
    kMainSectionInformations,
    kMainSectionCount
} PPCMainSections;

typedef enum {
    kMainRowRotationTest        = 0,
    kMainRowRotationCount
} PPCMainSectionRotationRows;

typedef enum {
    kMainRowUtilityOperations   = 0,
    kMainRowUtitityTimers,
    kMainRowUtilityCount
} PPCMainSectionUtilityRows;

typedef enum {
    kMainRowSheetController     = 0,
    kMainRowSemiSheetController,
    kMainRowSheetControllerCount
} PPCMainSectionSheetControllersRows;

typedef enum {
    kMainRowTableViewPlainCell  = 0,
    kMainRowTableViewGroupCell,
    kMainRowTableViewLoading,
    kMainRowTableViewManaged,
    kMainRowTableViewManagedLoading,
    kMainRowTableViewCount
} PPCMainSectionTableViewRows;

typedef enum {
    kMainRowCollectionViewCell  = 0,
    kMainRowCollectionViewLayout,
    kMainRowCollectionViewLoading,
    kMainRowCollectionViewManaged,
    kMainRowCollectionViewManagedLoading,
    kMainRowCollectionViewCount
} PPCMainSectionCollectionViewRows;

typedef enum {
    kMainRowInformationSSID     = 0,
    kMainRowInformationCount
} PPCMainSectionInformationRows;

@implementation PPCMainViewController

+ (Class)defaultTableViewCellClass {
    return [PPTableViewCell class];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LogVerbose(@"Segue: %@", [segue identifier]);
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kMainSectionRotation: {
            switch (indexPath.row) {
                case kMainRowRotationTest: {
                    PPCRotationsTableViewController * viewController = [PPCRotationsTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionUtilities: {
            switch (indexPath.row) {
                case kMainRowUtilityOperations: {
                    [self performSegueWithIdentifier:@"OperationsViewController" sender:self];
                    break;
                }
                case kMainRowUtitityTimers: {
                    LogTrace();
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionSheetControllers: {
            switch (indexPath.row) {
                case kMainRowSheetController: {
                    [self performSegueWithIdentifier:@"SheetViewController" sender:self];
                    break;
                }
                case kMainRowSemiSheetController: {
                    [self performSegueWithIdentifier:@"SemiSheetViewController" sender:self];
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case kMainSectionTableViewControllers: {
            switch (indexPath.row) {
                case kMainRowTableViewPlainCell: {
                    PPCPlainCellTableViewController * viewController = [PPCPlainCellTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowTableViewGroupCell: {
                    PPCGroupCellTableViewController * viewController = [PPCGroupCellTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowTableViewLoading: {
                    PPCLoadingTableViewController * viewController = [PPCLoadingTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowTableViewManaged: {
                    PPCManagedTableViewController * viewController = [PPCManagedTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowTableViewManagedLoading: {
                    PPCManagedLoadingTableViewController * viewController = [PPCManagedLoadingTableViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionCollectionViewControllers: {
            switch (indexPath.row) {
                case kMainRowCollectionViewCell: {
                    PPCCollectionViewController * viewController = [PPCCollectionViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowCollectionViewLayout: {
                    PPCCollectionLayoutsViewController * viewController = [PPCCollectionLayoutsViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowCollectionViewLoading: {
                    PPCLoadingCollectionViewController * viewController = [PPCLoadingCollectionViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowCollectionViewManaged: {
                    PPCManagedCollectionViewController * viewController = [PPCManagedCollectionViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                case kMainRowCollectionViewManagedLoading: {
                    PPCManagedLoadingCollectionViewController * viewController = [PPCManagedLoadingCollectionViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionInformations: {
            switch (indexPath.row) {
                case kMainRowInformationSSID: {
                    UIViewController * viewController = [PPCSSIDViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        default: {
            break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case kMainSectionRotation: {
            switch (indexPath.row) {
                case kMainRowRotationTest: {
                    cell.textLabel.text = @"Rotations";
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionUtilities: {
            switch (indexPath.row) {
                case kMainRowUtilityOperations: {
                    cell.textLabel.text = @"Operations";
                    break;
                }
                case kMainRowUtitityTimers: {
                    cell.textLabel.text = @"Timers";
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionSheetControllers: {
            switch (indexPath.row) {
                case kMainRowSheetController: {
                    cell.textLabel.text = @"Sheet Controller";
                    break;
                }
                case kMainRowSemiSheetController: {
                    cell.textLabel.text = @"Semi Sheet Controller";
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
        case kMainSectionTableViewControllers: {
            switch (indexPath.row) {
                case kMainRowTableViewPlainCell: {
                    cell.textLabel.text = @"Plain Cells";
                    break;
                }
                case kMainRowTableViewGroupCell: {
                    cell.textLabel.text = @"Group Cells";
                    break;
                }
                case kMainRowTableViewLoading: {
                    cell.textLabel.text = @"Loading Table View";
                    break;
                }
                case kMainRowTableViewManaged: {
                    cell.textLabel.text = @"Managed Table View";
                    break;
                }
                case kMainRowTableViewManagedLoading: {
                    cell.textLabel.text = @"Managed Loading Table View";
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionCollectionViewControllers: {
            switch (indexPath.row) {
                case kMainRowCollectionViewCell: {
                    cell.textLabel.text = @"Cells";
                    break;
                }
                case kMainRowCollectionViewLayout: {
                    cell.textLabel.text = @"Layouts";
                    break;
                }
                case kMainRowCollectionViewLoading: {
                    cell.textLabel.text = @"Loading Collection View";
                    break;
                }
                case kMainRowCollectionViewManaged: {
                    cell.textLabel.text = @"Managed Collection View";
                    break;
                }
                case kMainRowCollectionViewManagedLoading: {
                    cell.textLabel.text = @"Managed Loading Collection View";
                    break;
                }
                default: {
                    break;
                }
            }
            
            break;
        }
        case kMainSectionInformations: {
            switch (indexPath.row) {
                case kMainRowInformationSSID: {
                    cell.textLabel.text = @"SSID";
                    break;
                }
                default: {
                    break;
                }
            }
        }
        default: {
            break;
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kMainSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case kMainSectionRotation: {
            return kMainRowRotationCount;
        }
        case kMainSectionUtilities: {
            return kMainRowUtilityCount;
        }
        case kMainSectionSheetControllers: {
            return kMainRowSheetControllerCount;
        }
        case kMainSectionTableViewControllers: {
            return kMainRowTableViewCount;
        }
        case kMainSectionCollectionViewControllers: {
            return kMainRowCollectionViewCount;
        }
        case kMainSectionInformations: {
            return kMainRowInformationCount;
        }
        default: {
            return 0;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kMainSectionRotation: {
            return @"Rotations";
        }
        case kMainSectionUtilities: {
            return @"Utilities";
        }
        case kMainSectionSheetControllers: {
            return @"Sheet Controllers";
        }
        case kMainSectionTableViewControllers: {
            return @"Table View Controllers";
        }
        case kMainSectionCollectionViewControllers: {
            return @"Collection View Controllers";
        }
        case kMainSectionInformations: {
            return @"Informations";
        }
        default: {
            return nil;
        }
    }
}

@end
