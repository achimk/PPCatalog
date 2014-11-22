//
//  PPMasterViewController.h
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPDetailViewController;

#import <CoreData/CoreData.h>

@interface PPMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) PPDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
