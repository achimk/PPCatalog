//
//  PPCOperationsViewController.m
//  PPCatalog
//
//  Created by Joachim Kret on 25.09.2013.
//  Copyright (c) 2013 Joachim Kret. All rights reserved.
//

#import "PPCOperationsViewController.h"

#import "PPOperation.h"
#import "PPKVOOperation.h"
#import "PPDispatchOperation.h"
#import "PPGroupOperation.h"
#import "PPOperationStateMachine.h"
#import "PPProgressObserver.h"
#import "PPOperationQueue.h"

#import "PPCOperationTableViewCell.h"

#define kDefaultNumberOfOperations      10

typedef enum {
    kPPCOperationSectionNormalQueue = 0,
    kPPCOperationSectionConcurrentQueue,
    kPPCOperationSectionDispatchQueue,
    kPPCOperationSectionCount
} PPCOperationSection;

#pragma mark PPCOperationSleepTimeProtocol

@protocol PPCOperationSleepTimeProtocol <NSObject>

@required
- (void)setSleepTime:(NSUInteger)sleepTime;
- (NSUInteger)sleepTime;

@end

#pragma mark - PPCOperation

@interface PPCOperation : PPOperation <PPCOperationSleepTimeProtocol>
@property (nonatomic, readwrite, assign) NSUInteger sleepTime;
@end

@implementation PPCOperation

@synthesize sleepTime;

- (void)execute {
    if (!self.isCancelled) {
        LogVerbose(@"execute: %@", self.identifier);
        sleep(self.sleepTime);
    }
    
    [self finish];
}

@end

#pragma mark - PPCKVOOpeation

@interface PPCKVOOpeation : PPKVOOperation <PPCOperationSleepTimeProtocol>
@property (nonatomic, readwrite, assign) NSUInteger sleepTime;
@end

@implementation PPCKVOOpeation

@synthesize sleepTime;

- (void)execute {
    if (!self.isCancelled) {
        LogVerbose(@"execute: %@", self.identifier);
        sleep(self.sleepTime);
    }
    
    [self finish];
}

@end

#pragma mark - PPCDispatchOperation

@interface PPCDispatchOperation : PPDispatchOperation <PPCOperationSleepTimeProtocol>
@property (nonatomic, readwrite, assign) NSUInteger sleepTime;
@end

@implementation PPCDispatchOperation

@synthesize sleepTime;

- (void)execute {
    if (!self.isCancelled) {
        LogVerbose(@"execute: %@", self.identifier);
        sleep(self.sleepTime);
    }
    
    [self.operationStateMachine finish];
}

@end

#pragma mark - PPCOperationsViewController

@interface PPCOperationsViewController () <PPOperationDelegate, PPProgressObserverDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray * queues;
@property (nonatomic, readwrite, strong) NSMutableArray * operationsClasses;
@property (nonatomic, readwrite, strong) NSMutableArray * progressObservers;
@property (nonatomic, readwrite, strong) NSMutableArray * queueData;

- (void)finishInitialize;
- (PPOperationQueue *)operationQueueForSection:(PPCOperationSection)section;
- (Class)operationClassForSection:(PPCOperationSection)section;
- (PPProgressObserver *)progressObserverForSection:(PPCOperationSection)section;
- (NSDictionary *)dictionaryDataForSection:(PPCOperationSection)section;

@end

#pragma mark -

@implementation PPCOperationsViewController

@synthesize queues = _queues;
@synthesize operationsClasses = _operationsClasses;
@synthesize progressObservers = _progressObservers;
@synthesize queueData = _queueData;

#pragma mark Init / Dealloc

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInitialize];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self finishInitialize];
    }
    
    return self;
}

