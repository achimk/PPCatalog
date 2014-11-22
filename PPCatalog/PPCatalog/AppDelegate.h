//
//  AppDelegate.h
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readwrite, strong) UIWindow * window;

+ (NSManagedObjectContext *)defaultManagedObjectContext;

@end
