//
//  Heal.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Heal.h"
@implementation Heal

int healResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _healResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.healResourceCost/100.0)*(float)totalResource); }

-(NSString*)getMoveDescription {
    int totalThreeTurnHeal = [self getHeroHeal] *3;
    return [NSString stringWithFormat:@"%i %@\nHeals a friendly target for %i over 3 turns.",
            [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], totalThreeTurnHeal];
}

-(int)getHeroHeal {
    return -(mainCharacter.inti/2);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    /* Insert Heal Dot */
    int heal = [self getHeroHeal];
    
    mainCharacter.combatBuffLibrary[HEALDOT] = [[Buff alloc] initvalue:heal duration:3];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Heal...");
    
    /* Insert Heal Dot */
    int heal = -(e.inti/2);
    
    e.enemyBuffLibrary[HEALDOT] = [[Buff alloc] initvalue:heal duration:3];
    
}

@end
