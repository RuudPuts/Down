//
//  RPPortScanJob.h
//  Down
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPPortScanJob : NSObject

- (RPPortScanJob *)initWithIPAddress:(NSString *)ipAddress andPort:(NSString *)port;

@property (nonatomic, strong, readonly) NSString *ipAddress;
@property (nonatomic, strong, readonly) NSString *port;

@end
