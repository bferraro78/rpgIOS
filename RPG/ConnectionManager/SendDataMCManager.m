//
//  SendDataMCManager.m
//  RPG
//
//  Created by james schuler on 4/14/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendDataMCManager.h"
@implementation SendDataMCManager

#pragma mark Singleton Methods

+(SendDataMCManager*)getSender {
    static SendDataMCManager *Sender = nil; // only called first time?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Sender = [[self alloc] init];
    });
    return Sender;
}

-(id)init {
    return self;
}



-(void)sendDictionaryOfInfo:(NSMutableDictionary*)dictionaryToSend {
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:dictionaryToSend options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                       toPeers:allPeers
                                      withMode:MCSessionSendDataReliable
                                         error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)sendReadyCheck:(NSString*)readyString {
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:[self packageReadyCheck:readyString] options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                       toPeers:allPeers
                                      withMode:MCSessionSendDataReliable
                                         error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(NSMutableDictionary*)packageReadyCheck:(NSString*)readyString {
    NSMutableDictionary *readyCheckDictionary = [[NSMutableDictionary alloc] init];
    readyCheckDictionary[@"action"] = @"readyCheck";
    readyCheckDictionary[@"readyCheck"] = readyString;
    return readyCheckDictionary;
}

-(void)sendStartDungeon {
    NSData* dataToSend = [NSJSONSerialization dataWithJSONObject:[self sendStartDungeonDictionary] options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                       toPeers:allPeers
                                      withMode:MCSessionSendDataReliable
                                         error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(NSMutableDictionary*)sendStartDungeonDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"action"] = @"startDungeon";
    return jsonable;
}

@end
