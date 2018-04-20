//
//  Freezecone.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Freezecone.h"
@implementation Freezecone

int freezeconeResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _freezeconeResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.freezeconeResourceCost/100.0)*(float)totalResource); }

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"%i %@\nFreeze the enemy for %i COLD damage and causes the enemy to do 25%% less damage for 3 turns.", [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], [self getHeroDamageAverage]];
}

-(int)getHeroDamageAverage {
    return ((mainCharacter.level*5)+mainCharacter.inti)+([[mainCharacter getMH] attack]+
                                                          [[mainCharacter getOH] attack]);
}

-(int)getHeroDamage {
    return ((mainCharacter.level*5)+mainCharacter.inti)+([[mainCharacter getMH] getSwing]+
                                                          [[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Freezecone!!");
    
    /* Insert Damage */
    int damage = [self getHeroDamage];
    
    elementMap[self.skillElementSpec] = [NSNumber numberWithInt:damage];
    
    /* Take reduceed damage from enemy */
    e.enemyDebuffLibrary[FROZEN] = [[Buff alloc] initvalue:0 duration:3];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Freezecone...");
    
    /* Insert Damage */
    int damage = e.inti+(5*mainCharacter.level);
    
    elementMap[self.skillElementSpec] = [NSNumber numberWithInt:damage];
    
    /* Take reduceed damage from enemy */
    mainCharacter.combatDebuffLibrary[FROZEN] = [[Buff alloc] initvalue:0 duration:3];
}

@end
