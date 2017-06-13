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

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _frenzyResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.frenzyResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Frenzy!!");
    
    /* Insert Damage */
    int damage = ((mainCharacter.level*15)+mainCharacter.strn)+([[mainCharacter getMH] getSwing]+
                                                                [[mainCharacter getOH] getSwing]);
    int isDS = arc4random_uniform(100);
    if (isDS < 15) {
        printf("Double Strike");
        damage *= 2;
    }
    
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
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