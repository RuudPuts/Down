//
//  PortScanner.h
//  portscandeluxe
//
//  Created by Ruud Puts on 25/04/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL const kPortScanLogginEnabled = NO;

@protocol RPPortScannerDelegate;

@interface RPPortScanner : NSObject

@property (nonatomic, assign, readonly) float progress;
@property (nonatomic, assign) NSObject<RPPortScannerDelegate> *delegate;

- (void)scanPorts:(NSArray *)ports;
- (void)cancel;

@end

@protocol RPPortScannerDelegate <NSObject>

- (void)portScanner:(RPPortScanner *)portScanner didFindPort:(NSInteger)port onIPAddress:(NSString *)ipAddress;
- (void)portScannerDidFinish:(RPPortScanner *)portScanner;

@end