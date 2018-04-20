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
#import "Enemy.h"
#import "Constants.h"

@interface CreateClassManager : NSObject

+(Being*)loadPartyMemberBeing:(NSDictionary*)aPartyMemberInfo;

@end
#endif /* CreateClassManager_h */
