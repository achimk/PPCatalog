//
//  PPCRotationsTableViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 27.07.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCRotationsTableViewController.h"

#import "PPCRotationViewController.h"

typedef enum {
    kRotationRowViewController  = 0,
    kRotationRowNavigationController,
    kRotationRowTabBarController,
    kRotationRowCount
} PPCRotationRows;

#pragma mark - PPCRotationsTableViewController

@interface PPCRotationsTableViewController ()
@end

#pragma mark -

@implementation PPCRotationsTableViewController

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PPTableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case kRotationRowViewController: {
            PPCRotationViewController * viewController = [PPCRotationViewController new];
            viewController.visibleModeOnly = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case kRotationRowNavigationController: {
            PPCRotationViewController * viewController = [PPCRotationViewController new];
            viewController.visibleModeOnly = NO;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case kRotationRowTabBarController: {
            UITabBarController * tabBarController = [UITabBarController new];
            NSMutableArray * viewControllers = [NSMutableArray array];
            NSMutableArray * items = [NSMutableArray array];
            NSArray * backgroundColors = @[[UIColor pp_colorWithRGBHex:PPColorClouds],
                                           [UIColor pp_colorWithRGBHex:PPColorConcrete],
                                           [UIColor pp_colorWithRGBHex:PPColorWetAsphalt],
                                           [UIColor pp_colorWithRGBHex:PPColorBelizeHole]];
            NSArray * titles = @[@"Clouds",
                                 @"Concrete",
                                 @"Wet Asphalt",
                                 @"Belize Hole"];
            
            for (NSUInteger i = 0; i < backgroundColors.count; i++) {
                UIViewController * viewController = [PPCRotationViewController new];
                viewController.view.backgroundColor = [backgroundColors objectAtIndex:i];
                [viewControllers addObject:viewController];
                UITabBarItem * item = [UITabBarItem new];
                item.title = [titles objectAtIndex:i];
                [items addObject:item];
            }
            
            tabBarController.viewControllers = viewControllers;

            for (NSUInteger i = 0; i < titles.count; i++) {
                UITabBarItem * item = tabBarController.tabBar.items[i];
                item.title = [titles objectAtIndex:i];
            }
            
            
            [self.navigationController pushViewController:tabBarController animated:YES];
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    switch (indexPath.row) {
        case kRotationRowViewController: {
            cell.textLabel.text = @"Rotate View Controller";
            break;
        }
        case kRotationRowNavigationController: {
            cell.textLabel.text = @"Rotate Navigation Controller";
            break;
        }
        case kRotationRowTabBarController: {
            cell.textLabel.text = @"Rotate Tab Bar Controller";
            break;
        }
        default: {
            break;
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kRotationRowCount;
}

@end
