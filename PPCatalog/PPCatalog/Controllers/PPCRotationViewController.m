//
//  PPCRotationViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 27.07.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCRotationViewController.h"

NSString * const kAutorotationModeDidChangeNotificaiton     = @"autorotationModeDidChangeNotificaiton";

@interface PPCRotationViewController  ()
- (void)changeAutorotationModeNotification:(NSNotification *)aNotification;
- (void)setAutorotationMode:(PPAutorotationMode)autorotationMode;
- (PPAutorotationMode)autorotationMode;
@end

#pragma mark -

@implementation PPCRotationViewController

@synthesize containerView = _containerView;
@synthesize portraitLabel = _portraitLabel;
@synthesize landscapeRightLabel = _landscapeRightLabel;
@synthesize landscapeLeftLabel = _landscapeLeftLabel;
@synthesize upsideDownLabel = _upsideDownLabel;
@synthesize autorotationLabel = _autorotationLabel;
@synthesize portraitSwitch = _portraitSwitch;
@synthesize landscapeRightSwitch = _landscapeRightSwitch;
@synthesize landscapeLeftSwitch = _landscapeLeftSwitch;
@synthesize upsideDownSwitch = _upsideDownSwitch;
@synthesize autorotationSegmentedControl = _autorotationSegmentedControl;
@synthesize visibleModeOnly = _visibleModeOnly;


#pragma mark Init/Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeAutorotationModeNotification:)
                                                     name:kAutorotationModeDidChangeNotificaiton
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAutorotationModeDidChangeNotificaiton object:nil];
    self.tabBarController.autorotationMode = PPAutorotationModeContainer;
    self.navigationController.autorotationMode = PPAutorotationModeContainer;
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView.backgroundColor = [UIColor clearColor];
    self.portraitSwitch.on = YES;
    self.landscapeRightSwitch.on = YES;
    self.landscapeLeftSwitch.on = YES;
    self.upsideDownSwitch.on = YES;
    
    if (self.visibleModeOnly) {
        self.autorotationLabel.hidden = self.visibleModeOnly;
        self.autorotationSegmentedControl.hidden = self.visibleModeOnly;
        self.autorotationSegmentedControl.selectedSegmentIndex = 3;
        self.autorotationMode = PPAutorotationModeContainerAndTopChildren;
    }
}

#pragma mark Accessors

- (void)setAutorotationMode:(PPAutorotationMode)autorotationMode {
    if (self.tabBarController) {
        //is parent for tab bar controller - accept top children
        self.navigationController.autorotationMode = PPAutorotationModeContainerAndTopChildren;
        self.tabBarController.autorotationMode = autorotationMode;
    }
    else if (self.navigationController) {
        self.navigationController.autorotationMode = autorotationMode;
    }
    else {
        NSAssert(NO, @"Rotation view controller has not parent container view controller");
    }
}

- (PPAutorotationMode)autorotationMode {
    if (self.tabBarController) {
        return self.tabBarController.autorotationMode;
    }
    else if (self.navigationController) {
        return self.navigationController.autorotationMode;
    }
    else {
        NSAssert(NO, @"Rotation view controller has not parent container view controller");
        return PPAutorotationModeContainer;
    }
}

#pragma mark Actions

- (IBAction)changeAutorotationMode:(id)sender {
    switch (self.autorotationSegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.autorotationMode = PPAutorotationModeContainer;
            break;
        }
        case 1: {
            self.autorotationMode = PPAutorotationModeContainerAndNoChildren;
            break;
        }
        case 2: {
            self.autorotationMode = PPAutorotationModeContainerAndTopChildren;
            break;
        }
        case 3: {
            self.autorotationMode = PPAutorotationModeContainerAndAllChildren;
            break;
        }
        default: {
            NSAssert1(NO, @"Unsupported autorotation mode: %d", self.autorotationSegmentedControl.selectedSegmentIndex);
            break;
        }
    }
    
    NSDictionary * userInfo = @{@"autorotationMode"     : @(self.autorotationMode),
                                @"selectedIndex"        : @(self.autorotationSegmentedControl.selectedSegmentIndex)};
    [[NSNotificationCenter defaultCenter] postNotificationName:kAutorotationModeDidChangeNotificaiton
                                                        object:nil
                                                      userInfo:userInfo];
}

#pragma mark Notifications

- (void)changeAutorotationModeNotification:(NSNotification *)aNotification {
    NSDictionary * userInfo = [aNotification userInfo];
    NSUInteger autorotationMode = [[userInfo objectForKey:@"autorotationMode"] unsignedIntegerValue];
    NSUInteger selectedIndex = [[userInfo objectForKey:@"selectedIndex"] unsignedIntegerValue];
    
    if (selectedIndex != self.autorotationSegmentedControl.selectedSegmentIndex) {
        self.autorotationSegmentedControl.selectedSegmentIndex = selectedIndex;
    }
    
    if (autorotationMode != self.autorotationMode) {
        self.autorotationMode = autorotationMode;
    }
}

#pragma mark Orientations

- (NSUInteger)supportedInterfaceOrientations {
    NSUInteger supportedInterfaceOrientations = 0;
    
    if ([self isViewLoaded]) {
        if (self.portraitSwitch.isOn) {
            supportedInterfaceOrientations |= UIInterfaceOrientationMaskPortrait;
        }
        if (self.landscapeRightSwitch.isOn) {
            supportedInterfaceOrientations |= UIInterfaceOrientationMaskLandscapeRight;
        }
        if (self.landscapeLeftSwitch.isOn) {
            supportedInterfaceOrientations |= UIInterfaceOrientationMaskLandscapeLeft;
        }
        if (self.upsideDownSwitch.isOn) {
            supportedInterfaceOrientations |= UIInterfaceOrientationMaskPortraitUpsideDown;
        }
    }
    else {
        supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    }
    
    return [super supportedInterfaceOrientations] & supportedInterfaceOrientations;
}

@end
