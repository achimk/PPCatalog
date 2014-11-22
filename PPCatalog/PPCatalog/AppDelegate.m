//
//  AppDelegate.m
//  PPCatalog
//
//  Created by Joachim Kret on 29.06.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "AppDelegate.h"

#define kForceToOffLogging      0

@interface AppDelegate ()
- (void)_applyStyles;
@end

#pragma mark -

@implementation AppDelegate

+ (NSManagedObjectContext *)defaultManagedObjectContext {
    return [[PPCCoreDataStore sharedInstance] privateContext];
}

#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if DEBUG && !kForceToOffLogging
    setenv("XcodeColors", "YES", 0);
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //Xcode colors plugin: https://github.com/robbiehanson/XcodeColors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorPomegranate] backgroundColor:nil forFlag:LOG_FLAG_ERROR];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorCarrot] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorEmerland] backgroundColor:nil forFlag:LOG_FLAG_SUCCESS];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorClouds] backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorBelizeHole] backgroundColor:nil forFlag:LOG_FLAG_NOTICE];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorSilver] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor pp_colorWithRGBHex:PPColorWisteria] backgroundColor:nil forFlag:LOG_FLAG_TRACE];
#endif
    
    //setup core data stack
    [PPCCoreDataStore sharedInstance];

    //!!!: ignore apply styles
    //[self _applyStyles];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark Supported Orientations For Window

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark Private Methods

- (void)_applyStyles {
    //table view
    [[PPTableView appearance] setBackgroundView:nil];
    
    //cell background normal state
    [[PPTableCellBackgroundView appearance] setSeparatorColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[PPTableCellBackgroundView appearance] setBackgroundColor:[UIColor pp_colorWithRGBHex:PPColorGreenSea] forState:UIControlStateNormal];
    [[PPTableCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateNormal];
    
    //cell background highlight state
    [[PPTableCellBackgroundView appearance] setSeparatorColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [[PPTableCellBackgroundView appearance] setBackgroundColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateHighlighted];
    [[PPTableCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateHighlighted];
    
    //cell background selected state
    [[PPTableCellBackgroundView appearance] setSeparatorColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [[PPTableCellBackgroundView appearance] setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [[PPTableCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateSelected];
    
    NSDictionary * textAttributes = @{NSForegroundColorAttributeName  : [UIColor whiteColor]};
    NSDictionary * highlightedAttributes = @{NSForegroundColorAttributeName   : [UIColor pp_colorWithRGBHex:PPColorMidnightBlue]};
    NSDictionary * selectedAttibutes = @{NSForegroundColorAttributeName  : [UIColor pp_colorWithRGBHex:PPColorGreenSea]};
    
    //cell normal state
    [[PPTableViewCell appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPTableViewCell appearance] setDetailTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPTableViewCell appearance] setAccessoryTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPTableViewCell appearance] setAccessoryCellViewColor:[textAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    [[PPRightDetailTableViewCell appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPRightDetailTableViewCell appearance] setDetailTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPRightDetailTableViewCell appearance] setAccessoryTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPRightDetailTableViewCell appearance] setAccessoryCellViewColor:[textAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    [[PPSubtitleDetailTableViewCell appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPSubtitleDetailTableViewCell appearance] setDetailTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryCellViewColor:[textAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    
    //cell highlighted state
    [[PPTableViewCell appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPTableViewCell appearance] setDetailTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPTableViewCell appearance] setAccessoryTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPTableViewCell appearance] setAccessoryCellViewColor:[highlightedAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    
    [[PPRightDetailTableViewCell appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPRightDetailTableViewCell appearance] setDetailTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPRightDetailTableViewCell appearance] setAccessoryTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPRightDetailTableViewCell appearance] setAccessoryCellViewColor:[highlightedAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    
    [[PPSubtitleDetailTableViewCell appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPSubtitleDetailTableViewCell appearance] setDetailTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryCellViewColor:[highlightedAttributes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateHighlighted];
    
    //cell selected state
    [[PPTableViewCell appearance] setTitleTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPTableViewCell appearance] setDetailTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPTableViewCell appearance] setAccessoryTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPTableViewCell appearance] setAccessoryCellViewColor:[selectedAttibutes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    [[PPRightDetailTableViewCell appearance] setTitleTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPRightDetailTableViewCell appearance] setDetailTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPRightDetailTableViewCell appearance] setAccessoryTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPRightDetailTableViewCell appearance] setAccessoryCellViewColor:[selectedAttibutes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    [[PPSubtitleDetailTableViewCell appearance] setTitleTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPSubtitleDetailTableViewCell appearance] setDetailTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPSubtitleDetailTableViewCell appearance] setAccessoryCellViewColor:[selectedAttibutes valueForKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    //collection cell background normal state
    [[PPCollectionCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateNormal];
    [[PPCollectionCellBackgroundView appearance] setBackgroundColor:[UIColor pp_colorWithRGBHex:PPColorGreenSea] forState:UIControlStateNormal];
    
    //collection cell background highlighted state
    [[PPCollectionCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateHighlighted];
    [[PPCollectionCellBackgroundView appearance] setBackgroundColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateHighlighted];
    
    //collection cell background selected state
    [[PPCollectionCellBackgroundView appearance] setBorderColor:[UIColor pp_colorWithRGBHex:PPColorAsbestos] forState:UIControlStateSelected];
    [[PPCollectionCellBackgroundView appearance] setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    //collection cell normal state
    [[PPCollectionViewCell appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [[PPCollectionViewCell appearance] setDetailTextAttributes:textAttributes forState:UIControlStateNormal];
    
    //collection cell highlighted state
    [[PPCollectionViewCell appearance] setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [[PPCollectionViewCell appearance] setDetailTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //collection cell selected state
    [[PPCollectionViewCell appearance] setTitleTextAttributes:selectedAttibutes forState:UIControlStateSelected];
    [[PPCollectionViewCell appearance] setDetailTextAttributes:selectedAttibutes forState:UIControlStateSelected];
}

@end
