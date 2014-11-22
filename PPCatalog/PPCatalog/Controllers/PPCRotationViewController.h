//
//  PPCRotationViewController.h
//  PPCatalog
//
//  Created by Joachim Kret on 27.07.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPViewController.h"

@interface PPCRotationViewController : PPViewController

@property (nonatomic, readwrite, strong) IBOutlet UIView * containerView;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * portraitLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * landscapeRightLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * landscapeLeftLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * upsideDownLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * autorotationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * portraitSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * landscapeRightSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * landscapeLeftSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * upsideDownSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UISegmentedControl * autorotationSegmentedControl;
@property (nonatomic, readwrite, assign) BOOL visibleModeOnly;

- (IBAction)changeAutorotationMode:(id)sender;

@end
