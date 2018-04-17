//
//  Rend.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rend.h"
@implementation Rend

int rendResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _rendResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return 10; }

-(NSString*)getMoveDescription {
    int totalThreeTurnDamage = [self getHeroDamageAverage] *3;
    return [NSString stringWithFormat:@"%i %@\nGouges the enemy for %i %s damage over 3 turns.",
            [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], totalThreeTurnDamage, [[mainCharacter getMH].weaponElement UTF8String]];
}

-(int)getHeroDamageAverage {
    return (mainCharacter.strn/2)+([[mainCharacter getMH] attack]+[[mainCharacter getOH] attack]);
}


-(int)getHeroDamage {
    return (mainCharacter.strn/2)+([[mainCharacter getMH] getSwing]+[[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Rend!!");
    
    /* Insert Rend Dot */
    int damage = [self getHeroDamage];
    
    e.enemyDebuffLibrary[RENDDOT] = [[Buff alloc] initvalue:damage duration:3];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Rend...");
    
    /* Insert Rend Dot */
    int damage = (e.enemyStrn/2)+(mainCharacter.level*3);
    
    mainCharacter.combatBuffLibrary[RENDDOT] = [[Buff alloc] initvalue:damage duration:3];
    
}

@end
