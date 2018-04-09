//
//  MainCharacter.h
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef MainCharacter_h
#define MainCharacter_h
#import "Hero.h"

@interface MainCharacter : NSObject

// Usable by all classes who import "MainCharacter.h"
extern Hero *mainCharacter;

@end

#endif /* MainCharacter_h */
