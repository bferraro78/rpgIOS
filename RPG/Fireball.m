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

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _fireballResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.fireballResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap {
    printf("Fireball!!");
    
    /* Insert Damage */
    int damage = ((mainCharacter.level*10)+mainCharacter.inti)+([[mainCharacter getMH] getSwing]+
                                                                [[mainCharacter getOH] getSwing]);
    
    elementMap[@"FIRE"] = [NSNumber numberWithInt:damage];
    
    /* 20% Chance for Fire Dot */
    int isDot = arc4random_uniform(100);
    if (isDot < 20) {
        int dotDamage = mainCharacter.inti/2;
        mainCharacter.buffLibrary[@"fireDot"] = [[Buff alloc] initvalue:dotDamage duration:3];
    }
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    printf("Enemey uses Fireball...");
    
    /* Insert Damage */
    int damage = e.enemyInti+(5*mainCharacter.level);
    
    elementMap[@"FIRE"] = [NSNumber numberWithInt:damage];
    
    /* 20% Chance for Fire Dot */
    int isDot = arc4random_uniform(100);
    if (isDot < 20) {
        int dotDamage = e.enemyInti/2;
        e.enemyBuffLibrary[@"fireDot"] = [[Buff alloc] initvalue:dotDamage duration:3];
    }
}







@end