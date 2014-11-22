//
//  PPCSemiSheetViewController.h
//  PPCatalog
//
//  Created by Joachim Kret on 18.12.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPViewController.h"

@interface PPCSemiSheetViewController : PPViewController

@property (nonatomic, readwrite, strong) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic, readwrite, strong) IBOutlet UISlider * widthSlider;
@property (nonatomic, readwrite, strong) IBOutlet UISlider * heightSlider;
@property (nonatomic, readwrite, strong) IBOutlet UISlider * durationSlider;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * widthLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * heightLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * durationLabel;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * animatedSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UISwitch * callAppearanceSwitch;
@property (nonatomic, readwrite, strong) IBOutlet UIButton * showButton;

- (IBAction)widthSliderChange:(id)sender;
- (IBAction)heightSliderChange:(id)sender;
- (IBAction)durationSliderChange:(id)sender;
- (IBAction)showAction:(id)sender;

@end
