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
+(Hero*)loadPartyMember:(NSDictionary*)aPartyMemberInfo {
   
    Hero *returnHero;
   
    NSString *className = aPartyMemberInfo[@"class"];
    // set classID based on class name
    if ([className isEqualToString:@"Barbarian"]) { // ID: 1
        returnHero = [[Barbarian alloc] loadPartyMemberHero:aPartyMemberInfo];
    } else if ([className isEqualToString:@"Rogue"]) { // ID: 3
        returnHero = [[Rogue alloc] loadPartyMemberHero:aPartyMemberInfo];
    } else if ([className isEqualToString:@"Wizard"]) { // ID: 2
        returnHero = [[Wizard alloc] loadPartyMemberHero:aPartyMemberInfo];
    }
    
    return returnHero;
}

@end
