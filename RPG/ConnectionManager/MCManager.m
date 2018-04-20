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

+(MCManager*)getMCManager {
    static MCManager *MCManager = nil; // only called first time?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        MCManager = [[self alloc] init];
    });
    return MCManager;
}

-(id)init {
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
    dict[@"peerID"] = peerID;
    
    // Change data over to a iOS readable dictionary
    NSError* error;
    NSDictionary *receivedData = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    dict[@"receivedData"] = receivedData;  

    if ([receivedData[@"action"] isEqualToString:@"readyCheck"]) { // a ready check
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readyCheckNotification"
                                                            object:nil
                                                          userInfo:dict];
    } else if ([receivedData[@"action"] isEqualToString:@"createPartyMember"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createPartyMemberNotification"
                                                            object:nil
                                                          userInfo:dict];
    } else if ([receivedData[@"action"] isEqualToString:@"startDungeon"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EnterDungeonNotification"
                                                            object:nil
                                                          userInfo:dict];
    } else if ([receivedData[@"action"] isEqualToString:@"updatePartyMemberHero"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePartyMemberHeroNotification"
                                                            object:nil
                                                          userInfo:dict];
    } else if ([receivedData[@"action"] isEqualToString:@"loadCombatOrderAndEnemyParty"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadCombatOrderAndEnemyPartyNotification"
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
