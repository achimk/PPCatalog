//
//  PPCOperationTableViewCell.h
//  PPCatalog
//
//  Created by Joachim Kret on 26.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPTableViewCell.h"

@interface PPCOperationTableViewCell : PPTableViewCell

@property (nonatomic, readwrite, strong) IBOutlet UILabel * numberOfOperationsLabel;
@property (nonatomic, readwrite, strong) IBOutlet UILabel * sleepTimeLabel;

@property (nonatomic, readwrite, strong) IBOutlet UISlider * operationsSlider;
@property (nonatomic, readwrite, strong) IBOutlet UISlider * timeSlider;

@property (nonatomic, readwrite, strong) IBOutlet UIProgressView * progressView;

@property (nonatomic, readwrite, strong) IBOutlet UIButton * startButton;

@end
