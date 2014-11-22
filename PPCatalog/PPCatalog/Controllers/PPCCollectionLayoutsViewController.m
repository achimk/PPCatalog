//
//  PPCCollectionLayoutsViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 13.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCCollectionLayoutsViewController.h"

#import "PPCLayoutCollectionViewController.h"

typedef enum {
    kPPCCollectionLayoutFlow    = 0,
    kPPCCollectionLayoutCount,
} PPCCollectionLayouts;

@interface PPCCollectionLayoutsViewController ()
@end

#pragma mark -

@implementation PPCCollectionLayoutsViewController

+ (Class)defaultTableViewCellClass {
    return [PPTableViewCell class];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewLayout * layout = nil;
    
    switch (indexPath.row) {
        case kPPCCollectionLayoutFlow: {
            PSUICollectionViewFlowLayout * flowLayout = [PSUICollectionViewFlowLayout new];
            flowLayout.minimumInteritemSpacing = 10.0f;
            flowLayout.minimumLineSpacing = 50.0f;
            flowLayout.itemSize = CGSizeMake(200.0f, 200.0f);
            flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
            flowLayout.headerReferenceSize = CGSizeMake(200.0f, 30.0f);
            flowLayout.footerReferenceSize = CGSizeMake(200.0f, 30.0f);
            layout = (PSUICollectionViewLayout *)flowLayout;
            break;
        }
        default: {
            break;
        }
    }
    
    if (layout) {
        PPCLayoutCollectionViewController * viewController = [[PPCLayoutCollectionViewController alloc] initWithCollectionViewLayout:layout];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case kPPCCollectionLayoutFlow: {
            cell.textLabel.text = @"PSUICollectionViewFlowLayout";
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
    return kPPCCollectionLayoutCount;
}

@end
