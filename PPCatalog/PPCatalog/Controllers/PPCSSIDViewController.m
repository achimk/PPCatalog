//
//  PPCSSIDViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 24.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCSSIDViewController.h"

@interface PPCSSIDViewController ()

- (id)_fetchSSIDInfo;

@end

@implementation PPCSSIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self _fetchSSIDInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods

- (id)_fetchSSIDInfo {
    /*
    CFArrayRef myArray = CNCopySupportedInterfaces();
    CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));

    NSArray * interfaces = CFBridgingRelease(myArray);
    NSDictionary * currentNetworkInfo = CFBridgingRelease(myDict);
    
    LogVerbose(@"interfaces:\n%@", interfaces);
    LogVerbose(@"current:\n%@", currentNetworkInfo);
    */
    
    return nil;
}

@end
