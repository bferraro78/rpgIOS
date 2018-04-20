//
//  CreateClassManager.m
//  RPG
//
//  Created by james schuler on 4/11/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateClassManager.h"

@implementation CreateClassManager

/* Create a Hero object based on stats sent from another player */
+(Being*)loadPartyMemberBeing:(NSDictionary*)aPartyMemberInfo {
   
    Being *returnBeing;
   
    NSString *className = aPartyMemberInfo[@"class"];
    // set classID based on class name
    if ([className isEqualToString:BARBARIAN]) { // ID: 1
        returnBeing = [[Barbarian alloc] loadPartyMemberHero:aPartyMemberInfo];
    } else if ([className isEqualToString:ROGUE]) { // ID: 3
        returnBeing = [[Rogue alloc] loadPartyMemberHero:aPartyMemberInfo];
    } else if ([className isEqualToString:WIZARD]) { // ID: 2
        returnBeing = [[Wizard alloc] loadPartyMemberHero:aPartyMemberInfo];
    } else if ([className isEqualToString:ENEMY]) {
        returnBeing = [[Enemy alloc] loadEnemyBeingFromDictionary:aPartyMemberInfo];
    }
    
    return returnBeing;
}

@end