- (void)finishInitialize {
    _queues = [NSMutableArray new];
    _operationsClasses = [NSMutableArray new];
    _progressObservers = [NSMutableArray new];
    _queueData = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < kPPCOperationSectionCount; i++) {
        PPOperationQueue * operationQueue = nil;
        Class operationClass = nil;
        PPProgressObserver * progressObserver = [PPProgressObserver new];
        progressObserver.delegate = self;
        
        switch (i) {
            case kPPCOperationSectionNormalQueue: {
                operationQueue = [PPOperationQueue new];
                operationQueue.queue.maxConcurrentOperationCount = 1;
                operationClass = [PPCOperation class];
                break;
            }
            case kPPCOperationSectionConcurrentQueue: {
                operationQueue = [PPOperationQueue new];
                operationQueue.queue.maxConcurrentOperationCount = 3;
                operationClass = [PPCKVOOpeation class];
                break;
            }
            case kPPCOperationSectionDispatchQueue: {
                operationQueue = [PPOperationQueue new];
                operationQueue.queue.maxConcurrentOperationCount = 3;
                operationClass = [PPCDispatchOperation class];
                break;
            }
            default: {
                NSAssert1(NO, @"Usupported section: %d", i);
                break;
            }
        }
        
        [_queues addObject:operationQueue];
        [_operationsClasses addObject:operationClass];
        [_progressObservers addObject:progressObserver];
        
        NSMutableDictionary * dictionary = [NSMutableDictionary new];
        dictionary[@"operationsCount"] = @(10);
        dictionary[@"sleepTime"] = @(1);
        dictionary[@"isGrouped"] = @(YES);
        
        [_queueData addObject:dictionary];
    }
}

- (void)dealloc {
    LogTrace();
}

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction:)];
}

#pragma mark Actions

- (IBAction)operationsCountAction:(id)sender {
    LogTrace();
}

- (IBAction)sleepTimeAction:(id)sender {
    LogTrace();
}

- (IBAction)startAction:(id)sender {
    LogTrace();
    
    NSAssert([sender isKindOfClass:[UIButton class]], @"Sender must be kind of 'UIButton' class.");
    UIButton * button = (UIButton *)sender;
    
    if (!button) {
        return;
    }
    
    PPCOperationSection section = button.tag;
    PPOperationQueue * operationQueue = [self operationQueueForSection:section];

    if (!operationQueue) {
        return;
    }
    else if (operationQueue.isExecuting) {
        [self cancelAction:sender];
        return;
    }
    
    LogNotice(@"Start operations");
    
    NSMutableArray * operations = [NSMutableArray array];
    Class operationClass = [self operationClassForSection:section];
    NSDictionary * dictionary = [self dictionaryDataForSection:section];
    NSUInteger count = [[dictionary objectForKey:@"operationsCount"] unsignedIntegerValue];
    NSUInteger sleepTime = [[dictionary objectForKey:@"sleepTime"] unsignedIntegerValue];
    BOOL isGrouped = [[dictionary objectForKey:@"isGrouped"] boolValue];
    
    for (NSUInteger i = 0; i < count; i++) {
        PPOperation * operation = [[operationClass alloc] initWithIdentifier:[NSString stringWithFormat:@"%d-%d", section, i]];
        [(id <PPCOperationSleepTimeProtocol>)operation setSleepTime:sleepTime];
        operation.delegate = self;
        
        [operation setCompletionBlockWithSuccess:^(PPOperation * operation) {
            LogNotice(@"Operation success: %@", operation.identifier);
        } failure:^(PPOperation * operation, NSError * error) {
            LogWarn(@"Operation failure: %@, is cancelled: %@", operation.identifier, PPStringFromBool(operation.isCancelled));
        }];
        
        [operations addObject:operation];
    }
    
    if (operations.count && isGrouped) {
        PPGroupOperation * groupOperation = [[PPGroupOperation alloc] initWithIdentifier:[NSString stringWithFormat:@"group-%d", section]];
        groupOperation.delegate = self;
        
        [groupOperation setCompletionBlockWithSuccess:^(PPOperation * operation) {
            LogNotice(@"Group operation success: %@", operation.identifier);
        } failure:^(PPOperation * operation, NSError * error) {
            LogWarn(@"Group operation failure: %@, is cancelled: %@", operation.identifier, PPStringFromBool(operation.isCancelled));
        }];
        
        for (PPOperation * operation in operations) {
            [groupOperation addDependency:operation];
        }
        
        [operations addObject:groupOperation];
    }
    
    PPProgressObserver * progressObserver = [self progressObserverForSection:section];
    [operationQueue addProgressObserver:progressObserver];
    [operationQueue addOperations:operations waitUntilFinished:NO];
}

