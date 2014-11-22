//
//  PPCEventEntity.h
//  PPCatalog
//
//  Created by Joachim Kret on 10.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPManagedObject.h"

@interface PPCEventEntity : PPManagedObject

@property (nonatomic, readwrite, strong) NSDate * timeStamp;

@end
