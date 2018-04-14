//
//  CreateClassManager.h
//  RPG
//
//  Created by james schuler on 4/11/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef CreateClassManager_h
#define CreateClassManager_h
#import "Hero.h"
#import "Barbarian.h"
#import "Rogue.h"
#import "Wizard.h"
#import "Constants.h"

@interface CreateClassManager : NSObject

+(Hero*)loadPartyMember:(NSDictionary*)aPartyMemberInfo;

@end
#endif /* CreateClassManager_h */
