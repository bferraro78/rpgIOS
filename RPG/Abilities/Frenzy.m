//
//  Frenzy.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Frenzy.h"
@implementation Frenzy

int frenzyResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _frenzyResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return 25; }

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"%i %@\nStrike the enemy for %i %s damage. Chance to swing for double damage.",
            [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], [self getHeroDamageAverage], [[mainCharacter getMH].weaponElement UTF8String]];
}

-(int)getHeroDamageAverage {
    return ((mainCharacter.level*15)+mainCharacter.inti)+([[mainCharacter getMH] attack]+
                                                         [[mainCharacter getOH] attack]);
}

-(int)getHeroDamage {
    return ((mainCharacter.level*15)+mainCharacter.strn)+([[mainCharacter getMH] getSwing]+
                                                         [[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Frenzy!!");
    
    /* Insert Damage */
    int damage = [self getHeroDamage];
    
    int isDS = arc4random_uniform(100);
    if (isDS < 15) {
        printf("Double Strike");
        damage *= 2;
    }
    
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Frenzy...");
    
    /* Insert Damage */
    int damage = e.enemyStrn+(10*mainCharacter.level);
    
    int isDS = arc4random_uniform(100);
    if (isDS < 15) {
        printf("Enemy Double Strikes");
        damage *= 2;
    }
    
    NSString *element = e.enemyElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
}

@end
