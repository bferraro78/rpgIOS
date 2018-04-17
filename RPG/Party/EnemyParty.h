//
//  EnemyParty.h
//  RPG
//
//  Created by james schuler on 4/16/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EnemyParty_h
#define EnemyParty_h
#import "Enemy.h"

/** An array of enemies, used for combat **/
@interface EnemyParty : NSObject

@property (nonatomic, strong) NSMutableArray *EnemyPartyArray;

@end

#endif /* EnemyParty_h */
