//
//  RPPortScanWorker.m
//  Down
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import "RPPortScanner.h"
#import "RPPortScanWorker.h"
#import "RPPortScanJob.h"
#import "FastSocket/FastSocket.h"

static NSInteger const kConnectTimeout = 1;

@interface RPPortScanWorker ()

@property (nonatomic, strong) NSMutableArray *jobLog;
@property (nonatomic, strong) NSMutableArray *jobs;

@end

@implementation RPPortScanWorker

- (RPPortScanWorker *)initWithId:(NSInteger)workerId {
    self = [super init];
    if (self) {
        _workerId = workerId;
        self.name = [NSString stringWithFormat:@"%@ %ld", NSStringFromClass([self class]), (long)self.workerId];
    }
    return self;
}

- (void)main {
    if (kPortScanLogginEnabled) {
        NSLog(@"%@ started", self.name);
    }
    NSInteger jobsCompleted = 0;
    for (RPPortScanJob *job in self.jobs) {
        if (self.isCancelled) {
            [self logJobMessage:@"Received cancel signal!"];
            [self dumpLog:job];
            return;
        }
        [self logJobMessage:[NSString stringWithFormat:@"Starting job %@", job]];
        
        @autoreleasepool {
            FastSocket *socket = [[FastSocket alloc] initWithHost:job.ipAddress andPort:job.port];
            BOOL succeeded = [socket connect:kConnectTimeout];
            [socket close];
            
            NSString *jobStatusMessage = nil;
            if (succeeded) {
                jobStatusMessage = [NSString stringWithFormat:@"Job %@ succeeded", job];
                
                [self.delegate portScanWorker:self jobFinishedSuccessfull:job];
            }
            else {
                jobStatusMessage = [NSString stringWithFormat:@"Job %@ failed", job];
            }
            [self logJobMessage:jobStatusMessage];
        }
        
        [self dumpLog:job];
        jobsCompleted++;
        _progress = ((float)jobsCompleted / (float)self.jobs.count * 100);
        [self.delegate portScanWorker:self progressChanges:self.progress];
    }
    
    if (kPortScanLogginEnabled) {
        NSLog(@"%@ didn't receive a job, bye bye", self.name);
    }
    [self.delegate portScanWorkerCompletedAllJobs:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> {Name: %@}", NSStringFromClass([self class]), self, self.name];
}

- (void)addJob:(RPPortScanJob *)job {
    if (!self.jobs) {
        self.jobs = [NSMutableArray array];
    }
    [self.jobs addObject:job];
}

#pragma mark - Job logging

- (void)logJobMessage:(NSString *)message {
    message = [NSString stringWithFormat:@"%@ - %@", [NSDate date], message];
    if (!self.jobLog) {
        self.jobLog = [NSMutableArray array];
    }
    [self.jobLog addObject:message];
}

- (void)dumpLog:(RPPortScanJob *)job {
    if (kPortScanLogginEnabled) {
        NSLog(@"%@ reporting on job %@\n%@", self.name, job, self.jobLog);
    }
    [self.jobLog removeAllObjects];
}

@end