//
//  RPPortScanJob.m
//  Down
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import "RPPortScanJob.h"

@implementation RPPortScanJob

- (RPPortScanJob *)initWithIPAddress:(NSString *)ipAddress andPort:(NSString *)port {
    self = [super init];
    if (self) {
        _ipAddress = ipAddress;
        _port = port;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{ IPAddress: %@, Port: %@ }", self.ipAddress, self.port];
}

@end
