//
//  PPCCoreDataStore.m
//  PPCatalog
//
//  Created by Joachim Kret on 27.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCCoreDataStore.h"

static NSString * const PPCExeptionAddPersistentStore    = @"ExeptionAddPersistentStore";

@implementation PPCCoreDataStore

+ (instancetype)sharedInstance {
    static PPCCoreDataStore * __sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [PPCCoreDataStore new];
    });
    
    return __sharedInstance;
}

- (void)setup {
    if (!self.persistentStoreCoordinator.persistentStores.count) {
        NSError * error = nil;
        [self addInMemoryPersistentStore:&error];
        
        if (error) {
            [NSException raise:PPCExeptionAddPersistentStore format:@"Error adding persistent store: %@", error];
        }
    }
}

@end