- (IBAction)cancelAction:(id)sender {
    NSAssert([sender isKindOfClass:[UIButton class]], @"Sender must be kind of 'UIButton' class.");
    UIButton * button = (UIButton *)sender;
    
    if (!button) {
        return;
    }
    
    PPCOperationSection section = button.tag;
    PPOperationQueue * operationQueue = [self operationQueueForSection:section];
    
    if (!operationQueue || !operationQueue.isExecuting) {
        return;
    }
    
    LogNotice(@"Cancel operations");
    
    NSDictionary * dictionary = [self dictionaryDataForSection:section];
    BOOL isGrouped = [[dictionary objectForKey:@"isGrouped"] boolValue];
    
    if (isGrouped) {
        for (id operation in [operationQueue.operations allValues]) {
            if ([operation isKindOfClass:[PPGroupOperation class]]) {
                LogWarn(@"Cancelling group operation");
                [operation cancel];
                break;
            }
        }
    }
    else {
        LogWarn(@"Cancelling all operations");
        [operationQueue cancelAllOperations];
    }
}

- (IBAction)backAction:(id)sender {
    for (PPOperationQueue * queue in self.queues) {
        [queue cancelAllOperations];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OperationTableViewCell"];

    if ([cell isKindOfClass:[PPCOperationTableViewCell class]]) {
        NSDictionary * dictionary = [self.queueData objectAtIndex:indexPath.section];
        
        PPCOperationTableViewCell * operationCell = (PPCOperationTableViewCell *)cell;
        operationCell.operationsSlider.value = [dictionary[@"operationsCount"] floatValue];
        operationCell.operationsSlider.tag = indexPath.section;
        [operationCell.operationsSlider addTarget:self action:@selector(operationsCountAction:) forControlEvents:UIControlEventValueChanged];
        
        operationCell.timeSlider.value = [dictionary[@"sleepTime"] floatValue];
        operationCell.timeSlider.tag = indexPath.section;
        [operationCell.timeSlider addTarget:self action:@selector(sleepTimeAction:) forControlEvents:UIControlEventValueChanged];
        
        operationCell.startButton.tag = indexPath.section;
        [operationCell.startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kPPCOperationSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kPPCOperationSectionNormalQueue: {
            return @"PPOperation";
        }
        case kPPCOperationSectionConcurrentQueue: {
            return @"PPKVOOperation";
        }
        case kPPCOperationSectionDispatchQueue: {
            return @"PPDispatchOperation";
        }
        default: {
            return nil;
        }
    }
}

#pragma mark PPOperationDelegate

- (void)operationDidStart:(PPOperation *)operation {
    //LogVerbose(@"operation start: %@", operation.identifier);
}

- (void)operationDidFinish:(PPOperation *)operation {
    //LogVerbose(@"operation finish: %@", operation.identifier);
}

#pragma mark PPProgressObserverDelegate

- (void)progressObserver:(PPProgressObserver *)progressObserver didProgress:(float)progress {
    //LogVerbose(@"progress observer: %@ did progress: %f", progressObserver, progress);
}

- (void)progressObserverDidComplete:(PPProgressObserver *)progressObserver {
    //LogNotice(@"progress observer did complete: %@", progressObserver);
}

#pragma mark Private Methods

- (PPOperationQueue *)operationQueueForSection:(PPCOperationSection)section {
    return [self.queues objectAtIndex:section];
}

- (Class)operationClassForSection:(PPCOperationSection)section {
    return [self.operationsClasses objectAtIndex:section];
}

- (PPProgressObserver *)progressObserverForSection:(PPCOperationSection)section {
    return [self.progressObservers objectAtIndex:section];
}

- (NSDictionary *)dictionaryDataForSection:(PPCOperationSection)section {
    return [self.queueData objectAtIndex:section];
}

@end
