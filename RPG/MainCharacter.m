//
//  MainCharacter.m
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainCharacter.h"
@implementation MainCharacter
/* Wrapper class for our mainCharacter Hero* class. MainCharacter is available as a global to al classes */
// Need to put here due to a linker error
Hero *mainCharacter;

extern NSString* const FIRE;
extern NSString* const COLD;
extern NSString* const ARCANE;
extern NSString* const LIGHTNING;
extern NSString* const POISION;
extern NSString* const PHYSICAL;

@end
