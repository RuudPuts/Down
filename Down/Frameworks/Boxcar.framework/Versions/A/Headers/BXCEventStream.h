/*
 
 Copyright (c) 2012-2017 ProcessOne SARL. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 THIS SOFTWARE IS PROVIDED BY PROCESSONE SARL ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL PROCESSONE SARL OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

@import UIKit;

@protocol BXCEventStreamDelegate <NSObject>
- (void)didReceiveEvent:(NSString *)event;
- (void)didReceiveError:(NSError *)error;
@end

@interface BXCEventStream : NSObject <NSURLConnectionDelegate>

@property(nonatomic, copy) NSString *streamId;
@property(nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;
@property(nonatomic) NSURLConnection *connection;
@property(nonatomic, unsafe_unretained) id <BXCEventStreamDelegate> delegate;

/* Init with stream ID */
- (id)initWithStreamId:(NSString *)streamId;

/* Connect to the API */
- (void)connect;

@end
