//
//  Fireball.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fireball.h"
@implementation Fireball

int fireballResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _fireballResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.fireballResourceCost/100.0)*(float)totalResource); }

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"%i %@\nShoots a fireball at the enemy for %i FIRE damage. Chance to ignite the enemy for 3 turns.", [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], [self getHeroDamageAverage]];
}

-(int)getHeroDamageAverage {
    return ((mainCharacter.level*10)+mainCharacter.inti)+([[mainCharacter getMH] attack]+
                                                          [[mainCharacter getOH] attack]);
}

-(int)getHeroDamage {
    return ((mainCharacter.level*10)+mainCharacter.inti)+([[mainCharacter getMH] getSwing]+
                                                          [[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Fireball!!");
    
    /* Insert Damage */
    int damage = [self getHeroDamage];
    
    elementMap[self.skillElementSpec] = [NSNumber numberWithInt:damage];
    
    /* 20% Chance for Fire Dot */
    int isDot = arc4random_uniform(100);
    if (isDot < 20) {
        int dotDamage = mainCharacter.inti/2;
        e.enemyDebuffLibrary[FIREDOT] = [[Buff alloc] initvalue:dotDamage duration:3];
    }
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Fireball...");
    
    /* Insert Damage */
    int damage = e.inti+(5*mainCharacter.level);
    
    elementMap[self.skillElementSpec] = [NSNumber numberWithInt:damage];
    
    /* 20% Chance for Fire Dot */
    int isDot = arc4random_uniform(100);
    if (isDot < 20) {
        int dotDamage = e.inti/2;
        mainCharacter.combatDebuffLibrary[FIREDOT] = [[Buff alloc] initvalue:dotDamage duration:3];
    }
}

@end
