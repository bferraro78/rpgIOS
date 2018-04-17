//
//  Freezecone.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Freezecone_h
#define Freezecone_h
#import "Enemy.h"
#import "Skill.h"
#import "Buff.h"

@interface Freezecone : Skill

@property int freezeconeResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;

-(int)getCombatResourceCost:(int)totalResource;
-(NSString*)getMoveDescription;
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;


@end

#endif /* Freezecone_h */
