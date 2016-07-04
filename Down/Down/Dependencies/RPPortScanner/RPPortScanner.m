//
//  PortScanner.m
//  portscandeluxe
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import "RPPortScanner.h"
#import "RPPortScanWorker.h"
#import "RPPortScanJob.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

static NSInteger const kNumberOfWorkers = 50;
static NSInteger const kIPSuffixMin = 2;
static NSInteger const kIPSuffixMax = 254;

@interface RPPortScanner () <RPPortScanWorkerDelegate>

@property (nonatomic, assign) NSInteger totalPorts;
@property (nonatomic, strong) NSArray *workers;
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, strong) NSMutableArray *succeededJobs;
@property (nonatomic, assign) NSInteger totalJobs;

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation RPPortScanner

- (void)scanPorts:(NSArray *)ports {
    self.totalPorts = ports.count;
    self.jobs = [self generateJobsForPorts:ports];
    self.totalJobs = self.jobs.count;
    self.workers = [self generateWorkers:kNumberOfWorkers];
    
    if (kPortScanLogginEnabled) {
        NSLog(@"Jobs to perform: %ld", (long)self.totalJobs);
        NSLog(@"%ld workers standby", (long)self.workers.count);
    }
    
    [self distributeJobsToWorkers];
    
    [self startWorkers];
}

- (void)cancel {
    for (RPPortScanWorker *worker in self.workers) {
        [worker cancel];
    }
    [self.delegate portScannerDidFinish:self];
}

- (NSArray *)generateJobsForPorts:(NSArray *)ports {
    NSString *ipPrefix = [self baseIpAddress];
    NSMutableArray *jobs = [[NSMutableArray alloc] initWithCapacity:kIPSuffixMax - kIPSuffixMin];
    for (NSInteger ipSuffix = kIPSuffixMin; ipSuffix < kIPSuffixMax; ipSuffix++) {
        NSString *ipAddress = [NSString stringWithFormat:@"%@%ld", ipPrefix, (long)ipSuffix];
        for (NSNumber *port in ports) {
            NSString *portString = [NSString stringWithFormat:@"%ld", (long)port.integerValue];
            
            RPPortScanJob *job = [[RPPortScanJob alloc] initWithIPAddress:ipAddress andPort:portString];
            [jobs addObject:job];
        }
    }
    
    return [NSArray arrayWithArray:jobs];
}

- (NSArray *)generateWorkers:(NSInteger)count {
    NSMutableArray *workers = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger workerId = 0; workerId < count; workerId++) {
        RPPortScanWorker *worker = [[RPPortScanWorker alloc] initWithId:workerId];
        worker.delegate = self;
        [workers addObject:worker];
    }
    return [NSArray arrayWithArray:workers];
}

- (void)distributeJobsToWorkers {
    self.jobs = [self shuffleArray:self.jobs];
    NSInteger workerIndex = 0;
    for (NSInteger jobIndex = 0; jobIndex < self.jobs.count; jobIndex++) {
        RPPortScanJob *job = (self.jobs)[jobIndex];
        RPPortScanWorker *worker = (self.workers)[workerIndex];
        [worker addJob:job];
        
        workerIndex++;
        if (workerIndex == self.workers.count) {
            workerIndex = 0;
        }
    }
}

- (NSArray *)shuffleArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    NSUInteger count = mutableArray.count;
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSInteger n = arc4random_uniform(nElements) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [NSArray arrayWithArray:mutableArray];
}

- (void)startWorkers {
    self.startDate = [NSDate date];
    for (RPPortScanWorker *worker in self.workers) {
        if (kPortScanLogginEnabled) {
            NSLog(@"Starting worker %@", worker);
        }
        [worker start];
    }
}

- (NSString *)baseIpAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                NSString *interfaceName = @(temp_addr->ifa_name);
                if([interfaceName isEqualToString:@"en0"] || [interfaceName isEqualToString:@"en1"]) {
                    // Get NSString from C String
                    address = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr));
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    if (address && [address rangeOfString:@"."].location != NSNotFound) {
        NSArray *addressComponents = [address componentsSeparatedByString:@"."];
        address = @"";
        for (NSInteger index = 0; index < addressComponents.count - 1; index++) {
            address = [address stringByAppendingString:addressComponents[index]];
            address = [address stringByAppendingString:@"."];
        }
    }
    else {
        address = nil;
    }
    
    return address;
}

#pragma mark - PortScanThreadDelegate

- (void)portScanWorker:(RPPortScanWorker *)worker progressChanges:(float)progress {
    
    if (kPortScanLogginEnabled) {
        NSLog(@"%@ updated process: %.02f", worker, progress);
    }
    float totalProcess = 0;
    for (RPPortScanWorker *worker in self.workers) {
        totalProcess += worker.progress;
    }
    _progress = totalProcess / (float)self.workers.count;
    if (kPortScanLogginEnabled) {
        NSLog(@"Portscan progress: %.02f", self.progress);
    }
}

- (void)portScanWorker:(RPPortScanWorker *)worker jobFinishedSuccessfull:(RPPortScanJob *)job {
    if (kPortScanLogginEnabled) {
        NSLog(@"Worker %@ finished job %@", worker.name, job);
    }
    if (!self.succeededJobs) {
        self.succeededJobs = [NSMutableArray array];
    }
    [self.succeededJobs addObject:job];
    
    [self.delegate portScanner:self didFindPort:(job.port).integerValue onIPAddress:job.ipAddress];
}

- (void)portScanWorkerCompletedAllJobs:(RPPortScanWorker *)worker {
    if (self.progress == 100) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.startDate];
        NSLog(@"\n\nPORTSCAN COMPLETED.\nSCANNED %ld PORTS ON %d HOSTS USING %lu WORKERS (%ld JOBS IN TOTAL, %u JOBS A WORKER).\n%ld OUT OF %ld JOBS SUCCEEDED\nTOOK %.0f SECONDS\n\n", (long)self.totalPorts, kIPSuffixMax - kIPSuffixMin, (unsigned long)self.workers.count, (long)self.totalJobs, self.totalJobs / self.workers.count, (unsigned long)self.succeededJobs.count, (long)self.totalJobs, interval);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate portScannerDidFinish:self];
        });
    }
}

@end
