//
//  MCManager.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCManager.h"

@implementation MCManager

-(id)init{
    self = [super init];
    
    if (self) {
        _peerID = nil;
        _session = nil;
        _browser = nil;
        _advertiser = nil;
    }
    
    return self;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

-(void)setupMCBrowser { _browser = [[MCBrowserViewController alloc] initWithServiceType:@"party-up" session:_session]; }
-(void)advertiseSelf:(BOOL)shouldAdvertise {
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"party-up"
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}


/** DELEGATES **/

/* The first method is called when a peer changes its state, meaning when it’s connected or disconnected. There are three states: MCSessionStateConnected, MCSessionStateConnecting and MCSessionStateNotConnected. The last state is valid even when a peer gets disconnected from our session. Generally this delegate method is called when the peer state is modified.  In this tutorial we’ll use all of them, except for the last one. */
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}

/**
 Did receive data is going to call all notification function across all ViewControllers
**/

/* The second delegate method is called when new data arrives from a peer. Remember that three kinds of data can be exchanged; messages, streaming and resources. This one is the delegate for messages. The next couple of methods are called when a resource is received */
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    dict[@"data"] = data;
    dict[@"peerID"] = peerID;
    dict[@"receivedString"] = receivedString;
    
    if ([receivedString containsString:@"READY"]) { // a ready check
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyCheckNotification"
                                                            object:nil
                                                          userInfo:dict];
    }
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

/* Invoked for incoming streams */
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}




@end
