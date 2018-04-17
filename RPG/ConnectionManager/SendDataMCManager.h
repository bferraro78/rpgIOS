//
//  SendDataMCManager.h
//  RPG
//
//  Created by james schuler on 4/14/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef SendDataMCManager_h
#define SendDataMCManager_h
#import "MCManager.h"

@interface SendDataMCManager : NSObject

+(SendDataMCManager*)getSender;

-(void)sendDictionaryOfInfo:(NSMutableDictionary*)dictionaryToSend;
-(void)sendReadyCheck:(NSString*)readyString;
-(void)sendStartDungeon;

@end

#endif /* SendDataMCManager_h */
