//
//  PPCEventEntity.m
//  PPCatalog
//
//  Created by Joachim Kret on 10.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCEventEntity.h"

@implementation PPCEventEntity

@dynamic timeStamp;

+ (NSString *)entityName {
    return @"Event";
}

+ (NSString *)defaultLocalKey {
    return @"timeStamp";
}

+ (NSArray *)sortDescriptors {
    return @[[NSSortDescriptor sortDescriptorWithKey:[self defaultLocalKey] ascending:YES]];
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.timeStamp = [NSDate date];
}

@end
