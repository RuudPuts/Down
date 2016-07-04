//
//  RPPortScanWorker.h
//  Down
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPPortScanJob;
@protocol RPPortScanWorkerDelegate;

@interface RPPortScanWorker : NSThread

@property (nonatomic, assign, readonly) NSInteger workerId;
@property (nonatomic, strong) id<RPPortScanWorkerDelegate> delegate; // Don't ask me why, but when using this in swift the delegate needs to be strong or will be nilified after assinging.
@property (nonatomic, assign, readonly) float progress;

- (RPPortScanWorker *)initWithId:(NSInteger)workerId;
- (void)addJob:(RPPortScanJob *)job;

@end

@protocol RPPortScanWorkerDelegate <NSObject>

- (void)portScanWorker:(RPPortScanWorker *)worker progressChanges:(float)progress;
- (void)portScanWorker:(RPPortScanWorker *)worker jobFinishedSuccessfull:(RPPortScanJob *)job;
- (void)portScanWorkerCompletedAllJobs:(RPPortScanWorker *)worker;

@end