//
//  PPCOperationTableViewCell.m
//  PPCatalog
//
//  Created by Joachim Kret on 26.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCOperationTableViewCell.h"

@implementation PPCOperationTableViewCell

@synthesize numberOfOperationsLabel = _numberOfOperationsLabel;
@synthesize sleepTimeLabel = _sleepTimeLabel;

@synthesize operationsSlider = _operationsSlider;
@synthesize timeSlider = _timeSlider;

@synthesize progressView = _progressView;

@synthesize startButton = _startButton;

#pragma mark Initialize

- (void)finishInitialize {
    [super finishInitialize];

    self.numberOfOperationsLabel.text = @"1";
    self.sleepTimeLabel.text = @"1";
    
    self.operationsSlider.minimumValue = 1.0f;
    self.operationsSlider.maximumValue = 40.0f;
    self.operationsSlider.value = 1.0f;
    
    self.timeSlider.minimumValue = 1.0f;
    self.timeSlider.maximumValue = 10.0f;
    self.timeSlider.value = 1.0f;
    
    self.progressView.progress = 0.0f;
}

#pragma mark Prepare For Reuse

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.numberOfOperationsLabel.text = @"1";
    self.sleepTimeLabel.text = @"1";
    
    self.operationsSlider.value = 1.0f;
    self.timeSlider.value = 1.0f;
    
    self.progressView.progress = 0.0f;
    
    [self.startButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

@end
